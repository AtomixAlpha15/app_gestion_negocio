import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_database.dart';
import 'sync_service.dart';

class SyncRepository {
  final AppDatabase db;

  SyncRepository({required this.db});

  String get _lastSyncKey {
    final uid = db.userId;
    return (uid != null && uid.isNotEmpty) ? '${uid}_last_sync' : 'last_sync_timestamp';
  }

  // ── Last sync timestamp ──────────────────────────────────────────────────

  Future<DateTime> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_lastSyncKey);
    if (ms == null) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> saveLastSync(DateTime dt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastSyncKey, dt.millisecondsSinceEpoch);
  }

  Future<void> resetLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSyncKey);
  }

  // Devuelve true si las tablas sincronizables están vacías localmente.
  // Usado como salvaguarda para forzar descarga completa cuando la BD local
  // está limpia pero el lastSync de SharedPreferences quedó con valor antiguo.
  Future<bool> isLocalDataEmpty() async {
    final clientesCount = await db.customSelect('SELECT COUNT(*) AS c FROM clientes').getSingle();
    if ((clientesCount.data['c'] as int) > 0) return false;
    final serviciosCount = await db.customSelect('SELECT COUNT(*) AS c FROM servicios').getSingle();
    if ((serviciosCount.data['c'] as int) > 0) return false;
    final citasCount = await db.customSelect('SELECT COUNT(*) AS c FROM citas').getSingle();
    if ((citasCount.data['c'] as int) > 0) return false;
    final bonosCount = await db.customSelect('SELECT COUNT(*) AS c FROM bonos').getSingle();
    if ((bonosCount.data['c'] as int) > 0) return false;
    final consumosCount = await db.customSelect('SELECT COUNT(*) AS c FROM bono_consumos').getSingle();
    if ((consumosCount.data['c'] as int) > 0) return false;
    final pagosCount = await db.customSelect('SELECT COUNT(*) AS c FROM bono_pagos').getSingle();
    if ((pagosCount.data['c'] as int) > 0) return false;
    final gastosCount = await db.customSelect('SELECT COUNT(*) AS c FROM gastos').getSingle();
    if ((gastosCount.data['c'] as int) > 0) return false;
    return true;
  }

  // ── Leer cambios locales desde lastSync ──────────────────────────────────

  Future<List<SyncChange>> getLocalChanges(DateTime since) async {
    final changes = <SyncChange>[];

    changes.addAll(await _clientesChanges(since));
    changes.addAll(await _serviciosChanges(since));
    changes.addAll(await _citasChanges(since));
    changes.addAll(await _bonosChanges(since));
    changes.addAll(await _bonoConsumosChanges(since));
    changes.addAll(await _bonoPagosChanges(since));
    changes.addAll(await _gastosChanges(since));

    return changes;
  }

  Future<List<SyncChange>> _clientesChanges(DateTime since) async {
    final rows = await (db.select(db.clientes)
      ..where((t) => t.updatedAt.isBiggerThanValue(since))).get();

    return rows.map((r) => SyncChange(
      entityType: 'clientes',
      action: r.deleted ? 'delete' : (r.createdAt != null && r.createdAt!.isAfter(since) ? 'create' : 'update'),
      id: r.id,
      syncId: r.syncId ?? r.id,
      data: {
        'id': r.id,
        'nombre': r.nombre,
        'telefono': r.telefono,
        'email': r.email,
        'notas': r.notas,
        'deleted': r.deleted,
        'created_at': r.createdAt?.toIso8601String(),
        'updated_at': r.updatedAt?.toIso8601String(),
        'sync_id': r.syncId ?? r.id,
      },
    )).toList();
  }

  Future<List<SyncChange>> _serviciosChanges(DateTime since) async {
    final rows = await (db.select(db.servicios)
      ..where((t) => t.updatedAt.isBiggerThanValue(since))).get();

    return rows.map((r) => SyncChange(
      entityType: 'servicios',
      action: r.deleted ? 'delete' : (r.createdAt != null && r.createdAt!.isAfter(since) ? 'create' : 'update'),
      id: r.id,
      syncId: r.syncId ?? r.id,
      data: {
        'id': r.id,
        'nombre': r.nombre,
        'descripcion': r.descripcion,
        'precio_base': r.precio,
        'duracion_minutos': r.duracionMinutos,
        'activo': true,
        'deleted': r.deleted,
        'created_at': r.createdAt?.toIso8601String(),
        'updated_at': r.updatedAt?.toIso8601String(),
        'sync_id': r.syncId ?? r.id,
      },
    )).toList();
  }

  Future<List<SyncChange>> _citasChanges(DateTime since) async {
    final rows = await (db.select(db.citas)
      ..where((t) => t.updatedAt.isBiggerThanValue(since))).get();

    return rows.map((r) {
      final duracion = r.fin.difference(r.inicio).inMinutes;
      return SyncChange(
        entityType: 'citas',
        action: r.deleted ? 'delete' : (r.createdAt != null && r.createdAt!.isAfter(since) ? 'create' : 'update'),
        id: r.id,
        syncId: r.syncId ?? r.id,
        data: {
          'id': r.id,
          'cliente_id': r.clienteId,
          'servicio_id': r.servicioId,
          'fecha': r.inicio.toIso8601String(),
          'duracion_minutos': duracion,
          'precio': r.precio,
          'metodo_pago': r.metodoPago ?? 'efectivo',
          'notas': r.notas,
          'completada': r.pagada,
          'deleted': r.deleted,
          'created_at': r.createdAt?.toIso8601String(),
          'updated_at': r.updatedAt?.toIso8601String(),
          'sync_id': r.syncId ?? r.id,
        },
      );
    }).toList();
  }

  Future<List<SyncChange>> _bonosChanges(DateTime since) async {
    final rows = await (db.select(db.bonos)
      ..where((t) => t.updatedAt.isBiggerThanValue(since))).get();

    return rows.map((r) => SyncChange(
      entityType: 'bonos',
      action: r.deleted ? 'delete' : (r.createdAt != null && r.createdAt!.isAfter(since) ? 'create' : 'update'),
      id: r.id,
      syncId: r.syncId ?? r.id,
      data: {
        'id': r.id,
        'cliente_id': r.clienteId,
        // servicio_id puede ser cadena vacía en datos antiguos; enviamos null
        // en ese caso para que el FK del backend (ON DELETE SET NULL) acepte.
        'servicio_id': r.servicioId.isEmpty ? null : r.servicioId,
        'nombre': r.nombre,
        'sesiones_totales': r.sesionesTotales,
        'sesiones_usadas': r.sesionesUsadas,
        'reconocimiento': r.reconocimiento,
        'precio': r.precioBono ?? 0.0,
        'metodo_pago': 'efectivo',
        'fecha_compra': r.compradoEl.toIso8601String(),
        'caduca_el': r.caducaEl?.toIso8601String(),
        'activo': r.activo,
        'deleted': r.deleted,
        'created_at': r.createdAt?.toIso8601String(),
        'updated_at': r.updatedAt?.toIso8601String(),
        'sync_id': r.syncId ?? r.id,
      },
    )).toList();
  }

  Future<List<SyncChange>> _bonoConsumosChanges(DateTime since) async {
    final rows = await (db.select(db.bonoConsumos)
      ..where((t) => t.updatedAt.isBiggerThanValue(since))).get();

    return rows.map((r) => SyncChange(
      entityType: 'bono_consumos',
      action: r.deleted ? 'delete' : (r.createdAt != null && r.createdAt!.isAfter(since) ? 'create' : 'update'),
      id: r.id,
      syncId: r.syncId ?? r.id,
      data: {
        'id': r.id,
        'bono_id': r.bonoId,
        'cita_id': r.citaId,
        'fecha': r.fecha.toIso8601String(),
        'nota': r.nota,
        'deleted': r.deleted,
        'created_at': r.createdAt?.toIso8601String(),
        'updated_at': r.updatedAt?.toIso8601String(),
        'sync_id': r.syncId ?? r.id,
      },
    )).toList();
  }

  Future<List<SyncChange>> _bonoPagosChanges(DateTime since) async {
    final rows = await (db.select(db.bonoPagos)
      ..where((t) => t.updatedAt.isBiggerThanValue(since))).get();

    return rows.map((r) => SyncChange(
      entityType: 'bono_pagos',
      action: r.deleted ? 'delete' : (r.createdAt != null && r.createdAt!.isAfter(since) ? 'create' : 'update'),
      id: r.id,
      syncId: r.syncId ?? r.id,
      data: {
        'id': r.id,
        'bono_id': r.bonoId,
        'importe': r.importe,
        'metodo': r.metodo,
        'fecha': r.fecha.toIso8601String(),
        'nota': r.nota,
        'deleted': r.deleted,
        'created_at': r.createdAt?.toIso8601String(),
        'updated_at': r.updatedAt?.toIso8601String(),
        'sync_id': r.syncId ?? r.id,
      },
    )).toList();
  }

  Future<List<SyncChange>> _gastosChanges(DateTime since) async {
    final rows = await (db.select(db.gastos)
      ..where((t) => t.updatedAt.isBiggerThanValue(since))).get();

    return rows.map((r) => SyncChange(
      entityType: 'gastos',
      action: r.deleted ? 'delete' : (r.createdAt != null && r.createdAt!.isAfter(since) ? 'create' : 'update'),
      id: r.id,
      syncId: r.syncId ?? r.id,
      data: {
        'id': r.id,
        'concepto': r.concepto,
        'precio': r.precio,
        'fecha': r.fecha.toIso8601String(),
        'deleted': r.deleted,
        'created_at': r.createdAt?.toIso8601String(),
        'updated_at': r.updatedAt?.toIso8601String(),
        'sync_id': r.syncId ?? r.id,
      },
    )).toList();
  }

  // PostgreSQL NUMERIC/DECIMAL llega como String desde la librería pg de Node.js
  double _toDouble(dynamic v, {double fallback = 0.0}) {
    if (v == null) return fallback;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? fallback;
  }

  // ── Aplicar cambios del servidor al SQLite local ─────────────────────────

  Future<void> applyServerChanges(List<SyncChange> changes) async {
    for (final change in changes) {
      try {
        switch (change.entityType) {
          case 'clientes':
            await _applyCliente(change);
          case 'servicios':
            await _applyServicio(change);
          case 'citas':
            await _applyCita(change);
          case 'bonos':
            await _applyBono(change);
          case 'bono_consumos':
            await _applyBonoConsumo(change);
          case 'bono_pagos':
            await _applyBonoPago(change);
          case 'gastos':
            await _applyGasto(change);
        }
      } catch (e, stack) {
        debugPrint('[Sync] ERROR aplicando ${change.entityType}/${change.id}: $e');
        debugPrint('[Sync] Data recibida: ${change.data}');
        debugPrint('[Sync] Stack: $stack');
      }
    }
  }

  Future<void> _applyCliente(SyncChange change) async {
    final d = change.data;
    final companion = ClientesCompanion(
      id: Value(d['id']),
      nombre: Value(d['nombre'] ?? ''),
      telefono: Value(d['telefono']),
      email: Value(d['email']),
      notas: Value(d['notas']),
      deleted: Value(d['deleted'] ?? false),
      syncId: Value(d['sync_id']),
      updatedAt: Value(d['updated_at'] != null ? DateTime.parse(d['updated_at']) : DateTime.now()),
      createdAt: Value(d['created_at'] != null ? DateTime.parse(d['created_at']) : DateTime.now()),
    );
    await db.into(db.clientes).insertOnConflictUpdate(companion);
  }

  Future<void> _applyServicio(SyncChange change) async {
    final d = change.data;
    final companion = ServiciosCompanion(
      id: Value(d['id']),
      nombre: Value(d['nombre'] ?? ''),
      descripcion: Value(d['descripcion']),
      precio: Value(_toDouble(d['precio_base'])),
      duracionMinutos: Value(d['duracion_minutos'] ?? 60),
      deleted: Value(d['deleted'] ?? false),
      syncId: Value(d['sync_id']),
      updatedAt: Value(d['updated_at'] != null ? DateTime.parse(d['updated_at']) : DateTime.now()),
      createdAt: Value(d['created_at'] != null ? DateTime.parse(d['created_at']) : DateTime.now()),
    );
    await db.into(db.servicios).insertOnConflictUpdate(companion);
  }

  Future<void> _applyCita(SyncChange change) async {
    final d = change.data;
    final inicio = DateTime.parse(d['fecha']);
    final duracion = d['duracion_minutos'] as int? ?? 60;
    final fin = inicio.add(Duration(minutes: duracion));
    final companion = CitasCompanion(
      id: Value(d['id']),
      clienteId: Value(d['cliente_id']),
      servicioId: Value(d['servicio_id']),
      inicio: Value(inicio),
      fin: Value(fin),
      precio: Value(_toDouble(d['precio'])),
      pagada: Value(d['completada'] ?? false),
      metodoPago: Value(d['metodo_pago']),
      notas: Value(d['notas']),
      deleted: Value(d['deleted'] ?? false),
      syncId: Value(d['sync_id']),
      updatedAt: Value(d['updated_at'] != null ? DateTime.parse(d['updated_at']) : DateTime.now()),
      createdAt: Value(d['created_at'] != null ? DateTime.parse(d['created_at']) : DateTime.now()),
    );
    await db.into(db.citas).insertOnConflictUpdate(companion);
  }

  Future<void> _applyBono(SyncChange change) async {
    final d = change.data;
    // servicio_id puede venir null del servidor (FK con ON DELETE SET NULL,
    // o bonos antiguos sin servicio). Si la fila ya existe localmente y el
    // servidor envía null, preservamos el local; si no, usamos lo del servidor.
    String servicioIdToUse;
    if (d['servicio_id'] != null) {
      servicioIdToUse = d['servicio_id'] as String;
    } else {
      final existing = await (db.select(db.bonos)..where((b) => b.id.equals(d['id']))).getSingleOrNull();
      servicioIdToUse = existing?.servicioId ?? '';
    }

    final companion = BonosCompanion(
      id: Value(d['id']),
      clienteId: Value(d['cliente_id']),
      servicioId: Value(servicioIdToUse),
      nombre: Value(d['nombre'] ?? 'Bono'),
      sesionesTotales: Value(d['sesiones_totales'] ?? 1),
      sesionesUsadas: Value(d['sesiones_usadas'] ?? 0),
      precioBono: Value(d['precio'] != null ? _toDouble(d['precio']) : null),
      compradoEl: d['fecha_compra'] != null
          ? Value(DateTime.parse(d['fecha_compra']))
          : const Value.absent(),
      caducaEl: Value(d['caduca_el'] != null ? DateTime.parse(d['caduca_el']) : null),
      reconocimiento: Value(d['reconocimiento'] ?? 'prorrateado'),
      activo: Value(d['activo'] ?? true),
      deleted: Value(d['deleted'] ?? false),
      syncId: Value(d['sync_id']),
      updatedAt: Value(d['updated_at'] != null ? DateTime.parse(d['updated_at']) : DateTime.now()),
      createdAt: Value(d['created_at'] != null ? DateTime.parse(d['created_at']) : DateTime.now()),
    );
    await db.into(db.bonos).insertOnConflictUpdate(companion);
  }

  Future<void> _applyBonoConsumo(SyncChange change) async {
    final d = change.data;
    final companion = BonoConsumosCompanion(
      id: Value(d['id']),
      bonoId: Value(d['bono_id']),
      citaId: Value(d['cita_id']),
      fecha: Value(d['fecha'] != null ? DateTime.parse(d['fecha']) : DateTime.now()),
      nota: Value(d['nota']),
      deleted: Value(d['deleted'] ?? false),
      syncId: Value(d['sync_id']),
      updatedAt: Value(d['updated_at'] != null ? DateTime.parse(d['updated_at']) : DateTime.now()),
      createdAt: Value(d['created_at'] != null ? DateTime.parse(d['created_at']) : DateTime.now()),
    );
    await db.into(db.bonoConsumos).insertOnConflictUpdate(companion);
  }

  Future<void> _applyBonoPago(SyncChange change) async {
    final d = change.data;
    final companion = BonoPagosCompanion(
      id: Value(d['id']),
      bonoId: Value(d['bono_id']),
      importe: Value(_toDouble(d['importe'])),
      metodo: Value(d['metodo']),
      fecha: Value(d['fecha'] != null ? DateTime.parse(d['fecha']) : DateTime.now()),
      nota: Value(d['nota']),
      deleted: Value(d['deleted'] ?? false),
      syncId: Value(d['sync_id']),
      updatedAt: Value(d['updated_at'] != null ? DateTime.parse(d['updated_at']) : DateTime.now()),
      createdAt: Value(d['created_at'] != null ? DateTime.parse(d['created_at']) : DateTime.now()),
    );
    await db.into(db.bonoPagos).insertOnConflictUpdate(companion);
  }

  Future<void> _applyGasto(SyncChange change) async {
    final d = change.data;
    final companion = GastosCompanion(
      id: Value(d['id']),
      concepto: Value(d['concepto'] ?? ''),
      precio: Value(_toDouble(d['precio'])),
      fecha: Value(d['fecha'] != null ? DateTime.parse(d['fecha']) : DateTime.now()),
      deleted: Value(d['deleted'] ?? false),
      syncId: Value(d['sync_id']),
      updatedAt: Value(d['updated_at'] != null ? DateTime.parse(d['updated_at']) : DateTime.now()),
      createdAt: Value(d['created_at'] != null ? DateTime.parse(d['created_at']) : DateTime.now()),
    );
    await db.into(db.gastos).insertOnConflictUpdate(companion);
  }
}
