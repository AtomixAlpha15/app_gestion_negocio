import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart' as d;
import 'package:rxdart/rxdart.dart';
import '../services/app_database.dart';
import '../models/movimiento_contable.dart';

class ContabilidadProvider extends ChangeNotifier {
  final AppDatabase db;
  ContabilidadProvider(this.db);

  // ---------- Helpers privados ----------

  MovimientoContable _movimientoDesdeCita(Cita c) {
    return MovimientoContable(
      fecha: c.inicio,
      clienteId: c.clienteId,
      servicioId: c.servicioId,
      citaId: c.id,
      detalle: 'Cita',
      metodo: c.metodoPago,
      importe: c.precio ?? 0.0,
      tipo: MovimientoTipo.cita,
    );
  }

  MovimientoContable _movimientoDesdePagoRow(d.TypedResult row) {
    final pago     = row.readTable(db.bonoPagos);
    final bono     = row.readTable(db.bonos);
    final servicio = row.readTableOrNull(db.servicios);

    final detalle = 'Pago bono ${servicio?.nombre ?? ''}'.trim();

    return MovimientoContable(
      fecha: pago.fecha,
      clienteId: bono.clienteId,
      servicioId: bono.servicioId,
      citaId: null,
      detalle: detalle.isEmpty ? 'Pago bono' : detalle,
      metodo: pago.metodo,
      importe: pago.importe,
      tipo: MovimientoTipo.bonoPago,
    );
  }

  // ---------- Versión Future (la que ya usabas para totales) ----------

  Future<List<MovimientoContable>> movimientosMes(int year, int month, {String? clienteId}) async {
    final ini = DateTime(year, month, 1);
    final fin = (month == 12)
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);

    final movimientos = <MovimientoContable>[];

    // Citas del mes (TODAS, con o sin método de pago)
    final citasQ = db.select(db.citas)
      ..where((c) =>
          c.inicio.isBiggerOrEqualValue(ini) &
          c.inicio.isSmallerThanValue(fin));
    if (clienteId != null) {
      citasQ.where((c) => c.clienteId.equals(clienteId));
    }

    final citas = await citasQ.get();
    movimientos.addAll(citas.map(_movimientoDesdeCita));

    // Pagos de bonos del mes
    final join = db.select(db.bonoPagos).join([
      d.innerJoin(db.bonos, db.bonos.id.equalsExp(db.bonoPagos.bonoId)),
      d.leftOuterJoin(db.servicios, db.servicios.id.equalsExp(db.bonos.servicioId)),
    ])
      ..where(
        db.bonoPagos.fecha.isBiggerOrEqualValue(ini) &
        db.bonoPagos.fecha.isSmallerThanValue(fin),
      );
    if (clienteId != null) {
      join.where(db.bonos.clienteId.equals(clienteId));
    }

    final pagosRows = await join.get();
    movimientos.addAll(pagosRows.map(_movimientoDesdePagoRow));

    movimientos.sort((a, b) => a.fecha.compareTo(b.fecha));
    return movimientos;
  }

  // ---------- Versión Stream (reactiva, sin flicker) ----------

  Stream<List<MovimientoContable>> movimientosMesStream(int year, int month, {String? clienteId}) {
    final ini = DateTime(year, month, 1);
    final fin = (month == 12)
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);

    // Stream de citas
    final citasQ = db.select(db.citas)
      ..where((c) =>
          c.inicio.isBiggerOrEqualValue(ini) &
          c.inicio.isSmallerThanValue(fin));
    if (clienteId != null) {
      citasQ.where((c) => c.clienteId.equals(clienteId));
    }

    final streamCitas = citasQ.watch().map(
          (rows) => rows.map(_movimientoDesdeCita).toList(),
        );

    // Stream de pagos de bonos
    final join = db.select(db.bonoPagos).join([
      d.innerJoin(db.bonos, db.bonos.id.equalsExp(db.bonoPagos.bonoId)),
      d.leftOuterJoin(db.servicios, db.servicios.id.equalsExp(db.bonos.servicioId)),
    ])
      ..where(
        db.bonoPagos.fecha.isBiggerOrEqualValue(ini) &
        db.bonoPagos.fecha.isSmallerThanValue(fin),
      );
    if (clienteId != null) {
      join.where(db.bonos.clienteId.equals(clienteId));
    }

    final streamPagos = join.watch().map(
          (rows) => rows.map(_movimientoDesdePagoRow).toList(),
        );

    // Combinamos ambos streams en uno solo
    return Rx.combineLatest2<List<MovimientoContable>, List<MovimientoContable>, List<MovimientoContable>>(
      streamCitas,
      streamPagos,
      (citas, pagos) {
        final todos = [...citas, ...pagos];
        todos.sort((a, b) => a.fecha.compareTo(b.fecha));
        return todos;
      },
    );
  }

  // ---------- Totales (los usas en el panel derecho) ----------

  Future<double> totalCobradoMes(int year, int month, {String? clienteId}) async {
    final movs = await movimientosMes(year, month, clienteId: clienteId);
    double total = 0.0;
    for (final m in movs) {
      total += m.importe;
    }
    return total;
  }

  Future<Map<String, double>> totalCobradoPorMetodoMes(int year, int month, {String? clienteId}) async {
    final movs = await movimientosMes(year, month, clienteId: clienteId);
    final mapa = <String, double>{};
    for (final m in movs) {
      final key = (m.metodo ?? '—').toLowerCase();
      mapa[key] = (mapa[key] ?? 0.0) + m.importe;
    }
    return mapa;
  }

  Future<double> totalCobradoClienteMes(String clienteId, int year, int month) =>
      totalCobradoMes(year, month, clienteId: clienteId);
}
