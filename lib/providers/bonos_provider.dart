import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../services/app_database.dart';
import 'package:drift/drift.dart' as d;
import 'package:uuid/uuid.dart';

class BonosProvider extends ChangeNotifier {
  final AppDatabase db;
  BonosProvider(this.db);

  // Generar UUID para todos los IDs
  String _id() => const Uuid().v4();

  Future<String> crearBonoSesiones({
    required String clienteId,
    required String servicioId,
    required int sesiones, // 1..30
    String? nombre,
    double? precioBono,
    DateTime? caducaEl,
  }) async {
    final id = _id();
    final now = DateTime.now();
    final bono = BonosCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      servicioId: Value(servicioId),
      nombre: Value(nombre ?? 'Bono ${sesiones} sesiones'),
      sesionesTotales: Value(sesiones),
      precioBono: Value(precioBono),
      caducaEl: Value(caducaEl),
      activo: const Value(true),
      sesionesUsadas: const Value(0),
      creadoEl: Value(now),
      syncId: Value(_id()),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    await db.into(db.bonos).insert(bono);
    notifyListeners();
    return id;
  }


/// Bonos disponibles para consumir en una nueva cita
/// - Del cliente indicado
/// - Del servicio indicado
/// - Marcados como activos
/// - No caducados (caducaEl >= hoy o sin caducidad)
/// - Con sesiones pendientes (sesionesUsadas < sesionesTotales)
Future<List<Bono>> bonosActivosClienteServicio(String clienteId, String servicioId) async {
  final now = DateTime.now();
  final hoy = DateTime(now.year, now.month, now.day);

  final query = db.select(db.bonos)
    ..where((b) =>
      b.clienteId.equals(clienteId) &
      b.servicioId.equals(servicioId) &
      b.activo.equals(true) &
      b.deleted.equals(false) &
      (
        b.caducaEl.isNull() |
        b.caducaEl.isBiggerOrEqualValue(hoy)
      ) &
      b.sesionesUsadas.isSmallerThan(b.sesionesTotales)
    );

  return query.get();
}


  /// ⬇️ NUEVO: Devuelve el primer bono activo disponible (o null)
  Future<Bono?> obtenerBonoActivo(String clienteId, String servicioId) async {
    final list = await bonosActivosClienteServicio(clienteId, servicioId);
    if (list.isEmpty) return null;
    return list.first;
  }

  /// Consume 1 sesión del primer bono activo disponible para este cliente/servicio.
  /// Si consume, actualiza la cita a metodoPago='Bono'.
  Future<bool> aplicarBonoSiDisponible({
    required String clienteId,
    required String servicioId,
    required Cita cita,
  }) async {
    final activos = await bonosActivosClienteServicio(clienteId, servicioId);
    if (activos.isEmpty) return false;

    final bono = activos.first; // estrategia simple: el primero

    // Lo hacemos todo dentro de una transacción por seguridad
    await db.transaction(() async {
      final now = DateTime.now();

      // 1) marcar la cita como pagada con bono
      await (db.update(db.citas)..where((c) => c.id.equals(cita.id))).write(
        CitasCompanion(metodoPago: const Value('Bono'), updatedAt: Value(now)),
      );

      // 2) registrar consumo
      await db.into(db.bonoConsumos).insert(BonoConsumosCompanion(
        id: Value(_id()),
        bonoId: Value(bono.id),
        citaId: Value(cita.id),
        fecha: Value(now),
        syncId: Value(_id()),
        createdAt: Value(now),
        updatedAt: Value(now),
      ));

      // 3) subir contador de sesiones usadas
      await (db.update(db.bonos)..where((b) => b.id.equals(bono.id))).write(
        BonosCompanion(
          sesionesUsadas: Value(bono.sesionesUsadas + 1),
          updatedAt: Value(now),
        ),
      );
    });

    // 4) Recalcular estado ACTIVO/INACTIVO según:
    //    - sesiones usadas vs totales
    //    - si quedan citas futuras asociadas al bono
    await _recalcularEstadoBono(bono.id);

    return true;
  }


