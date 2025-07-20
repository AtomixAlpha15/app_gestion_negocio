import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_shell.dart';
import 'screens/login_screen.dart';
import 'providers/settings_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _logueado = false;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    // Si quieres que el tipo y tamaño de letra sean realmente globales:
    final fontFamily = settings.fuente;
    final fontScale = settings.tamanoFuente;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: settings.oscuro ? Brightness.dark : Brightness.light,
        primaryColor: settings.colorPrimario,
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.colorPrimario,
          primary: settings.colorPrimario,
          secondary: settings.colorSecundario,
          tertiary: settings.colorTerciario,
          brightness: settings.oscuro ? Brightness.dark : Brightness.light,
        ),
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: fontFamily,
          fontSizeFactor: fontScale,
        ),
        useMaterial3: true,
      ),
      home: _logueado
          ? MainShell()
          : LoginScreen(
              onLoginOk: () {
                setState(() => _logueado = true);
              },
            ),
    );
  }
}
