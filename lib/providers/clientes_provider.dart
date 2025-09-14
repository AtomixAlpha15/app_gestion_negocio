import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../services/app_database.dart';
import '../utils/image_utils.dart';

class ClientesProvider extends ChangeNotifier {
  final AppDatabase db;
  ClientesProvider(this.db);

  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  // Carga todos los clientes (puedes ordenar por nombre si quieres)
  Future<void> cargarClientes() async {
    _clientes = await (db.select(db.clientes)
      // ..orderBy([(c) => OrderingTerm(expression: c.nombre)]) // opcional
    ).get();
    notifyListeners();
  }

  Future<Cliente?> getClienteById(String id) async {
    return (db.select(db.clientes)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  /// Inserta un cliente. Si [imagenSeleccionada] no es null, la copiamos a la carpeta de la app.
  Future<void> insertarCliente({
    required String nombre,
    String? telefono,
    String? email,
    String? notas,
    String? imagenSeleccionada,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    String? nuevaImagenPath;
    if (imagenSeleccionada != null && imagenSeleccionada.isNotEmpty) {
      nuevaImagenPath = await guardarImagenEnAppDir(imagenSeleccionada, id);
    }

    final cliente = ClientesCompanion(
      id:        Value(id),
      nombre:    Value(nombre),
      telefono:  Value(telefono),
      email:     Value(email),
      notas:     Value(notas),
      imagenPath: Value(nuevaImagenPath),
    );

    await db.into(db.clientes).insert(cliente);
    await cargarClientes();
  }

  /// Actualiza un cliente. Si [nuevaImagenSeleccionada] viene, copiamos y guardamos la nueva ruta.
  Future<void> actualizarCliente({
    required String id,
    required String nombre,
    String? telefono,
    String? email,
    String? notas,
    String? nuevaImagenSeleccionada,
  }) async {
    String? nuevaImagenPath;
    if (nuevaImagenSeleccionada != null && nuevaImagenSeleccionada.isNotEmpty) {
      nuevaImagenPath = await guardarImagenEnAppDir(nuevaImagenSeleccionada, id);
    }

    final companion = ClientesCompanion(
      nombre:   Value(nombre),
      telefono: Value(telefono),
      email:    Value(email),
      notas:    Value(notas),
      imagenPath: nuevaImagenSeleccionada != null
          ? Value(nuevaImagenPath)
          : const Value.absent(),
    );

    await (db.update(db.clientes)..where((c) => c.id.equals(id))).write(companion);
    await cargarClientes();
  }

  /// Elimina cliente y borra la imagen física si existe.
  Future<void> eliminarCliente(String id, {String? imagenPath}) async {
    if (imagenPath != null && imagenPath.isNotEmpty) {
      final file = File(imagenPath);
      if (await file.exists()) {
        try { await file.delete(); } catch (_) {}
      }
    }

    await (db.delete(db.clientes)..where((c) => c.id.equals(id))).go();
    await cargarClientes();
  }

  // --- Utilidades opcionales ---

  /// Búsqueda simple en memoria (usa tras cargarClientes). Devuelve una lista filtrada.
  List<Cliente> filtrarPorNombre(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _clientes;
    return _clientes.where((c) => (c.nombre ?? '').toLowerCase().contains(q)).toList();
  }
}
