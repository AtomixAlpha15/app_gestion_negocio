import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../services/app_database.dart';

class ServiciosProvider extends ChangeNotifier {
  final AppDatabase db;
  ServiciosProvider(this.db);

  List<Servicio> _servicios = [];
  List<Servicio> get servicios => _servicios;

  Future<void> cargarServicios() async {
    _servicios = await db.select(db.servicios).get();
    notifyListeners();
  }

  Future<void> insertarServicio({
    required String nombre,
    required double precio,
    required int duracionMinutos,
    String? descripcion,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final servicio = ServiciosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      precio: Value(precio),
      duracionMinutos: Value(duracionMinutos),
      descripcion: Value(descripcion),
    );
    await db.into(db.servicios).insert(servicio);
    await cargarServicios();
  }

  Future<void> actualizarServicio({
    required String id,
    required String nombre,
    required double precio,
    required int duracionMinutos,
    String? descripcion,
  }) async {
    final companion = ServiciosCompanion(
      nombre: Value(nombre),
      precio: Value(precio),
      duracionMinutos: Value(duracionMinutos),
      descripcion: Value(descripcion),
    );
    await (db.update(db.servicios)..where((s) => s.id.equals(id))).write(companion);
    await cargarServicios();
  }

  Future<void> eliminarServicio(String id) async {
    await (db.delete(db.servicios)..where((s) => s.id.equals(id))).go();
    await cargarServicios();
  }
}
