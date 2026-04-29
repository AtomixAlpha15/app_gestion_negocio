import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_shell.dart';
import 'screens/auth/login_screen.dart';
import 'providers/settings_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/clientes_provider.dart';
import 'providers/servicios_provider.dart';
import 'providers/citas_provider.dart';
import 'providers/gastos_provider.dart';
import 'services/app_database.dart';
import 'services/backup_services.dart';
import 'services/sync_service.dart';
import 'l10n/app_localizations.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  SyncService? _syncService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final db = context.read<AppDatabase>();
      final s  = context.read<SettingsProvider>();
      final backup = BackupService(db: db, settings: s);
      await backup.autoBackupIfDue();

      // Si MyApp se acaba de crear y el usuario YA está autenticado (caso
      // típico tras login: el cambio de _userId en AppRoot recrea el
      // MultiProvider y por tanto MyApp, registrando ref.listen DESPUÉS de
      // que el estado pasara a authenticated), arrancar sync manualmente.
      // ref.listen solo se dispara en cambios posteriores a su registro.
      if (!mounted || _syncService != null) return;
      final auth = ref.read(authStateProvider);
      auth.when(
        onAuthenticated: (user) => _startSyncWhenReady(user['id'] as String?),
        onUnauthenticated: () {},
        onLoading: () {},
        onError: (_) {},
      );
    });
  }

  void _startSyncWhenReady(String? targetUserId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _syncService != null) return;
      final db = context.read<AppDatabase>();
      if (db.userId == targetUserId) {
        _startSync(db);
      } else {
        // La BD aún no está actualizada, reintentar en el siguiente frame
        _startSyncWhenReady(targetUserId);
      }
    });
  }

  void _startSync(AppDatabase db) {
    _syncService = ref.read(syncServiceProvider(db));
    _syncService!.onServerChangesApplied = _reloadProviders;
    _syncService!.startPolling();
  }

  void _reloadProviders() {
    if (!mounted) return;
    final anio = DateTime.now().year;
    context.read<ClientesProvider>().cargarClientes();
    context.read<ServiciosProvider>().cargarServicios();
    context.read<CitasProvider>().cargarCitasAnio(anio);
    context.read<GastosProvider>().cargarGastosAnio(anio);
    // BonosProvider consulta bajo demanda, no necesita recarga explícita
  }

  void _stopSync() {
    _syncService?.stopPolling();
    _syncService = null;
  }

  @override
  void dispose() {
    _stopSync();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    // Arrancar/parar sync según cambios de estado de autenticación.
    // Para el caso inicial (estado ya authenticated cuando MyApp se monta),
    // ver initState — ref.listen solo se dispara en cambios POSTERIORES.
    ref.listen(authStateProvider, (previous, next) {
      if (!next.isAuthenticated) {
        _stopSync();
        return;
      }
      if (_syncService != null) return;
      // Esperamos a que _switchDatabase complete y el MultiProvider tenga la BD correcta
      next.when(
        onAuthenticated: (user) => _startSyncWhenReady(user['id'] as String?),
        onUnauthenticated: () {},
        onLoading: () {},
        onError: (_) {},
      );
    });

    // Construimos un ColorScheme completo a partir de los colores del usuario
    // Genera esquema base a partir del color semilla
    final baseScheme = ColorScheme.fromSeed(
      seedColor: settings.colorBase,
      brightness: settings.oscuro ? Brightness.dark : Brightness.light,
    );

    // Si el usuario quiere avanzado, sustituimos secundario/terciario
    final scheme = settings.usarPaletaAuto
      ? baseScheme
      : baseScheme.copyWith(
          secondary: settings.colorSecundarioManual,
          tertiary: settings.colorTerciarioManual,
        );

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: settings.oscuro ? Brightness.dark : Brightness.light,
      colorScheme: scheme,
      textTheme: ThemeData(
        brightness: settings.oscuro ? Brightness.dark : Brightness.light,
      ).textTheme.apply(
        fontFamily: settings.fuente,
      ),
      // Afinamos componentes clave para que tomen bien el esquema de color
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(scheme.primary),
          foregroundColor: WidgetStateProperty.all(scheme.onPrimary),
          overlayColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.pressed)
                  ? scheme.primary.withOpacity(0.12)
                  : null),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(scheme.secondary),
          foregroundColor: WidgetStateProperty.all(scheme.onSecondary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(scheme.primary),
          side: WidgetStateProperty.all(BorderSide(color: scheme.primary)),
          overlayColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.pressed)
                  ? scheme.primary.withOpacity(0.08)
                  : null),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return scheme.outline;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.surfaceVariant;
        }),

        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? scheme.primary.withOpacity(0.5)
              : scheme.outlineVariant;
        }),
        ),
        tabBarTheme: TabBarThemeData(
          indicatorColor: scheme.secondary,
          labelColor: scheme.onSurface,
          unselectedLabelColor: scheme.onSurfaceVariant,
          dividerColor: scheme.outlineVariant,
        ),

        chipTheme: ChipThemeData(
          selectedColor: scheme.secondaryContainer,
          backgroundColor: scheme.surfaceVariant,
          labelStyle: TextStyle(color: scheme.onSurface),
          secondaryLabelStyle: TextStyle(color: scheme.onSecondaryContainer),
          side: BorderSide(color: scheme.outlineVariant),
        ),

        toggleButtonsTheme: ToggleButtonsThemeData(
          selectedColor: scheme.onSecondaryContainer,
          color: scheme.onSurface,
          fillColor: scheme.secondaryContainer,
          borderColor: scheme.outlineVariant,
          selectedBorderColor: scheme.secondary,
        ),

        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith(
            (s) => s.contains(MaterialState.selected) ? scheme.secondary : scheme.outline,
          ),
        ),

        sliderTheme: SliderThemeData(
          activeTrackColor: scheme.secondary,
          thumbColor: scheme.secondary,
          inactiveTrackColor: scheme.secondary.withOpacity(0.24),
        ),

        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: scheme.secondary,
          linearTrackColor: scheme.secondary.withOpacity(0.2),
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: scheme.tertiaryContainer,
          contentTextStyle: TextStyle(color: scheme.onTertiaryContainer),
          actionTextColor: scheme.tertiary,
        ),


      // Cards y ListTiles más coherentes con el esquema
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        selectedColor: scheme.primary,
        selectedTileColor: scheme.primary.withOpacity(0.08),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: baseTheme,
      locale: settings.locale,
      supportedLocales: const [Locale('es'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Escalado global del texto según ajustes (sin usar textTheme.apply factor)
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        final scale = settings.tamanoFuente; // p.ej. 0.90, 1.00, 1.20

        try {
          // Flutter moderno (TextScaler)
          return MediaQuery(
            data: mq.copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          );
        } catch (_) {
          // Fallback para versiones antiguas (textScaleFactor)
          return MediaQuery(
            data: mq.copyWith(textScaleFactor: scale),
            child: child!,
          );
        }
      },

      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      onAuthenticated: (user) => const MainShell(),
      onUnauthenticated: () => const LoginScreen(),
      onLoading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      onError: (message) => const LoginScreen(),
    );
  }
}
