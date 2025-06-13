import 'package:flutter/material.dart';

import '../services/app_database.dart';
import 'package:drift/drift.dart';


class CitasProvider extends ChangeNotifier {
  final AppDatabase db;
  CitasProvider(this.db);

  Future<List<Cita>> obtenerCitasPorDia(DateTime dia) async {
    final inicio = DateTime(dia.year, dia.month, dia.day, 0, 0, 0);
    final fin = DateTime(dia.year, dia.month, dia.day, 23, 59, 59);
    return await (db.select(db.citas)
      ..where((c) => c.inicio.isBiggerOrEqualValue(inicio) & c.inicio.isSmallerOrEqualValue(fin))
      ..orderBy([(c) => OrderingTerm(expression: c.inicio)]))
      .get();
  }

  Future<void> insertarCita({
    required String clienteId,
    required String servicioId,
    required DateTime inicio,
    required DateTime fin,
    required double precio,
    String? metodoPago,
    String? notas,
    bool pagada = false,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final cita = CitasCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      servicioId: Value(servicioId),
      inicio: Value(inicio),
      fin: Value(fin),
      precio: Value(precio),
      metodoPago: Value(metodoPago),
      notas: Value(notas),
      pagada: Value(pagada),
    );
    await db.into(db.citas).insert(cita);
    notifyListeners();
  }

  Future<void> eliminarCita(String id) async {
    await (db.delete(db.citas)..where((c) => c.id.equals(id))).go();
    notifyListeners();
  }

  // Métodos para editar cita, asociar extras, etc.
}
