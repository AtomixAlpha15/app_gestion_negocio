import 'package:flutter/material.dart';
import 'app.dart';
import 'package:provider/provider.dart';
import 'providers/servicios_provider.dart';
import 'providers/clientes_provider.dart';
import 'providers/gastos_provider.dart';
import 'providers/extras_servicio_provider.dart';
import 'package:app_gestion_negocio/providers/citas_provider.dart';
import '../services/app_database.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(create: (_) => AppDatabase()),
        ChangeNotifierProvider(create: (context) => ClientesProvider(context.read<AppDatabase>()),),
        ChangeNotifierProvider(create: (context) => ServiciosProvider(context.read<AppDatabase>())),
        ChangeNotifierProvider(create: (context) => ExtrasServicioProvider(context.read<AppDatabase>())),
        ChangeNotifierProvider(create: (context) => CitasProvider(context.read<AppDatabase>())),
        ChangeNotifierProvider(create: (context) => GastosProvider(context.read<AppDatabase>())),
      ],
      child: const MyApp(),
    ),
  );
}
