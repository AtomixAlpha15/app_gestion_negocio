import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../services/app_database.dart';
import 'package:drift/drift.dart' as d;
import 'package:uuid/uuid.dart';
import 'dart:math';

class BonosProvider extends ChangeNotifier {
  final AppDatabase db;
  BonosProvider(this.db);

  // Utilidad simple para ids
  String _id() => DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(9999).toString();

  Future<String> crearBonoSesiones({
    required String clienteId,
    required String servicioId,
    required int sesiones, // 1..30
    String? nombre,
    double? precioBono,
    DateTime? caducaEl,
  }) async {
    final id = _id();
    final bono = BonosCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      servicioId: Value(servicioId),
      nombre: Value(nombre ?? 'Bono ${sesiones} sesiones'),
      sesionesTotales: Value(sesiones),
      precioBono: Value(precioBono),
      caducaEl: Value(caducaEl),
      // asegúrate de que tu tabla tenga estos campos; si no, elimina/ajusta:
      activo: const Value(true),
      sesionesUsadas: const Value(0),
      creadoEl: Value(DateTime.now()),
    );
    await db.into(db.bonos).insert(bono);
    notifyListeners();
    return id;
  }

  /// Bonos activos (no agotados ni caducados) de un cliente y servicio
  Future<List<Bono>> bonosActivosClienteServicio(String clienteId, String servicioId) async {
    final now = DateTime.now();
    final query = db.select(db.bonos)
      ..where((b) =>
            b.clienteId.equals(clienteId) &
            b.servicioId.equals(servicioId) &
            b.activo.equals(true) &
            (b.caducaEl.isNull() | b.caducaEl.isBiggerOrEqualValue(now)) &
            (b.sesionesUsadas.isSmallerThan(b.sesionesTotales)));
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
    // 1) marca la cita como pagada con bono (precio la dejamos como está por ahora)
    await (db.update(db.citas)..where((c) => c.id.equals(cita.id))).write(
      CitasCompanion(metodoPago: const Value('Bono')),
    );

    // 2) registra consumo y sube contador
    await db.into(db.bonoConsumos).insert(BonoConsumosCompanion(
      id: Value(_id()),
      bonoId: Value(bono.id),
      citaId: Value(cita.id),
      fecha: Value(DateTime.now()),
    ));

    await (db.update(db.bonos)..where((b) => b.id.equals(bono.id))).write(
      BonosCompanion(sesionesUsadas: Value(bono.sesionesUsadas + 1)),
    );

    // 3) si se agotó, marcar inactivo
    final agotado = bono.sesionesUsadas + 1 >= bono.sesionesTotales;
    if (agotado) {
      await (db.update(db.bonos)..where((b) => b.id.equals(bono.id))).write(
        const BonosCompanion(activo: Value(false)),
      );
    }

    notifyListeners();
    return true;
  }

  /// Bonos activos (cualquier servicio) del cliente
  Future<List<Bono>> bonosActivosCliente(String clienteId) async {
    final now = DateTime.now();
    final q = db.select(db.bonos)
      ..where((b) =>
        b.clienteId.equals(clienteId) &
        b.activo.equals(true) &
        (b.caducaEl.isNull() | b.caducaEl.isBiggerOrEqualValue(now)) &
        (b.sesionesUsadas.isSmallerThan(b.sesionesTotales)));
    return q.get();
  }

  Future<List<Bono>> bonosCliente(String clienteId) {
    return (db.select(db.bonos)..where((b) => b.clienteId.equals(clienteId))).get();
  }

  Future<List<BonoConsumo>> consumosDeBono(String bonoId) {
    return (db.select(db.bonoConsumos)..where((c) => c.bonoId.equals(bonoId))).get();
  }

/// Selecciona bono activo con hueco (en base a sesiones ASIGNADAS)
Future<Bono?> bonoActivoPara(String clienteId, String servicioId) async {
  // Trae bonos activos del cliente/servicio, orden preferente por más antiguo
  final bonos = await (db.select(db.bonos)
        ..where((b) => b.clienteId.equals(clienteId) & b.servicioId.equals(servicioId) & b.activo.equals(true))
        ..orderBy([(b) => d.OrderingTerm.asc(b.creadoEl)]))
      .get();

  for (final bono in bonos) {
    final asignadas = await sesionesAsignadasBono(bono.id);
    if (asignadas < bono.sesionesTotales) return bono;
  }
  return null;
}

