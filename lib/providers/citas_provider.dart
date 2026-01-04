import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d;
import '../services/app_database.dart';
import '../models/movimiento_contable.dart';

class CitasProvider extends ChangeNotifier {
  final AppDatabase db;
  CitasProvider(this.db);

  /// Caché en memoria para contabilidad
  List<Cita> _todasLasCitas = [];
  List<Cita> get todasLasCitas => _todasLasCitas;

  // ------------------ CONSULTAS BÁSICAS ------------------

  Future<List<MovimientoContable>> movimientosMes(int year, int month, {String? clienteId}) async {
    final ini = DateTime(year, month, 1);
    final fin = (month == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);

    final movimientos = <MovimientoContable>[];

    // 2A) CITAS con cobro directo (metodoPago no vacío) en el mes
    // Nota: las citas con metodoPago == 'Bono' tienen precio 0 → no afectan caja.
    final citasQ = db.select(db.citas)
      ..where((c) =>
        c.inicio.isBiggerOrEqualValue(ini) &
        c.inicio.isSmallerThanValue(fin) &
        // metodoPago no nulo/ni vacío
        (c.metodoPago.isNotNull()) &
        c.metodoPago.isNotIn(['']) // evita string vacío
      );

    if (clienteId != null) {
      citasQ.where((c) => c.clienteId.equals(clienteId));
    }

    // (Opcional) joinear servicio para mostrar nombre
    final citas = await citasQ.get();
    for (final c in citas) {
      // precio de la cita; si tu modelo guarda precio en otra tabla, ajusta aquí
      final double importe = c.precio ;
      final String detalle = 'Cita'; // si tienes servicios, puedes sustituir por su nombre

      movimientos.add(MovimientoContable(
        fecha: c.inicio,
        clienteId: c.clienteId,
        detalle: detalle,
        metodo: c.metodoPago,
        importe: importe,
        tipo: MovimientoTipo.cita,
      ));
    }

    // 2B) PAGOS DE BONOS en el mes (impactan caja)
    // join para traer cliente y servicio del bono
    final bonosJoin = db.select(db.bonoPagos).join([
      d.innerJoin(db.bonos, db.bonos.id.equalsExp(db.bonoPagos.bonoId)),
      // opcional: nombre del servicio
      d.leftOuterJoin(db.servicios, db.servicios.id.equalsExp(db.bonos.servicioId)),
    ])
      ..where(
        db.bonoPagos.fecha.isBiggerOrEqualValue(ini) &
        db.bonoPagos.fecha.isSmallerThanValue(fin)
      );

    if (clienteId != null) {
      bonosJoin.where(db.bonos.clienteId.equals(clienteId));
    }

    final pagosRows = await bonosJoin.get();
    for (final row in pagosRows) {
      final pago = row.readTable(db.bonoPagos);
      final bono = row.readTable(db.bonos);
      final servicio = row.readTableOrNull(db.servicios);

      final detalle = 'Pago bono ${servicio?.nombre ?? ''}'.trim();

      movimientos.add(MovimientoContable(
        fecha: pago.fecha,
        clienteId: bono.clienteId,
        detalle: detalle.isEmpty ? 'Pago bono' : detalle,
        metodo: pago.metodo,
        importe: pago.importe, // positivo cobro / negativo devolución
        tipo: MovimientoTipo.bonoPago,
      ));
    }

    // Orden cronológico
    movimientos.sort((a, b) => a.fecha.compareTo(b.fecha));
    return movimientos;
  }

  Future<double> totalCobradoMes(int year, int month, {String? clienteId}) async {
    final movs = await movimientosMes(year, month, clienteId: clienteId);
    double total = 0.0;
    for (final m in movs) {
      total += (m.importe); // si importe es no-nullable, quita ?? 0.0
    }
    return total;
  }

  Future<Map<String, double>> totalCobradoPorMetodoMes(int y, int m, {String? clienteId}) async {
    final movs = await movimientosMes(y, m, clienteId: clienteId);
    final mapa = <String, double>{};
    for (final m in movs) {
      final key = (m.metodo ?? '—').toLowerCase();
      mapa[key] = (mapa[key] ?? 0) + m.importe;
    }
    return mapa;
  }


  Future<List<Cita>> obtenerCitasPorDia(DateTime dia) async {
    final inicio = DateTime(dia.year, dia.month, dia.day, 0, 0, 0);
    final fin    = DateTime(dia.year, dia.month, dia.day, 23, 59, 59);

    final q = (db.select(db.citas)
      ..where((c) => c.inicio.isBiggerOrEqualValue(inicio) & c.inicio.isSmallerOrEqualValue(fin))
      ..orderBy([(c) => d.OrderingTerm(expression: c.inicio)]));

    return q.get();
  }

