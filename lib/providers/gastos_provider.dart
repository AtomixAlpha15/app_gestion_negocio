import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../services/app_database.dart';
import 'package:drift/drift.dart';

class GastosProvider extends ChangeNotifier {
  final AppDatabase db;
  List<Gasto> todosLosGastos = [];

  GastosProvider(this.db);

  Future<void> cargarGastosAnio(int anio) async {
    final inicio = DateTime(anio, 1, 1);
    final fin = DateTime(anio, 12, 31, 23, 59, 59);
    todosLosGastos = await (db.select(db.gastos)
      ..where((g) => g.fecha.isBetweenValues(inicio, fin)))
      .get();
    notifyListeners();
  }

  List<Gasto> gastosPorMes(int mes, int anio) {
    return todosLosGastos.where((g) {
      return g.fecha.year == anio && g.fecha.month == mes;
    }).toList();
  }

  Future<void> insertarGasto({
    required String concepto,
    required double precio,
    required DateTime fecha,
  }) async {
    final id = const Uuid().v4();
    final gasto = GastosCompanion(
      id: Value(id),
      concepto: Value(concepto),
      precio: Value(precio),
      fecha: Value(fecha),
    );
    await db.into(db.gastos).insert(gasto);
    await cargarGastosAnio(fecha.year);
  }

  Future<void> eliminarGasto(String id, {required int anio}) async {
    await (db.delete(db.gastos)..where((g) => g.id.equals(id))).go();
    await cargarGastosAnio(anio);
  }
}
