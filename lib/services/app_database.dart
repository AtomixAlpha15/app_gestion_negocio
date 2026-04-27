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
  // Auditoría para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncId => text().unique().nullable()(); // Identificador único del cambio
  BoolColumn get deleted => boolean().withDefault(const Constant(false))(); // Soft delete

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
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
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
  // Auditoría para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
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
  // Auditoría para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncId => text().unique().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ExtrasCita extends Table {
  TextColumn get citaId => text().references(Citas, #id)();
  TextColumn get extraId => text().references(ExtrasServicio, #id)();
  // Auditoría para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
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
  // Auditoría para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
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
  // Auditoría para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
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
  // Auditoría para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
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
  // Auditoría para sincronización
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
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
      if (from < 2) {
        await m.addColumn(servicios, servicios.imagenPath);
      }
      if (from < 3) {
        // Versión 3: Agregar campos de auditoría a todas las tablas
        // Clientes
        await m.addColumn(clientes, clientes.createdAt);
        await m.addColumn(clientes, clientes.updatedAt);
        await m.addColumn(clientes, clientes.syncId);
        await m.addColumn(clientes, clientes.deleted);

        // Servicios
        await m.addColumn(servicios, servicios.createdAt);
        await m.addColumn(servicios, servicios.updatedAt);
        await m.addColumn(servicios, servicios.syncId);
        await m.addColumn(servicios, servicios.deleted);

        // ExtrasServicio
        await m.addColumn(extrasServicio, extrasServicio.createdAt);
        await m.addColumn(extrasServicio, extrasServicio.updatedAt);
        await m.addColumn(extrasServicio, extrasServicio.syncId);
        await m.addColumn(extrasServicio, extrasServicio.deleted);

        // Citas
        await m.addColumn(citas, citas.createdAt);
        await m.addColumn(citas, citas.updatedAt);
        await m.addColumn(citas, citas.syncId);
        await m.addColumn(citas, citas.deleted);

        // ExtrasCita
        await m.addColumn(extrasCita, extrasCita.createdAt);
        await m.addColumn(extrasCita, extrasCita.updatedAt);
        await m.addColumn(extrasCita, extrasCita.syncId);
        await m.addColumn(extrasCita, extrasCita.deleted);

        // Gastos: agregar nueva columna fecha
        await m.addColumn(gastos, gastos.fecha);

        // Agregar campos de auditoría a Gastos
        await m.addColumn(gastos, gastos.createdAt);
        await m.addColumn(gastos, gastos.updatedAt);
        await m.addColumn(gastos, gastos.syncId);
        await m.addColumn(gastos, gastos.deleted);

        // Bonos
        await m.addColumn(bonos, bonos.createdAt);
        await m.addColumn(bonos, bonos.updatedAt);
        await m.addColumn(bonos, bonos.syncId);
        await m.addColumn(bonos, bonos.deleted);

        // BonoConsumos
        await m.addColumn(bonoConsumos, bonoConsumos.createdAt);
        await m.addColumn(bonoConsumos, bonoConsumos.updatedAt);
        await m.addColumn(bonoConsumos, bonoConsumos.syncId);
        await m.addColumn(bonoConsumos, bonoConsumos.deleted);

        // BonoPagos
        await m.addColumn(bonoPagos, bonoPagos.createdAt);
        await m.addColumn(bonoPagos, bonoPagos.updatedAt);
        await m.addColumn(bonoPagos, bonoPagos.syncId);
        await m.addColumn(bonoPagos, bonoPagos.deleted);
      }
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