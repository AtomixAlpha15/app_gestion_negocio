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

      home: _logueado
          ? const MainShell()
          : LoginScreen(
              onLoginOk: () {
                setState(() => _logueado = true);
              },
            ),
    );
  }
}