Future<void> eliminarBono(String bonoId) async {
  await (db.delete(db.bonoConsumos)..where((t) => t.bonoId.equals(bonoId))).go();
  await (db.delete(db.bonos)..where((t) => t.id.equals(bonoId))).go();
  // Nada de recargas si la UI escucha a watch*
  notifyListeners();
}

Future<void> actualizarActivo(String bonoId, bool activo) async {
  await (db.update(db.bonos)..where((t) => t.id.equals(bonoId)))
      .write(BonosCompanion(activo: Value(activo)));
  // No llames a cargarBonos* si usas streams
  notifyListeners(); // por si hay otros dependientes
}

/////////////////////////////////// CONSUMOS DE BONO ////////////////////////////////////

  Future<void> consumirSesion( String bonoId, String? citaId, DateTime? fecha) async {
    await db.transaction(() async {
      final bono = await (db.select(db.bonos)..where((b) => b.id.equals(bonoId))).getSingle();

      // registra el consumo
      await db.into(db.bonoConsumos).insert(BonoConsumosCompanion(
        id: Value(_id()),
        bonoId: Value(bonoId),
        citaId: Value(citaId),
        fecha: Value(fecha ?? DateTime.now()),
      ));

      // incrementa contador
      final usadas = bono.sesionesUsadas + 1;
      final agotado = usadas >= bono.sesionesTotales;

      await (db.update(db.bonos)..where((b) => b.id.equals(bonoId))).write(
        BonosCompanion(
          sesionesUsadas: Value(usadas),
          activo: Value(!agotado),
        ),
      );
    });

    notifyListeners();
  }

Future<bool> existeConsumoParaCita(String citaId) async {
  final q = db.selectOnly(db.bonoConsumos)
    ..addColumns([db.bonoConsumos.id.count()])
    ..where(db.bonoConsumos.citaId.equals(citaId));
  final row = await q.getSingleOrNull();
  final count = row?.read(db.bonoConsumos.id.count()) ?? 0;
  return count > 0;
}

Future<void> eliminarConsumoPorCita(String citaId, String bonoId) async {
  final bono = await (db.select(db.bonos)..where((b) => b.id.equals(bonoId))).getSingle();
  final usadas = bono.sesionesUsadas - 1;
  await (db.delete(db.bonoConsumos)..where((t) => t.citaId.equals(citaId))).go();
  await (db.update(db.bonos)..where((b) => b.id.equals(bonoId))).write(
          BonosCompanion(
          sesionesUsadas: Value(usadas),
        ),
  );
  notifyListeners();
}

/// Sesiones asignadas actualmente (chips que muestras como usadas)
Future<int> sesionesAsignadasBono(String bonoId) async {
  final q = db.selectOnly(db.bonoConsumos)
    ..addColumns([db.bonoConsumos.id.count()])
    ..where(db.bonoConsumos.bonoId.equals(bonoId));
  final row = await q.getSingleOrNull();
  return row?.read(db.bonoConsumos.id.count()) ?? 0;
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
  await db.into(db.bonoPagos).insert(BonoPagosCompanion(
    id:        d.Value(id),
    bonoId:    d.Value(bonoId),
    importe:   d.Value(importe),
    metodo:    d.Value(metodo),
    fecha:     fecha != null ? d.Value(fecha) : const d.Value.absent(),
    nota:      d.Value(nota),
  ));
}

Future<List<BonoPago>> pagosDeBono(String bonoId) {
  final q = db.select(db.bonoPagos)
    ..where((t) => t.bonoId.equals(bonoId))
    ..orderBy([(t) => d.OrderingTerm.asc(t.fecha)]);
  return q.get();
}

Future<double> totalCobradoBono(String bonoId) async {
  final q = db.selectOnly(db.bonoPagos)
    ..addColumns([db.bonoPagos.importe.sum()])
    ..where(db.bonoPagos.bonoId.equals(bonoId));
  final row = await q.getSingleOrNull();
  return row?.read(db.bonoPagos.importe.sum()) ?? 0.0;
}

Future<int> sesionesConsumidasBono(String bonoId) async {
  final q = db.selectOnly(db.bonoConsumos)
    ..addColumns([db.bonoConsumos.id.count()])
    ..where(db.bonoConsumos.bonoId.equals(bonoId));
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

