import 'package:flutter/material.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import 'providers/servicios_provider.dart';
import 'providers/clientes_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/contabilidad_provider.dart';
import 'providers/gastos_provider.dart';
import 'providers/extras_servicio_provider.dart';
import 'providers/bonos_provider.dart';
import 'package:app_gestion_negocio/providers/citas_provider.dart';
import '../services/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Una única instancia de SettingsProvider
  final settingsProvider = SettingsProvider();
  await settingsProvider.cargarAjustes();

  // 2) Una única instancia de AppDatabase compartida por toda la app
  final db = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        // Exponemos la instancia única de db
        Provider<AppDatabase>.value(value: db),

        // Settings: reutilizamos el mismo objeto creado arriba
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),

        // El resto de providers usan SIEMPRE la misma instancia 'db'
        ChangeNotifierProvider(create: (_) => ClientesProvider(db)),
        ChangeNotifierProvider(create: (_) => ServiciosProvider(db)),
        ChangeNotifierProvider(create: (_) => ExtrasServicioProvider(db)),
        ChangeNotifierProvider(create: (_) => CitasProvider(db)),
        ChangeNotifierProvider(create: (_) => GastosProvider(db)),
        ChangeNotifierProvider(create: (_) => BonosProvider(db)),
        ChangeNotifierProvider(create: (_) => ContabilidadProvider(db)),
      ],
      child: const MyApp(),
    ),
  );
}