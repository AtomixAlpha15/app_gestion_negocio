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

// Tabla de establecimientos (centros físicos) — solo Ultra plan
class Establecimientos extends Table {
  TextColumn get id => text()();
  TextColumn get nombre => text()();
  TextColumn get direccion => text().nullable()();
  TextColumn get telefono => text().nullable()();
  BoolColumn get esDefault => boolean().withDefault(const Constant(false))();
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
  // Método de pago: 'efectivo', 'bizum', 'tarjeta', 'otro', o null
  // IMPORTANTE: Usar solo los valores del enum MetodoPago.name (no traducidos)
  // Traducción ocurre solo en UI, no en BD
  TextColumn get metodoPago => text().nullable()();
  TextColumn get notas => text().nullable()();
  // Número de trabajador (1-based); 1 = único/por defecto
  IntColumn get trabajador => integer().withDefault(const Constant(1))();
  // Centro físico (Ultra); null = sin filtro de establecimiento
  TextColumn get establecimientoId => text().nullable()();
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
  // Centro físico (Ultra); null = sin filtro de establecimiento
  TextColumn get establecimientoId => text().nullable()();
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
  tables: [Clientes, Servicios, Citas, ExtrasServicio, ExtrasCita, Gastos, Bonos, BonoConsumos, BonoPagos, Establecimientos],
)
class AppDatabase extends _$AppDatabase {
  final String? userId;
  // true si el archivo SQLite no existía al crear esta instancia
  final bool isNewDatabase;

  AppDatabase([this.userId, this.isNewDatabase = false]) : super(_openConnection(userId));

