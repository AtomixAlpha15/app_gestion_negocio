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
      b.activo.equals(true) & // respeta la lógica nueva (sesiones, citas futuras, pagos)
      (
        b.caducaEl.isNull() | 
        b.caducaEl.isBiggerOrEqualValue(hoy) // caduca a nivel de día, no por hora
      ) &
      b.sesionesUsadas.isSmallerThan(b.sesionesTotales) // tiene sesiones libres
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
      // 1) marcar la cita como pagada con bono
      await (db.update(db.citas)..where((c) => c.id.equals(cita.id))).write(
        const CitasCompanion(metodoPago: Value('Bono')),
      );

      // 2) registrar consumo
      await db.into(db.bonoConsumos).insert(BonoConsumosCompanion(
        id: Value(_id()),
        bonoId: Value(bono.id),
        citaId: Value(cita.id),
        fecha: Value(DateTime.now()),
      ));

      // 3) subir contador de sesiones usadas
      await (db.update(db.bonos)..where((b) => b.id.equals(bono.id))).write(
        BonosCompanion(sesionesUsadas: Value(bono.sesionesUsadas + 1)),
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

Future<void> consumirSesion(String bonoId, String? citaId, DateTime? fecha) async {
  // Solo insertamos el consumo
  await db.into(db.bonoConsumos).insert(
    BonoConsumosCompanion(
      id: Value(_id()),
      bonoId: Value(bonoId),
      citaId: Value(citaId),
      fecha: Value(fecha ?? DateTime.now()),
    ),
  );

  // Y luego recalculamos el bono entero a partir de los consumos/pagos reales
  await _recalcularBonoDesdeConsumos(bonoId);

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

Future<void> eliminarConsumoPorCita(String citaId) async {
  await db.transaction(() async {
    // 1) Buscar el consumo asociado a esa cita (si no hay, no hacemos nada)
    final consumo = await (db.select(db.bonoConsumos)
          ..where((t) => t.citaId.equals(citaId)))
        .getSingleOrNull();

    if (consumo == null) {
      return;
    }

    final bonoId = consumo.bonoId;

    // 2) Borrar ese consumo concreto
    await (db.delete(db.bonoConsumos)..where((t) => t.id.equals(consumo.id))).go();

    // 3) Recalcular el bono desde los consumos/pagos reales
    await _recalcularBonoDesdeConsumos(bonoId);
  });

  notifyListeners();
}



Future<void> _recalcularBonoDesdeConsumos(String bonoId) async {
  // 1) Leer el bono
  final bono = await (db.select(db.bonos)..where((b) => b.id.equals(bonoId))).getSingle();

  // 2) Leer TODOS los consumos del bono
  final consumos = await (db.select(db.bonoConsumos)
        ..where((bc) => bc.bonoId.equals(bonoId)))
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
        ..where((p) => p.bonoId.equals(bonoId)))
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
    ),
  );
}


/// Sesiones asignadas actualmente (chips que muestras como usadas)
Future<int> sesionesAsignadasBono(String bonoId) async {
  final q = db.selectOnly(db.bonoConsumos)
    ..addColumns([db.bonoConsumos.id.count()])
    ..where(db.bonoConsumos.bonoId.equals(bonoId));
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

  // Buscar consumos de este bono que tengan citaId
  final consumos = await (db.select(db.bonoConsumos)
        ..where((bc) => bc.bonoId.equals(bonoId) & bc.citaId.isNotNull()))
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
    BonosCompanion(activo: Value(activo)),
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
  await db.into(db.bonoPagos).insert(BonoPagosCompanion(
    id:        d.Value(id),
    bonoId:    d.Value(bonoId),
    importe:   d.Value(importe),
    metodo:    d.Value(metodo),
    fecha:     fecha != null ? d.Value(fecha) : const d.Value.absent(),
    nota:      d.Value(nota),
  ));

  await _recalcularBonoDesdeConsumos(bonoId);
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

