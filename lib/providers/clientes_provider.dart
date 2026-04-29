import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';
import '../services/app_database.dart';
import '../utils/image_utils.dart';

class ClientesProvider extends ChangeNotifier {
  final AppDatabase db;
  ClientesProvider(this.db);

  List<Cliente> _clientes = [];
  List<Cliente> get clientes => _clientes;

  Future<void> cargarClientes() async {
    _clientes = await (db.select(db.clientes)
      ..where((c) => c.deleted.equals(false))).get();
    notifyListeners();
  }

  Future<Cliente?> getClienteById(String id) async {
    return (db.select(db.clientes)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertarCliente({
    required String nombre,
    String? telefono,
    String? email,
    String? notas,
    String? imagenSeleccionada,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();

    String? nuevaImagenPath;
    final clean = (imagenSeleccionada ?? '').trim();
    if (clean.isNotEmpty) {
      nuevaImagenPath = await guardarImagenEnAppDir(
        origenPath: clean,
        entidadId: id,
        targetDir: await db.getClientImagesDir(),
      );
    }

    final cliente = ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
      email: Value(email),
      notas: Value(notas),
      imagenPath: Value(nuevaImagenPath),
      syncId: Value(const Uuid().v4()),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await db.into(db.clientes).insert(cliente);
    await cargarClientes();
  }

  Future<void> actualizarCliente({
    required String id,
    required String nombre,
    String? telefono,
    String? email,
    String? notas,
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
          targetDir: await db.getClientImagesDir(),
        );
        imagenValue = Value(nuevaImagenPath);
      }
    }

    final companion = ClientesCompanion(
      nombre: Value(nombre),
      telefono: Value(telefono),
      email: Value(email),
      notas: Value(notas),
      imagenPath: imagenValue,
      updatedAt: Value(DateTime.now()),
    );

    await (db.update(db.clientes)..where((c) => c.id.equals(id))).write(companion);
    await cargarClientes();
  }

  Future<void> eliminarCliente(String id, {String? imagenPath}) async {
    if (imagenPath != null && imagenPath.isNotEmpty) {
      final file = File(imagenPath);
      if (await file.exists()) {
        try { await file.delete(); } catch (_) {}
      }
    }

    // Soft delete para sincronización
    await (db.update(db.clientes)..where((c) => c.id.equals(id))).write(
      ClientesCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await cargarClientes();
  }

  List<Cliente> filtrarPorNombre(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _clientes;
    return _clientes.where((c) => c.nombre.toLowerCase().contains(q)).toList();
  }
}
