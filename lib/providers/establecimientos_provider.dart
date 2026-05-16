import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../services/app_database.dart';

class EstablecimientosProvider extends ChangeNotifier {
  final AppDatabase db;

  List<Establecimiento> _establecimientos = [];
  List<Establecimiento> get establecimientos => _establecimientos;

  EstablecimientosProvider(this.db);

  Future<void> cargarEstablecimientos() async {
    _establecimientos = await (db.select(db.establecimientos)
          ..where((e) => e.deleted.equals(false))
          ..orderBy([(e) => OrderingTerm(expression: e.nombre)]))
        .get();

    // Auto-crea el establecimiento "Principal" si no hay ninguno
    if (_establecimientos.isEmpty) {
      await _crearDefault();
      _establecimientos = await (db.select(db.establecimientos)
            ..where((e) => e.deleted.equals(false)))
          .get();
    }

    notifyListeners();
  }

  Future<String> _crearDefault() async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await db.into(db.establecimientos).insert(EstablecimientosCompanion(
      id: Value(id),
      nombre: const Value('Principal'),
      esDefault: const Value(true),
      syncId: Value(const Uuid().v4()),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
    return id;
  }

  Future<String> crearEstablecimiento({
    required String nombre,
    String? direccion,
    String? telefono,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now();
    await db.into(db.establecimientos).insert(EstablecimientosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      direccion: Value(direccion),
      telefono: Value(telefono),
      syncId: Value(const Uuid().v4()),
      createdAt: Value(now),
      updatedAt: Value(now),
    ));
    await cargarEstablecimientos();
    return id;
  }

  Future<void> actualizarEstablecimiento({
    required String id,
    required String nombre,
    String? direccion,
    String? telefono,
  }) async {
    await (db.update(db.establecimientos)..where((e) => e.id.equals(id))).write(
      EstablecimientosCompanion(
        nombre: Value(nombre),
        direccion: Value(direccion),
        telefono: Value(telefono),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await cargarEstablecimientos();
  }

  Future<void> eliminarEstablecimiento(String id) async {
    await (db.update(db.establecimientos)..where((e) => e.id.equals(id))).write(
      EstablecimientosCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await cargarEstablecimientos();
  }

  Establecimiento? porId(String id) {
    try {
      return _establecimientos.firstWhere((e) => e.id == id);
    } catch (_) {
      return _establecimientos.isNotEmpty ? _establecimientos.first : null;
    }
  }
}