  Future<Directory> getUserDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    if (userId != null && userId!.isNotEmpty) {
      final dir = Directory(p.join(appDir.path, userId!));
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir;
    }
    return Directory(p.join(appDir.path, 'guest'));
  }

  Future<Directory> getBackupsDir() async {
    final dir = Directory(p.join((await getUserDir()).path, 'backups'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<Directory> getClientImagesDir() async {
    final dir = Directory(p.join((await getUserDir()).path, 'imagenes_clientes'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<Directory> getServiceImagesDir() async {
    final dir = Directory(p.join((await getUserDir()).path, 'imagenes_servicios'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> getDatabaseFile() async {
    final userDir = await getUserDir();
    return File(p.join(userDir.path, 'negocio_app.sqlite'));
  }

  Future<void> closeDatabase() async {
    await close();
  }

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // v1 → v2: servicios.imagenPath añadida
      if (from < 2) {
        await m.addColumn(servicios, servicios.imagenPath);
      }

      // v2 → v3: campos de auditoría (createdAt, updatedAt, syncId, deleted) en todas las tablas
      if (from < 3) {
        await m.addColumn(clientes, clientes.createdAt);
        await m.addColumn(clientes, clientes.updatedAt);
        await m.addColumn(clientes, clientes.syncId);
        await m.addColumn(clientes, clientes.deleted);

        await m.addColumn(servicios, servicios.createdAt);
        await m.addColumn(servicios, servicios.updatedAt);
        await m.addColumn(servicios, servicios.syncId);
        await m.addColumn(servicios, servicios.deleted);

        await m.addColumn(extrasServicio, extrasServicio.createdAt);
        await m.addColumn(extrasServicio, extrasServicio.updatedAt);
        await m.addColumn(extrasServicio, extrasServicio.syncId);
        await m.addColumn(extrasServicio, extrasServicio.deleted);

        await m.addColumn(citas, citas.createdAt);
        await m.addColumn(citas, citas.updatedAt);
        await m.addColumn(citas, citas.syncId);
        await m.addColumn(citas, citas.deleted);

        await m.addColumn(extrasCita, extrasCita.createdAt);
        await m.addColumn(extrasCita, extrasCita.updatedAt);
        await m.addColumn(extrasCita, extrasCita.syncId);
        await m.addColumn(extrasCita, extrasCita.deleted);

        await m.addColumn(gastos, gastos.fecha);
        await m.addColumn(gastos, gastos.createdAt);
        await m.addColumn(gastos, gastos.updatedAt);
        await m.addColumn(gastos, gastos.syncId);
        await m.addColumn(gastos, gastos.deleted);

        await m.addColumn(bonos, bonos.createdAt);
        await m.addColumn(bonos, bonos.updatedAt);
        await m.addColumn(bonos, bonos.syncId);
        await m.addColumn(bonos, bonos.deleted);

        await m.addColumn(bonoConsumos, bonoConsumos.createdAt);
        await m.addColumn(bonoConsumos, bonoConsumos.updatedAt);
        await m.addColumn(bonoConsumos, bonoConsumos.syncId);
        await m.addColumn(bonoConsumos, bonoConsumos.deleted);

        await m.addColumn(bonoPagos, bonoPagos.createdAt);
        await m.addColumn(bonoPagos, bonoPagos.updatedAt);
        await m.addColumn(bonoPagos, bonoPagos.syncId);
        await m.addColumn(bonoPagos, bonoPagos.deleted);
      }

      // v3 → v4: sin cambios de columnas (v3 usaba borrar-recrear, ya tiene el schema correcto)
      // Esta versión solo formaliza la estrategia incremental. No-op para BDs en v3.

      // v4 → v5: multi-agenda — columna trabajador en citas
      if (from < 5) {
        await customStatement(
          'ALTER TABLE citas ADD COLUMN trabajador INTEGER NOT NULL DEFAULT 1',
        );
      }

      // v5 → v6: multi-establecimiento — tabla establecimientos + columnas FK
      if (from < 6) {
        await m.createTable(establecimientos);
        await customStatement('ALTER TABLE citas ADD COLUMN establecimiento_id TEXT');
        await customStatement('ALTER TABLE gastos ADD COLUMN establecimiento_id TEXT');
      }
    },
    beforeOpen: (details) async {
      // Safety net: ensures trabajador column exists even if v5 migration was interrupted.
      final cols5 = await customSelect(
        "SELECT name FROM pragma_table_info('citas') WHERE name='trabajador'",
      ).get();
      if (cols5.isEmpty) {
        await customStatement(
          'ALTER TABLE citas ADD COLUMN trabajador INTEGER NOT NULL DEFAULT 1',
        );
      }

      // Safety net: ensures establecimientos table and FK columns exist (v6).
      final tables = await customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='establecimientos'",
      ).get();
      if (tables.isEmpty) {
        await customStatement('''
          CREATE TABLE IF NOT EXISTS establecimientos (
            id TEXT NOT NULL PRIMARY KEY,
            nombre TEXT NOT NULL,
            direccion TEXT,
            telefono TEXT,
            es_default INTEGER NOT NULL DEFAULT 0,
            created_at INTEGER,
            updated_at INTEGER,
            sync_id TEXT UNIQUE,
            deleted INTEGER NOT NULL DEFAULT 0
          )
        ''');
      }

      final citasCols = await customSelect(
        "SELECT name FROM pragma_table_info('citas') WHERE name='establecimiento_id'",
      ).get();
      if (citasCols.isEmpty) {
        await customStatement('ALTER TABLE citas ADD COLUMN establecimiento_id TEXT');
      }

      final gastosCols = await customSelect(
        "SELECT name FROM pragma_table_info('gastos') WHERE name='establecimiento_id'",
      ).get();
      if (gastosCols.isEmpty) {
        await customStatement('ALTER TABLE gastos ADD COLUMN establecimiento_id TEXT');
      }
    },
  );
}


// Abre la base de datos en la carpeta del usuario
LazyDatabase _openConnection([String? userId]) {
  return LazyDatabase(() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dirName = (userId != null && userId.isNotEmpty) ? userId : 'guest';
    final userDir = Directory(p.join(appDir.path, dirName));
    if (!userDir.existsSync()) userDir.createSync(recursive: true);
    final file = File(p.join(userDir.path, 'negocio_app.sqlite'));
    return NativeDatabase(file);
  });
}
