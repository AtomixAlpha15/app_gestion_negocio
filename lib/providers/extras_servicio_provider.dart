import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../services/app_database.dart';

class ExtrasServicioProvider extends ChangeNotifier {
  final AppDatabase db;
  ExtrasServicioProvider(this.db);

  // Obtén los extras de un servicio
  Future<List<ExtrasServicioData>> obtenerExtrasPorServicio(String servicioId) async {
    return await (db.select(db.extrasServicio)..where((tbl) => tbl.servicioId.equals(servicioId))).get();
  }

  Future<void> insertarExtra({
    required String servicioId,
    required String nombre,
    required double precio,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final extra = ExtrasServicioCompanion(
      id: Value(id),
      servicioId: Value(servicioId),
      nombre: Value(nombre),
      precio: Value(precio),
    );
    await db.into(db.extrasServicio).insert(extra);
    notifyListeners();
  }

  Future<void> actualizarExtra({
    required String id,
    required String nombre,
    required double precio,
  }) async {
    final companion = ExtrasServicioCompanion(
      nombre: Value(nombre),
      precio: Value(precio),
    );
    await (db.update(db.extrasServicio)..where((e) => e.id.equals(id))).write(companion);
    notifyListeners();
  }

  Future<void> eliminarExtra(String id) async {
    await (db.delete(db.extrasServicio)..where((e) => e.id.equals(id))).go();
    notifyListeners();
  }
}
