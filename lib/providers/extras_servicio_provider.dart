import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../services/app_database.dart';

class ExtrasServicioProvider extends ChangeNotifier {
  final AppDatabase db;
  ExtrasServicioProvider(this.db);

  // Obtén los extras de un servicio (excluyendo soft-deleted)
  Future<List<ExtrasServicioData>> obtenerExtrasPorServicio(String servicioId) async {
    final query = db.select(db.extrasServicio)
      ..where((tbl) => tbl.servicioId.equals(servicioId) & tbl.deleted.equals(false));
    return query.get();
  }

  Future<void> insertarExtra({
    required String servicioId,
    required String nombre,
    required double precio,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    final extra = ExtrasServicioCompanion(
      id: Value(id),
      servicioId: Value(servicioId),
      nombre: Value(nombre),
      precio: Value(precio),
      syncId: Value(const Uuid().v4()),
      createdAt: Value(now),
      updatedAt: Value(now),
      deleted: Value(false),
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
      updatedAt: Value(DateTime.now()),
    );
    await (db.update(db.extrasServicio)..where((e) => e.id.equals(id))).write(companion);
    notifyListeners();
  }

  Future<void> eliminarExtra(String id) async {
    final companion = ExtrasServicioCompanion(
      deleted: Value(true),
      updatedAt: Value(DateTime.now()),
    );
    await (db.update(db.extrasServicio)..where((e) => e.id.equals(id))).write(companion);
    notifyListeners();
  }
}
