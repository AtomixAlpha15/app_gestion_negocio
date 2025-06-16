
import 'package:app_gestion_negocio/screens/main_shell.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';



void main() {
  runApp(
      const MyApp(),
    );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _logueado = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // otros parámetros (title, theme, etc)
      home: _logueado
          ? MainShell() // Tu dashboard principal (contabilidad, agenda, etc)
          : LoginScreen(
              onLoginOk: () {
                setState(() => _logueado = true);
              },
            ),
    );
  }
}
