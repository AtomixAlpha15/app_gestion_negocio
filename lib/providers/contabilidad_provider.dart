import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart' as d;
import '../services/app_database.dart';
import '../models/movimiento_contable.dart';

class ContabilidadProvider extends ChangeNotifier {
  final AppDatabase db;
  ContabilidadProvider(this.db);

  /// Devuelve todas las citas y pagos de bonos de un mes (ordenados por fecha)
  Future<List<MovimientoContable>> movimientosMes(int year, int month, {String? clienteId}) async {
    final ini = DateTime(year, month, 1);
    final fin = (month == 12)
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);

    final movimientos = <MovimientoContable>[];

    // === CITAS COBRADAS (metodoPago no vacío) ===
    final citasQ = db.select(db.citas)
      ..where((c) =>
          c.inicio.isBiggerOrEqualValue(ini) &
          c.inicio.isSmallerThanValue(fin) &
          c.metodoPago.isNotNull() &
          c.metodoPago.isNotIn([''])
      );
    if (clienteId != null) citasQ.where((c) => c.clienteId.equals(clienteId));

    final citas = await citasQ.get();
    for (final c in citas) {
      movimientos.add(MovimientoContable(
        fecha: c.inicio,
        clienteId: c.clienteId,
        servicioId: c.servicioId,
        citaId: c.id,
        detalle: 'Cita',
        metodo: c.metodoPago,
        importe: c.precio ?? 0.0,
        tipo: MovimientoTipo.cita,
      ));
    }

    // === PAGOS DE BONOS (impactan caja) ===
    final join = db.select(db.bonoPagos).join([
      d.innerJoin(db.bonos, db.bonos.id.equalsExp(db.bonoPagos.bonoId)),
      d.leftOuterJoin(db.servicios, db.servicios.id.equalsExp(db.bonos.servicioId)),
    ])
      ..where(
        db.bonoPagos.fecha.isBiggerOrEqualValue(ini) &
        db.bonoPagos.fecha.isSmallerThanValue(fin)
      );

    if (clienteId != null) join.where(db.bonos.clienteId.equals(clienteId));

    final pagos = await join.get();
    for (final row in pagos) {
      final pago = row.readTable(db.bonoPagos);
      final bono = row.readTable(db.bonos);
      final servicio = row.readTableOrNull(db.servicios);

      final detalle = 'Pago bono ${servicio?.nombre ?? ''}'.trim();

      movimientos.add(MovimientoContable(
        fecha: pago.fecha,
        clienteId: bono.clienteId,
        servicioId: bono.servicioId,
        detalle: detalle.isEmpty ? 'Pago bono' : detalle,
        metodo: pago.metodo,
        importe: pago.importe,
        tipo: MovimientoTipo.bonoPago,
      ));
    }

    movimientos.sort((a, b) => a.fecha.compareTo(b.fecha));
    return movimientos;
  }

  /// Total cobrado (citas + pagos de bonos)
  Future<double> totalCobradoMes(int year, int month, {String? clienteId}) async {
    final movs = await movimientosMes(year, month, clienteId: clienteId);
    double total = 0.0;
    for (final m in movs) {
      total += m.importe;
    }
    return total;
  }

  /// Total cobrado desglosado por método (efectivo, bizum, tarjeta, etc.)
  Future<Map<String, double>> totalCobradoPorMetodoMes(int year, int month, {String? clienteId}) async {
    final movs = await movimientosMes(year, month, clienteId: clienteId);
    final mapa = <String, double>{};
    for (final m in movs) {
      final key = (m.metodo ?? '—').toLowerCase();
      mapa[key] = (mapa[key] ?? 0.0) + m.importe;
    }
    return mapa;
  }

  /// (opcional) Total de un cliente concreto
  Future<double> totalCobradoClienteMes(String clienteId, int year, int month) =>
      totalCobradoMes(year, month, clienteId: clienteId);
}
