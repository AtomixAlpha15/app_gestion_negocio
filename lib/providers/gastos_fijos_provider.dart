import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/app_database.dart';
import 'package:drift/drift.dart';

class GastosFijosProvider extends ChangeNotifier {
  final AppDatabase db;
  List<GastosFijo> todosLosGastosFijos = [];

  GastosFijosProvider(this.db);

  Future<void> cargar() async {
    todosLosGastosFijos = await (db.select(db.gastosFijos)
      ..where((g) => g.deleted.equals(false)))
      .get();
    notifyListeners();
  }

  List<GastosFijo> get gastosFijosActivos =>
      todosLosGastosFijos.where((g) => g.fechaFin == null).toList();

  List<GastosFijo> gastosFijosParaMes(int mes, int anio) {
    return todosLosGastosFijos.where((g) => _aplicaEnMes(g, mes, anio)).toList();
  }

  bool _aplicaEnMes(GastosFijo gf, int mes, int anio) {
    final inicio = DateTime(gf.fechaInicio.year, gf.fechaInicio.month);
    final consulta = DateTime(anio, mes);

    // Si la consulta es anterior al inicio, no aplica
    if (consulta.isBefore(inicio)) return false;

    // Si hay fechaFin, verificar que la consulta sea anterior a fin
    if (gf.fechaFin != null) {
      final fin = DateTime(gf.fechaFin!.year, gf.fechaFin!.month);
      if (!consulta.isBefore(fin)) return false;
    }

    // Verificar la frecuencia: (meses desde inicio) % frecuencia == 0
    final diffMeses =
        (consulta.year - inicio.year) * 12 + (consulta.month - inicio.month);
    return diffMeses % gf.frecuenciaMeses == 0;
  }

  Future<void> crear({
    required String concepto,
    required double precio,
    required int frecuenciaMeses,
    required DateTime fechaInicio,
    String? establecimientoId,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final gasto = GastosFijosCompanion(
      id: Value(id),
      concepto: Value(concepto),
      precio: Value(precio),
      frecuenciaMeses: Value(frecuenciaMeses),
      fechaInicio: Value(fechaInicio),
      establecimientoId: Value(establecimientoId),
      syncId: Value(const Uuid().v4()),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    await db.into(db.gastosFijos).insert(gasto);
    await cargar();
  }

  Future<void> eliminar(String id) async {
    final ahora = DateTime.now();
    final finMesActual = DateTime(ahora.year, ahora.month, 1);
    await (db.update(db.gastosFijos)..where((g) => g.id.equals(id))).write(
      GastosFijosCompanion(
        fechaFin: Value(finMesActual),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await cargar();
  }
}
