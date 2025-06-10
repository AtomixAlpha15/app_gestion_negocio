import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../services/app_database.dart';

// Cambia a ChangeNotifier si quieres notificar a la UI automáticamente
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
  }) async {
    final cliente = ClientesCompanion(
      id: Value(DateTime.now().millisecondsSinceEpoch.toString()), // o usa uuid
      nombre: Value(nombre),
      telefono: Value(telefono),
      email: Value(email),
      notas: Value(notas),
    );
    await db.into(db.clientes).insert(cliente);
    await cargarClientes();
  }

  Future<void> eliminarCliente(String id) async {
    await (db.delete(db.clientes)..where((c) => c.id.equals(id))).go();
    await cargarClientes();
  }
}
