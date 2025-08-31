import 'package:flutter/material.dart';
import '../services/app_database.dart';
import 'package:drift/drift.dart';

class GastosProvider extends ChangeNotifier {
  final AppDatabase db;
  List<Gasto> todosLosGastos = [];

  GastosProvider(this.db);

  Future<void> cargarGastosAnio(int anio) async {
    todosLosGastos = await (db.select(db.gastos)
      ..where((g) =>
        g.anio.equals(anio) // si tienes campo anio
        // Si sólo tienes fecha completa, usa .isBetweenValues(inicio, fin)
      ))
      .get();
    notifyListeners();
  }

  List<Gasto> gastosPorMes(int mes, int anio) {
    return todosLosGastos.where((g) => g.mes == mes && g.anio == anio).toList();
  }

  Future<void> insertarGasto({required String concepto, required double precio, required int mes, required int anio}) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final gasto = GastosCompanion(
      id: Value(id),
      concepto: Value(concepto),
      precio: Value(precio),
      mes: Value(mes),
      anio: Value(anio),
    );
    await db.into(db.gastos).insert(gasto);
    await cargarGastosAnio(anio);
  }

  Future<void> eliminarGasto(String id,{required int anio}) async {
    await (db.delete(db.gastos)..where((g) => g.id.equals(id))).go();
    await cargarGastosAnio(anio);
  }
}
