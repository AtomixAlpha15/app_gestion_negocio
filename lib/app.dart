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
    // SettingsProvider global, reactivo
    final settings = context.watch<SettingsProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // El theme global depende en caliente de los ajustes del usuario
      theme: ThemeData(
        useMaterial3: true,
        brightness: settings.oscuro ? Brightness.dark : Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: settings.colorPrimario,
          primary: settings.colorPrimario,
          secondary: settings.colorSecundario,
          tertiary: settings.colorTerciario,
          brightness: settings.oscuro ? Brightness.dark : Brightness.light,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          fontFamily: settings.fuente,
          fontSizeFactor: settings.tamanoFuente,
        ),
        // O si prefieres modo oscuro por defecto:
        // textTheme: ThemeData(brightness: settings.oscuro ? Brightness.dark : Brightness.light)
        //     .textTheme
        //     .apply(fontFamily: settings.fuente, fontSizeFactor: settings.tamanoFuente),
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
