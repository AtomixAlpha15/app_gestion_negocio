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

  Future<void> cargarClientes() async {
    _clientes = await db.select(db.clientes).get();
    notifyListeners();
  }

  Future<void> insertarCliente({
    required String nombre,
    String? telefono,
    String? email,
    String? notas,
    String? imagenSeleccionada,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    String? nuevaImagenPath;
    if (imagenSeleccionada != null) {
      nuevaImagenPath = await guardarImagenEnAppDir(imagenSeleccionada, id);
    }

    final cliente = ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
      email: Value(email),
      notas: Value(notas),
      imagenPath: Value(nuevaImagenPath),
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
    String? nuevaImagenPath;
    if (nuevaImagenSeleccionada != null) {
      nuevaImagenPath = await guardarImagenEnAppDir(nuevaImagenSeleccionada, id);
    }

    final companion = ClientesCompanion(
      nombre: Value(nombre),
      telefono: Value(telefono),
      email: Value(email),
      notas: Value(notas),
      imagenPath: nuevaImagenSeleccionada != null
          ? Value(nuevaImagenPath)
          : const Value.absent(),
    );

    await (db.update(db.clientes)..where((c) => c.id.equals(id))).write(companion);
    await cargarClientes();
  }

Future<void> eliminarCliente(String id, {String? imagenPath}) async {
  // Borra físicamente la imagen si existe
  if (imagenPath != null) {
    final archivo = File(imagenPath);
    if (await archivo.exists()) {
      await archivo.delete();
    }
  }
  // Borra el cliente de la base de datos
  await (db.delete(db.clientes)..where((c) => c.id.equals(id))).go();
  await cargarClientes();
}
}