import 'package:app_gestion_negocio/providers/citas_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/servicios_provider.dart';
import 'services/app_database.dart';
import 'providers/clientes_provider.dart';
import 'providers/extras_servicio_provider.dart';
import 'screens/main_shell.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(create: (_) => AppDatabase()),
        ChangeNotifierProvider(create: (context) => ClientesProvider(context.read<AppDatabase>()),),
        ChangeNotifierProvider(create: (context) => ServiciosProvider(context.read<AppDatabase>())),
        ChangeNotifierProvider(create: (context) => ExtrasServicioProvider(context.read<AppDatabase>())),
        ChangeNotifierProvider(create: (context) => CitasProvider(context.read<AppDatabase>())),
      ],
      child: MaterialApp(
        title: 'Aplicación Negocio',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}
