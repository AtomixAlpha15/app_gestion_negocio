import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart'; // Drift genera este archivo automáticamente

// Tabla de clientes
class Clientes extends Table {
  TextColumn get id => text()(); // Puedes usar UUID o autoincrement()
  TextColumn get nombre => text()();
  TextColumn get telefono => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get notas => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Tabla de servicios
class Servicios extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  RealColumn get precio => real()();
  IntColumn get duracionMinutos => integer()(); // Usar minutos como entero
  TextColumn get descripcion => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

// Tabla de citas
class Citas extends Table {
  TextColumn get id => text()();
  TextColumn get clienteId => text().references(Clientes, #id)();
  TextColumn get servicioId => text().references(Servicios, #id)();
  DateTimeColumn get inicio => dateTime()();
  DateTimeColumn get fin => dateTime()();
  RealColumn get precio => real()();
  TextColumn get metodoPago => text().nullable()(); // 'efectivo', 'bizum', etc
  TextColumn get notas => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

// Importa las tablas arriba definidas

@DriftDatabase(
  tables: [Clientes, Servicios, Citas],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

// Abre la base de datos en la ruta local adecuada
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'negocio_app.sqlite'));
    return NativeDatabase(file);
  });
}