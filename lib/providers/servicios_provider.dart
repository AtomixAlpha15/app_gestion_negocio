import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';
import '../services/app_database.dart';
import '../utils/image_utils.dart';

class ServiciosProvider extends ChangeNotifier {
  final AppDatabase db;
  ServiciosProvider(this.db);

  List<Servicio> _servicios = [];
  List<Servicio> get servicios => _servicios;

  Future<void> cargarServicios() async {
    _servicios = await (db.select(db.servicios)
      ..where((s) => s.deleted.equals(false))).get();
    notifyListeners();
  }

  Future<void> insertarServicio({
    required String nombre,
    required double precio,
    required int duracionMinutos,
    String? descripcion,
    String? imagenPath,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();

    String? nuevaImagenPath;
    if (imagenPath != null && imagenPath.isNotEmpty) {
      nuevaImagenPath = await guardarImagenEnAppDir(
        origenPath: imagenPath,
        entidadId: id,
        targetDir: await db.getServiceImagesDir(),
      );
    }

    final servicio = ServiciosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      precio: Value(precio),
      duracionMinutos: Value(duracionMinutos),
      descripcion: Value(descripcion),
      imagenPath: Value(nuevaImagenPath),
      syncId: Value(const Uuid().v4()),
      createdAt: Value(now),
      updatedAt: Value(now),
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
    String? nuevaImagenSeleccionada,
  }) async {
    Value<String?> imagenValue = const Value.absent();

    if (nuevaImagenSeleccionada != null) {
      final clean = nuevaImagenSeleccionada.trim();
      if (clean.isEmpty) {
        imagenValue = const Value(null);
      } else {
        final nuevaImagenPath = await guardarImagenEnAppDir(
          origenPath: clean,
          entidadId: id,
          targetDir: await db.getServiceImagesDir(),
        );
        imagenValue = Value(nuevaImagenPath);
      }
    }

    final companion = ServiciosCompanion(
      nombre: Value(nombre),
      precio: Value(precio),
      duracionMinutos: Value(duracionMinutos),
      descripcion: Value(descripcion),
      imagenPath: imagenValue,
      updatedAt: Value(DateTime.now()),
    );

    await (db.update(db.servicios)..where((s) => s.id.equals(id))).write(companion);
    await cargarServicios();
  }

  Future<void> eliminarServicio(String id) async {
    await (db.update(db.servicios)..where((s) => s.id.equals(id))).write(
      ServiciosCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await cargarServicios();
  }

  String? nombreServicioPorId(String id) {
    final idx = _servicios.indexWhere((e) => e.id == id);
    if (idx == -1) return null;
    return _servicios[idx].nombre;
  }
}
