import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/clientes_provider.dart';
import 'providers/servicios_provider.dart';
import 'providers/extras_servicio_provider.dart';
import 'providers/citas_provider.dart';
import 'providers/gastos_provider.dart';
import 'providers/bonos_provider.dart';
import 'providers/contabilidad_provider.dart';
import 'services/app_database.dart';

const _kCurrentUserIdKey = 'current_user_id';

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({super.key});

  @override
  ConsumerState<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  String? _userId;
  AppDatabase? _db;
  SettingsProvider? _settingsProvider;
  bool _initialized = false;
  // Controla qué switch es el más reciente; aborta los anteriores
  int _switchGeneration = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_kCurrentUserIdKey);

    final settings = SettingsProvider(userId: userId);
    await settings.cargarAjustes();

    final isNewDb = await _isNewDatabase(userId);

    setState(() {
      _userId = userId;
      _db = AppDatabase(userId, isNewDb);
      _settingsProvider = settings;
      _initialized = true;
    });
  }

  Future<bool> _isNewDatabase(String? userId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final dirName = (userId != null && userId.isNotEmpty) ? userId : 'guest';
    final dbFile = File(p.join(appDir.path, dirName, 'negocio_app.sqlite'));
    final exists = dbFile.existsSync();
    debugPrint('[DB] Comprobando archivo BD: ${dbFile.path} → existe=$exists');
    return !exists;
  }

  Future<void> _switchDatabase(String? newUserId) async {
    if (newUserId == _userId) return;

    // Capturar la generación actual; si llega otro switch antes de que
    // terminemos, esta operación ya no es la más reciente y se cancela.
    final myGeneration = ++_switchGeneration;

    await _db?.close();
    if (myGeneration != _switchGeneration) return;

    final prefs = await SharedPreferences.getInstance();
    if (newUserId != null) {
      await prefs.setString(_kCurrentUserIdKey, newUserId);
    } else {
      await prefs.remove(_kCurrentUserIdKey);
    }

    final newSettings = SettingsProvider(userId: newUserId);
    await newSettings.cargarAjustes();
    if (myGeneration != _switchGeneration) return;

    final isNewDb = await _isNewDatabase(newUserId);
    if (myGeneration != _switchGeneration) return;

    if (mounted) {
      setState(() {
        _userId = newUserId;
        _db = AppDatabase(newUserId, isNewDb);
        _settingsProvider = newSettings;
      });
    }
  }

  @override
  void dispose() {
    _db?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    // Cambiar base de datos cuando cambia el usuario autenticado
    ref.listen(authStateProvider, (previous, next) {
      String? newUserId;
      next.when(
        onAuthenticated: (user) => newUserId = user['id'] as String?,
        onUnauthenticated: () => newUserId = null,
        onLoading: () {},
        onError: (_) {},
      );

      if (newUserId != _userId) {
        _switchDatabase(newUserId);
      }
    });

    final db = _db!;

    return provider.MultiProvider(
      key: ValueKey(_userId), // Reconstruye todos los providers al cambiar de usuario
      providers: [
        provider.Provider<AppDatabase>.value(value: db),
        provider.ChangeNotifierProvider<SettingsProvider>.value(
          value: _settingsProvider!,
        ),
        provider.ChangeNotifierProvider(create: (_) => ClientesProvider(db)),
        provider.ChangeNotifierProvider(create: (_) => ServiciosProvider(db)),
        provider.ChangeNotifierProvider(create: (_) => ExtrasServicioProvider(db)),
        provider.ChangeNotifierProvider(create: (_) => CitasProvider(db)),
        provider.ChangeNotifierProvider(create: (_) => GastosProvider(db)),
        provider.ChangeNotifierProvider(create: (_) => BonosProvider(db)),
        provider.ChangeNotifierProvider(create: (_) => ContabilidadProvider(db)),
      ],
      child: const MyApp(),
    );
  }
}