  /// Inserta y **devuelve** la Cita creada (útil para aplicar bono, etc).
  Future<String> insertarCita({
    required String clienteId,
    required String servicioId,
    required DateTime inicio,
    required DateTime fin,
    required double precio,
    String? metodoPago,
    String? notas,
    bool pagada = false,
  }) async {
    final citaId = DateTime.now().millisecondsSinceEpoch.toString();

    final companion = CitasCompanion(
      id:          d.Value(citaId),
      clienteId:   d.Value(clienteId),
      servicioId:  d.Value(servicioId),
      inicio:      d.Value(inicio),
      fin:         d.Value(fin),
      precio:      d.Value(precio),
      metodoPago:  d.Value(metodoPago),
      notas:       d.Value(notas),
      pagada:      d.Value(pagada),
    );

    await db.into(db.citas).insert(companion);

    // Devuelve la cita insertada
    final cita = await (db.select(db.citas)..where((c) => c.id.equals(citaId))).getSingle();

    // Refresca caché del año de la cita (si la estás usando)
    await cargarCitasAnio(inicio.year);

    notifyListeners();
    return citaId;
  }
  Future<String> insertarCitaYDevolverId({
    required String clienteId,
    required String servicioId,
    required DateTime inicio,
    required DateTime fin,
    required double precio,
    String? metodoPago,
    String? notas,
    bool? pagada,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await db.into(db.citas).insert(CitasCompanion(
      id: d.Value(id),
      clienteId: d.Value(clienteId),
      servicioId: d.Value(servicioId),
      inicio: d.Value(inicio),
      fin: d.Value(fin),
      precio: d.Value(precio),
      metodoPago: d.Value(metodoPago),
      notas: d.Value(notas),
      pagada: d.Value(pagada ?? false),
    ));
    await cargarCitasAnio(inicio.year);
    notifyListeners();
    return id;
  }


  Future<void> actualizarCita({
    required String id,
    required String clienteId,
    required String servicioId,
    required DateTime inicio,
    required DateTime fin,
    required double precio,
    String? metodoPago,
    String? notas,
    bool? pagada,
  }) async {
    final companion = CitasCompanion(
      id: d.Value(id),
      clienteId: clienteId != null ? d.Value(clienteId) : const d.Value.absent(),
      servicioId: servicioId != null ? d.Value(servicioId) : const d.Value.absent(),
      inicio:     inicio     != null ? d.Value(inicio)   : const d.Value.absent(),
      fin:        fin        != null ? d.Value(fin)      : const d.Value.absent(),
      precio:     d.Value(precio),
      metodoPago: metodoPago != null ? d.Value(metodoPago) : const d.Value.absent(),
      notas:      d.Value(notas),
      pagada:     pagada == null ? const d.Value.absent() : d.Value(pagada),
    );

    await (db.update(db.citas)..where((c) => c.id.equals(id))).write(companion);

    // Refresca caché del año de la cita (si procede)
    await cargarCitasAnio(inicio.year);

    notifyListeners();
  }

  Future<void> eliminarCita(String id, {int? anio}) async {
    await (db.delete(db.bonoConsumos)..where((t) => t.citaId.equals(id))).go();
    await (db.delete(db.citas)..where((c) => c.id.equals(id))).go();

    // Si nos pasan el año, refrescamos esa caché
    if (anio != null) {
      await cargarCitasAnio(anio);
    }

    notifyListeners();
  }

  // ------------------ CONTABILIDAD (CACHÉ ANUAL) ------------------

  Future<void> cargarCitasAnio(int anio) async {
    final ini = DateTime(anio, 1, 1, 0, 0, 0);
    final fin = DateTime(anio, 12, 31, 23, 59, 59);

    _todasLasCitas = await (db.select(db.citas)
      ..where((c) => c.inicio.isBetweenValues(ini, fin)))
      .get();

    notifyListeners();
  }

  List<Cita> citasPorMes(int mes, int anio) {
    return _todasLasCitas.where((c) =>
      c.inicio.year == anio && c.inicio.month == mes).toList();
  }

  // ------------------ ANALÍTICA POR CLIENTE ------------------

  /// Últimas N citas (por defecto 10) de un cliente (desc por fecha)
Future<List<Cita>> ultimasCitasCliente(String clienteId, {int limit = 10}) async {
  final now = DateTime.now();
  // Hoy a las 00:00, igual que usamos para impagos
  final hoy = DateTime(now.year, now.month, now.day);

  final q = (db.select(db.citas)
    ..where((c) =>
      c.clienteId.equals(clienteId) &
      c.inicio.isSmallerThanValue(hoy) // 👈 SOLO citas pasadas
    )
    ..orderBy([
      (c) => d.OrderingTerm(expression: c.inicio, mode: d.OrderingMode.desc),
    ])
    ..limit(limit));

  return q.get();
}


  /// Total gastado por un cliente (citas con método de pago no vacío)
  Future<double> totalGastadoCliente(String clienteId) async {
    final rows = await (db.customSelect(
      '''
      SELECT COALESCE(SUM(precio), 0) AS total
      FROM citas
      WHERE cliente_id = ?1
        AND metodo_pago IS NOT NULL
        AND metodo_pago <> ''
      ''',
      variables: [d.Variable<String>(clienteId)],
    )).get();

    if (rows.isEmpty) return 0.0;
    final total = rows.first.data['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }

/// Citas impagadas: SOLO las anteriores a hoy 00:00 y sin método de pago
Future<List<Cita>> impagosCliente(String clienteId) async {
  final now = DateTime.now();
  final hoy = DateTime(now.year, now.month, now.day); // corte: inicio del día local

  final q = db.select(db.citas)
    ..where((c) =>
      c.clienteId.equals(clienteId) &
      c.inicio.isSmallerThanValue(hoy) &                     // <-- antes de hoy 00:00
      (c.metodoPago.isNull() | c.metodoPago.equals(''))      // <-- sin pago
    )
  ..orderBy([(c) => d.OrderingTerm.asc(c.inicio)]);
  return q.get();
}

  /// Total impagado por cliente
  Future<double> totalImpagosCliente(String clienteId) async {
    final rows = await (db.customSelect(
      '''
      SELECT COALESCE(SUM(precio), 0) AS total
      FROM citas
      WHERE cliente_id = ?1
        AND inicio < ?2
        AND (metodo_pago IS NULL OR metodo_pago = '')
      ''',
      variables: [
        d.Variable<String>(clienteId),
        d.Variable<DateTime>(DateTime.now()),
      ],
    )).get();

    if (rows.isEmpty) return 0.0;
    final total = rows.first.data['total'];
    return (total is num) ? total.toDouble() : 0.0;
  }
}