  /// Bonos activos (cualquier servicio) del cliente
  Future<List<Bono>> bonosActivosCliente(String clienteId) async {
    final now = DateTime.now();
    final q = db.select(db.bonos)
      ..where((b) =>
        b.clienteId.equals(clienteId) &
        b.activo.equals(true) &
        b.deleted.equals(false) &
        (b.caducaEl.isNull() | b.caducaEl.isBiggerOrEqualValue(now)) &
        (b.sesionesUsadas.isSmallerThan(b.sesionesTotales)));
    return q.get();
  }

  Future<List<Bono>> bonosCliente(String clienteId) {
    return (db.select(db.bonos)
          ..where((b) => b.clienteId.equals(clienteId) & b.deleted.equals(false)))
        .get();
  }

  Future<List<BonoConsumo>> consumosDeBono(String bonoId) {
    return (db.select(db.bonoConsumos)
          ..where((c) => c.bonoId.equals(bonoId) & c.deleted.equals(false)))
        .get();
  }

/// Selecciona bono activo con hueco (en base a sesiones ASIGNADAS)
Future<Bono?> bonoActivoPara(String clienteId, String servicioId) async {
  // Trae bonos activos del cliente/servicio, orden preferente por más antiguo
  final bonos = await (db.select(db.bonos)
        ..where((b) => b.clienteId.equals(clienteId) & b.servicioId.equals(servicioId) & b.activo.equals(true) & b.deleted.equals(false))
        ..orderBy([(b) => d.OrderingTerm.asc(b.creadoEl)]))
      .get();

  for (final bono in bonos) {
    final asignadas = await sesionesAsignadasBono(bono.id);
    if (asignadas < bono.sesionesTotales) return bono;
  }
  return null;
}

Future<void> eliminarBono(String bonoId) async {
  // Soft-delete para que la sincronización propague la eliminación al
  // servidor y otros dispositivos. Borrar físicamente impediría que el
  // sync lo viera (filas borradas no pueden viajar como cambios).
  final now = DateTime.now();
  await db.transaction(() async {
    await (db.update(db.bonoConsumos)..where((t) => t.bonoId.equals(bonoId))).write(
      BonoConsumosCompanion(deleted: const Value(true), updatedAt: Value(now)),
    );
    await (db.update(db.bonoPagos)..where((t) => t.bonoId.equals(bonoId))).write(
      BonoPagosCompanion(deleted: const Value(true), updatedAt: Value(now)),
    );
    await (db.update(db.bonos)..where((t) => t.id.equals(bonoId))).write(
      BonosCompanion(deleted: const Value(true), updatedAt: Value(now)),
    );
  });
  notifyListeners();
}

Future<void> actualizarActivo(String bonoId, bool activo) async {
  await (db.update(db.bonos)..where((t) => t.id.equals(bonoId)))
      .write(BonosCompanion(activo: Value(activo), updatedAt: Value(DateTime.now())));
  notifyListeners();
}

/////////////////////////////////// CONSUMOS DE BONO ////////////////////////////////////

Future<void> consumirSesion(String bonoId, String? citaId, DateTime? fecha) async {
  final now = DateTime.now();
  await db.into(db.bonoConsumos).insert(
    BonoConsumosCompanion(
      id: Value(_id()),
      bonoId: Value(bonoId),
      citaId: Value(citaId),
      fecha: Value(fecha ?? now),
      syncId: Value(_id()),
      createdAt: Value(now),
      updatedAt: Value(now),
    ),
  );

  await _recalcularBonoDesdeConsumos(bonoId);

  notifyListeners();
}



Future<bool> existeConsumoParaCita(String citaId) async {
  final q = db.selectOnly(db.bonoConsumos)
    ..addColumns([db.bonoConsumos.id.count()])
    ..where(db.bonoConsumos.citaId.equals(citaId) & db.bonoConsumos.deleted.equals(false));
  final row = await q.getSingleOrNull();
  final count = row?.read(db.bonoConsumos.id.count()) ?? 0;
  return count > 0;
}

Future<void> eliminarConsumoPorCita(String citaId) async {
  await db.transaction(() async {
    // 1) Buscar el consumo activo asociado a esa cita
    final consumo = await (db.select(db.bonoConsumos)
          ..where((t) => t.citaId.equals(citaId) & t.deleted.equals(false)))
        .getSingleOrNull();

    if (consumo == null) {
      return;
    }

    final bonoId = consumo.bonoId;

    // 2) Soft-delete del consumo (necesario para que el sync lo propague)
    await (db.update(db.bonoConsumos)..where((t) => t.id.equals(consumo.id))).write(
      BonoConsumosCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // 3) Recalcular el bono desde los consumos/pagos reales
    await _recalcularBonoDesdeConsumos(bonoId);
  });

  notifyListeners();
}



Future<void> _recalcularBonoDesdeConsumos(String bonoId) async {
  // 1) Leer el bono
  final bono = await (db.select(db.bonos)..where((b) => b.id.equals(bonoId))).getSingle();

  // 2) Leer TODOS los consumos activos del bono
  final consumos = await (db.select(db.bonoConsumos)
        ..where((bc) => bc.bonoId.equals(bonoId) & bc.deleted.equals(false)))
      .get();

  // sesiones usadas = nº de consumos
  final usadas = consumos.length;

  // 3) Fecha de referencia (solo día)
  final now = DateTime.now();
  final hoy = DateTime(now.year, now.month, now.day);

  // 4) ¿Hay citas futuras asociadas a esos consumos?
  final consumosConCita = consumos.where((c) => c.citaId != null).toList();
  bool hayCitasFuturas = false;

  if (consumosConCita.isNotEmpty) {
    final citaIds = consumosConCita.map((c) => c.citaId!).toList();

    final citasFuturas = await (db.select(db.citas)
          ..where((c) =>
              c.id.isIn(citaIds) &
              c.inicio.isBiggerOrEqualValue(hoy)))
        .get();

    hayCitasFuturas = citasFuturas.isNotEmpty;
  }

  // 5) ¿Está pagado completamente?
  final precioTotal = bono.precioBono ?? 0.0;

  final pagos = await (db.select(db.bonoPagos)
        ..where((p) => p.bonoId.equals(bonoId) & p.deleted.equals(false)))
      .get();

  final totalPagado = pagos.fold<double>(0.0, (a, p) => a + p.importe);
  final pagadoCompletamente = totalPagado >= precioTotal;

  // 6) ¿Quedan sesiones?
  final quedanSesiones = usadas < bono.sesionesTotales;

  // 7) Regla final de "activo"
  //    ACTIVO si:
  //      - quedan sesiones, O
  //      - hay citas futuras, O
  //      - NO está pagado completamente
  final bool activo = quedanSesiones || hayCitasFuturas || !pagadoCompletamente;

  // 8) Actualizar bono
  await (db.update(db.bonos)..where((b) => b.id.equals(bonoId))).write(
    BonosCompanion(
      sesionesUsadas: Value(usadas),
      activo: Value(activo),
      updatedAt: Value(DateTime.now()),
    ),
  );
}


/// Sesiones asignadas actualmente (chips que muestras como usadas)
Future<int> sesionesAsignadasBono(String bonoId) async {
  final q = db.selectOnly(db.bonoConsumos)
    ..addColumns([db.bonoConsumos.id.count()])
    ..where(db.bonoConsumos.bonoId.equals(bonoId) & db.bonoConsumos.deleted.equals(false));
  final row = await q.getSingleOrNull();
  return row?.read(db.bonoConsumos.id.count()) ?? 0;
}

//Recalcula si las citas del bono se han consumido y son pasadas, es decir, si la ultima cita del bono es anterior
//a hoy para dar el bono por inactivo y no antes.

Future<void> _recalcularEstadoBono(String bonoId) async {
  // Leer el bono actual
  final bono = await (db.select(db.bonos)..where((b) => b.id.equals(bonoId))).getSingle();

  final now = DateTime.now();
  final hoy = DateTime(now.year, now.month, now.day);

  // ¿Quedan sesiones pendientes?
  final haySesionesPendientes = bono.sesionesUsadas < bono.sesionesTotales;

  // Buscar consumos activos de este bono que tengan citaId
  final consumos = await (db.select(db.bonoConsumos)
        ..where((bc) => bc.bonoId.equals(bonoId) & bc.citaId.isNotNull() & bc.deleted.equals(false)))
      .get();

  bool hayCitasFuturas = false;
  if (consumos.isNotEmpty) {
    final citaIds = consumos.map((c) => c.citaId!).toList();

    final citasFuturas = await (db.select(db.citas)
          ..where((c) =>
              c.id.isIn(citaIds) &
              c.inicio.isBiggerOrEqualValue(hoy)))
        .get();

    hayCitasFuturas = citasFuturas.isNotEmpty;
  }

  // Activo si:
  // - quedan sesiones por consumir
  //   O
  // - ya están "asignadas" todas pero todavía hay citas futuras
  final bool activo = haySesionesPendientes || hayCitasFuturas;

  await (db.update(db.bonos)..where((b) => b.id.equals(bonoId))).write(
    BonosCompanion(activo: Value(activo), updatedAt: Value(DateTime.now())),
  );

  notifyListeners();
}


////////////////////////////////// SECCION DE PAGO DE BONOS ////////////////////////////

Future<void> insertarPagoBono({
  required String bonoId,
  required double importe,
  String? metodo,            // 'efectivo' | 'bizum' | 'tarjeta'...
  DateTime? fecha,           // si null -> now
  String? nota,
}) async {
  final id = const Uuid().v4();
  final now = DateTime.now();
  await db.into(db.bonoPagos).insert(BonoPagosCompanion(
    id:        d.Value(id),
    bonoId:    d.Value(bonoId),
    importe:   d.Value(importe),
    metodo:    d.Value(metodo),
    fecha:     fecha != null ? d.Value(fecha) : d.Value(now),
    nota:      d.Value(nota),
    syncId:    d.Value(_id()),
    createdAt: d.Value(now),
    updatedAt: d.Value(now),
  ));

  await _recalcularBonoDesdeConsumos(bonoId);
}

Future<List<BonoPago>> pagosDeBono(String bonoId) {
  final q = db.select(db.bonoPagos)
    ..where((t) => t.bonoId.equals(bonoId) & t.deleted.equals(false))
    ..orderBy([(t) => d.OrderingTerm.asc(t.fecha)]);
  return q.get();
}

Future<double> totalCobradoBono(String bonoId) async {
  final q = db.selectOnly(db.bonoPagos)
    ..addColumns([db.bonoPagos.importe.sum()])
    ..where(db.bonoPagos.bonoId.equals(bonoId) & db.bonoPagos.deleted.equals(false));
  final row = await q.getSingleOrNull();
  return row?.read(db.bonoPagos.importe.sum()) ?? 0.0;
}

Future<int> sesionesConsumidasBono(String bonoId) async {
  final q = db.selectOnly(db.bonoConsumos)
    ..addColumns([db.bonoConsumos.id.count()])
    ..where(db.bonoConsumos.bonoId.equals(bonoId) & db.bonoConsumos.deleted.equals(false));
  final row = await q.getSingleOrNull();
  return row?.read(db.bonoConsumos.id.count()) ?? 0;
}

Future<double> ingresoReconocidoBono(String bonoId) async {
  final bono = await (db.select(db.bonos)..where((b) => b.id.equals(bonoId))).getSingle();
  final precio = bono.precioBono ?? 0;
  if (precio <= 0 || bono.sesionesTotales <= 0) return 0;

  final consumidas = await sesionesConsumidasBono(bonoId);
  final porSesion  = precio / bono.sesionesTotales;
  return consumidas * porSesion;
}



}

