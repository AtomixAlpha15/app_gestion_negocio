import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'app_database.g.dart'; // Drift genera este archivo automáticamente

// Tabla de clientes
class Clientes extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get nombre => text()();
  TextColumn get telefono => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get notas => text().nullable()();
  TextColumn get imagenPath => text().nullable()();
  // Auditoría para sincronización (nullable para migración, se rellenan después)
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncId => text().unique().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Tabla de servicios
class Servicios extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  RealColumn get precio => real()();
  IntColumn get duracionMinutos => integer()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get imagenPath => text().nullable()();
  // Auditoría para sincronización
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncId => text().unique().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Tabla de extras asociados a un servicio
class ExtrasServicio extends Table {
  TextColumn get id => text()();
  TextColumn get servicioId => text().references(Servicios, #id)();
  TextColumn get nombre => text()();
  RealColumn get precio => real()();
  // Auditoría para sincronización (nullable para migración)
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncId => text().unique().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

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
  BoolColumn get pagada => boolean().withDefault(const Constant(false))();
  TextColumn get metodoPago => text().nullable()();
  TextColumn get notas => text().nullable()();
  // Auditoría para sincronización (nullable para migración)
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncId => text().unique().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ExtrasCita extends Table {
  TextColumn get citaId => text().references(Citas, #id)();
  TextColumn get extraId => text().references(ExtrasServicio, #id)();
  // Auditoría para sincronización (nullable para migración)
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncId => text().unique().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {citaId, extraId};
}

class Gastos extends Table {
  TextColumn get id => text()();
  TextColumn get concepto => text()();
  RealColumn get precio => real()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)(); // Fecha del gasto
  // Auditoría para sincronización (nullable para migración)
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncId => text().unique().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
// BONOS (por sesiones)
class Bonos extends Table {
  TextColumn get id => text()();
  TextColumn get clienteId => text()();
  TextColumn get servicioId => text()();
  TextColumn get nombre => text().withDefault(const Constant('Bono'))();
  IntColumn get sesionesTotales => integer()();
  IntColumn get sesionesUsadas => integer().withDefault(const Constant(0))();
  RealColumn get precioBono => real().nullable()();
  DateTimeColumn get compradoEl => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get caducaEl => dateTime().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEl => dateTime().withDefault(currentDateAndTime)();
  // Estrategia de reconocimiento contable: 'prorrateado' o 'por_uso'
  TextColumn get reconocimiento => text().withDefault(const Constant('prorrateado'))();
  // Auditoría para sincronización (nullable para migración)
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncId => text().unique().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// CONSUMOS DE BONO (1 fila = 1 sesión usada)
class BonoConsumos extends Table {
  TextColumn get id => text()();
  TextColumn get bonoId => text().references(Bonos, #id)();
  TextColumn get citaId => text().nullable().references(Citas, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  TextColumn get nota => text().nullable()();
  // Auditoría para sincronización (nullable para migración)
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncId => text().unique().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE(cita_id)'];
}

class BonoPagos extends Table {
  TextColumn get id => text()();
  TextColumn get bonoId => text().references(Bonos, #id)();
  RealColumn get importe => real()();
  TextColumn get metodo => text().nullable()();
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  TextColumn get nota => text().nullable()();
  // Auditoría para sincronización (nullable para migración)
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get syncId => text().unique().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}



// Importa las tablas arriba definidas

@DriftDatabase(
  tables: [Clientes, Servicios, Citas, ExtrasServicio,ExtrasCita,Gastos,Bonos,BonoConsumos,BonoPagos],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  Future<File> getDatabaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'negocio_app.sqlite'));
  }
  
  Future<void> closeDatabase() async {
    await close();
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Para el MVP, es más simple recrear la BD que manejar migraciones complejas
      // Esto borra todos los datos pero garantiza la consistencia del esquema
      await m.deleteTable('bono_pagos');
      await m.deleteTable('bono_consumos');
      await m.deleteTable('bonos');
      await m.deleteTable('extras_cita');
      await m.deleteTable('citas');
      await m.deleteTable('extras_servicio');
      await m.deleteTable('gastos');
      await m.deleteTable('servicios');
      await m.deleteTable('clientes');

      // Recrear todas las tablas con el nuevo esquema
      await m.createAll();
    },
  );
}


// Abre la base de datos en la ruta local adecuada
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'negocio_app.sqlite'));
    return NativeDatabase(file);
  });
}