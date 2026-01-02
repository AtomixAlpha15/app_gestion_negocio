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
  TextColumn get imagenPath => text().nullable()();
  
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
  TextColumn get imagenPath => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

// Tabla de extras asociados a un servicio
class ExtrasServicio extends Table {
  TextColumn get id => text()();
  TextColumn get servicioId => text().references(Servicios, #id)();
  TextColumn get nombre => text()();
  RealColumn get precio => real()();
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
  TextColumn get metodoPago => text().nullable()(); // 'efectivo', 'bizum', etc
  TextColumn get notas => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class ExtrasCita extends Table {
  TextColumn get citaId => text().references(Citas, #id)();
  TextColumn get extraId => text().references(ExtrasServicio, #id)();
  @override
  Set<Column> get primaryKey => {citaId, extraId};
}

class Gastos extends Table {
  TextColumn get id => text()();
  TextColumn get concepto => text()();
  RealColumn get precio => real()();
  IntColumn get mes => integer()(); // 1-12
  IntColumn get anio => integer()();
  @override
  Set<Column> get primaryKey => {id};
}
// BONOS (por sesiones)
class Bonos extends Table {
  TextColumn get id => text()();                   // uuid
  TextColumn get clienteId => text()();            // cliente dueño del bono
  TextColumn get servicioId => text()();           // servicio al que aplica
  TextColumn get nombre => text().withDefault(const Constant('Bono'))();
  IntColumn get sesionesTotales => integer()();    // p.ej. 10
  IntColumn get sesionesUsadas => integer().withDefault(const Constant(0))();
  RealColumn get precioBono => real().nullable()(); // opcional (ventas futuras)
  DateTimeColumn get compradoEl => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get caducaEl => dateTime().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get creadoEl => dateTime().withDefault(currentDateAndTime)();
  TextColumn get reconocimiento => text().withDefault(const Constant('prorrateado'))(); 

  @override
  Set<Column> get primaryKey => {id};
}

// CONSUMOS DE BONO (1 fila = 1 sesión usada)
class BonoConsumos extends Table {
  TextColumn get id => text()();              // uuid
  TextColumn get bonoId => text().references(Bonos, #id)();          // FK -> bonos.id
  TextColumn get citaId =>text().nullable().references(Citas, #id, onDelete: KeyAction.cascade)();  // cita donde se consumió (opcional)
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  TextColumn get nota => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
  
    @override
  List<String> get customConstraints => ['UNIQUE(cita_id)']; // <- clave
}

class BonoPagos extends Table {
  TextColumn get id => text()();                         // uuid
  TextColumn get bonoId => text().references(Bonos, #id)(); // FK -> bonos.id
  RealColumn get importe => real()();                    // + cobro / - devolución
  TextColumn get metodo => text().nullable()();          // 'efectivo' | 'bizum' | 'tarjeta' | ...
  DateTimeColumn get fecha => dateTime().withDefault(currentDateAndTime)();
  TextColumn get nota  => text().nullable()();

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
  int get schemaVersion => 2;

    @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // Añadimos columna nueva a servicios
        await m.addColumn(servicios, servicios.imagenPath);
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