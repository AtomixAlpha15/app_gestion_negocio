import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SettingsProvider extends ChangeNotifier {
  final String? userId;

  SettingsProvider({this.userId});

  String _k(String key) =>
      (userId != null && userId!.isNotEmpty) ? '${userId}_$key' : key;

  Future<Directory> getUserDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    if (userId != null && userId!.isNotEmpty) {
      final dir = Directory(p.join(appDir.path, userId!));
      if (!await dir.exists()) await dir.create(recursive: true);
      return dir;
    }
    return Directory(p.join(appDir.path, 'guest'));
  }
  // --- PERSONALIZACIÓN VISUAL ---
  String fuente = "Roboto";
  double tamanoFuente = 1.0; // 0.85: pequeño, 1.0: mediano, 1.25: grande
  bool oscuro = false;

  // --- DATOS DE EMPRESA ---
  String logoPath = "";
  String nombreEmpresa = "Mi Empresa";
  String direccion = "";
  String telefono = "";
  String email = "";
  int numeroEmpleados = 1;

  // --- PREFERENCIAS DE INTERFAZ ---
  // languageCode: 'es' | 'en' | ... (BCP-47)
  String idioma = "es";
  // formatoFecha: 'DD/MM/YYYY' | 'MM/DD/YYYY' | 'YYYY-MM-DD'
  String formatoFecha = "DD/MM/YYYY";
  // simboloMoneda: '€' | '$' | '£' | 'JPY' | ...
  String simboloMoneda = "€";

  // --- NOTIFICACIONES ---
  bool alertasImpagos = true;
  bool notifCitas = true;
  bool notifClientesInactivos = false;
  int diasInactividad = 30;

  // --- NUEVO MODELO DE COLORES ---
  Color _colorBase = const Color(0xFF6750A4);
  bool _usarPaletaAuto = true;
  Color _colorSecundarioManual = const Color(0xFF625B71);
  Color _colorTerciarioManual = const Color(0xFF7D5260);

  Color get colorBase => _colorBase;
  bool get usarPaletaAuto => _usarPaletaAuto;
  Color get colorSecundarioManual => _colorSecundarioManual;
  Color get colorTerciarioManual => _colorTerciarioManual;

  // ====== AUTO BACKUP LOCAL ======
  int intervaloBackupDias = 7;
  DateTime? ultimaFechaBackup;

  // ── Helpers internacionales ──────────────────────────────────────────────

  /// Locale activo derivado de [idioma]
  Locale get locale => Locale(idioma);

  /// Formatea [dt] según el formato de fecha elegido por el usuario.
  String formatDate(DateTime dt) {
    switch (formatoFecha) {
      case 'MM/DD/YYYY':
        return '${dt.month.toString().padLeft(2, '0')}/'
            '${dt.day.toString().padLeft(2, '0')}/'
            '${dt.year}';
      case 'YYYY-MM-DD':
        return '${dt.year}-'
            '${dt.month.toString().padLeft(2, '0')}-'
            '${dt.day.toString().padLeft(2, '0')}';
      case 'DD/MM/YYYY':
      default:
        return '${dt.day.toString().padLeft(2, '0')}/'
            '${dt.month.toString().padLeft(2, '0')}/'
            '${dt.year}';
    }
  }

  /// Formatea [dt] con fecha + hora (HH:mm) según el formato elegido.
  String formatDateTime(DateTime dt) {
    final time =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '${formatDate(dt)}  $time';
  }

  /// Formatea [amount] con el símbolo de moneda elegido.
  /// [decimals] controla los dígitos decimales (por defecto 2).
  String formatCurrency(double amount, {int decimals = 2}) {
    final formatted = amount.toStringAsFixed(decimals);
    // Monedas que van delante del número
    const prefixSymbols = {'\$', '¥', '₩', '₹', 'C\$', 'MX\$'};
    if (prefixSymbols.contains(simboloMoneda)) {
      return '$simboloMoneda$formatted';
    }
    return '$formatted $simboloMoneda';
  }

  /// Nombre abreviado del mes para el locale activo (ene, feb… / Jan, Feb…).
  String monthAbbrev(int month) {
    return DateFormat('MMM', idioma).format(DateTime(2000, month));
  }

  /// Nombre completo del mes para el locale activo.
  String monthName(int month) {
    return DateFormat('MMMM', idioma).format(DateTime(2000, month));
  }

  /// Nombre abreviado del día de la semana (lun, mar… / Mon, Tue…).
  String weekdayAbbrev(int weekday) {
    // weekday: 1=Monday … 7=Sunday
    final date = DateTime(2000, 1, 2 + (weekday - 1)); // 2000-01-03 = lunes
    return DateFormat('EEE', idioma).format(date);
  }

  // ---- Claves SharedPreferences ----
  static const _kFuente                 = 'aj_fuente';
  static const _kTamanoFuente           = 'aj_tamano_fuente';
  static const _kOscuro                 = 'aj_oscuro';

  static const _kNombreEmpresa          = 'aj_nombre_empresa';
  static const _kLogoPath               = 'aj_logo_path';
  static const _kTelefono               = 'aj_telefono';
  static const _kEmail                  = 'aj_email';
  static const _kDireccion              = 'aj_direccion';

  static const _kIdioma                 = 'aj_idioma';
  static const _kFormatoFecha           = 'aj_formato_fecha';
  static const _kSimboloMoneda          = 'aj_simbolo_moneda';
  static const _kAlertasImpagos         = 'aj_alertas_impagos';
  static const _kNotifCitas             = 'aj_notif_citas';
  static const _kNotifClientesInactivos = 'aj_notif_clientes_inactivos';
  static const _kDiasInactividad        = 'aj_dias_inactividad';

  static const _kColorBase              = 'aj_color_base';
  static const _kUsarPaletaAuto         = 'aj_usar_paleta_auto';
  static const _kColorSecundarioManual  = 'aj_color_secundario_manual';
  static const _kColorTerciarioManual   = 'aj_color_terciario_manual';

  // ---------- CARGAR ----------
  Future<void> cargarAjustes() async {
    final prefs = await SharedPreferences.getInstance();

    fuente        = prefs.getString(_k(_kFuente))        ?? "Roboto";
    tamanoFuente  = prefs.getDouble(_k(_kTamanoFuente))  ?? 1.0;
    oscuro        = prefs.getBool(_k(_kOscuro))          ?? false;

    nombreEmpresa   = prefs.getString(_k(_kNombreEmpresa)) ?? "Mi Empresa";
    logoPath        = prefs.getString(_k(_kLogoPath))      ?? "";
    telefono        = prefs.getString(_k(_kTelefono))      ?? "";
    email           = prefs.getString(_k(_kEmail))         ?? "";
    direccion       = prefs.getString(_k(_kDireccion))     ?? "";
    numeroEmpleados = prefs.getInt(_k('numeroEmpleados'))  ?? 1;

    // Migración: si se guardó el nombre completo ("Español") convertir a código BCP-47
    final rawIdioma = prefs.getString(_k(_kIdioma)) ?? "es";
    idioma = _migrarIdioma(rawIdioma);

    formatoFecha  = prefs.getString(_k(_kFormatoFecha))  ?? "DD/MM/YYYY";
    simboloMoneda = prefs.getString(_k(_kSimboloMoneda)) ?? "€";
    alertasImpagos         = prefs.getBool(_k(_kAlertasImpagos))          ?? true;
    notifCitas             = prefs.getBool(_k(_kNotifCitas))              ?? true;
    notifClientesInactivos = prefs.getBool(_k(_kNotifClientesInactivos))  ?? false;
    diasInactividad        = prefs.getInt(_k(_kDiasInactividad))          ?? 30;

    final baseInt = prefs.getInt(_k(_kColorBase));
    if (baseInt != null) _colorBase = Color(baseInt);

    _usarPaletaAuto = prefs.getBool(_k(_kUsarPaletaAuto)) ?? true;

    final secManInt = prefs.getInt(_k(_kColorSecundarioManual));
    if (secManInt != null) _colorSecundarioManual = Color(secManInt);

    final terManInt = prefs.getInt(_k(_kColorTerciarioManual));
    if (terManInt != null) _colorTerciarioManual = Color(terManInt);

    intervaloBackupDias = prefs.getInt(_k('intervaloBackupDias')) ?? 7;
    final lastIso = prefs.getString(_k('ultimaFechaBackup'));
    ultimaFechaBackup = lastIso != null ? DateTime.tryParse(lastIso) : null;

    notifyListeners();
  }

  // Convierte valores legacy a códigos BCP-47
  static String _migrarIdioma(String v) {
    switch (v) {
      case 'Español': return 'es';
      case 'English': return 'en';
      default: return v; // ya es código corto o desconocido → mantener
    }
  }

  // ---------- GUARDAR ----------
  Future<void> guardarAjustes() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_k(_kFuente), fuente);
    await prefs.setDouble(_k(_kTamanoFuente), tamanoFuente);
    await prefs.setBool(_k(_kOscuro), oscuro);

    await prefs.setString(_k(_kNombreEmpresa), nombreEmpresa);
    await prefs.setString(_k(_kLogoPath), logoPath);
    await prefs.setString(_k(_kTelefono), telefono);
    await prefs.setString(_k(_kEmail), email);
    await prefs.setString(_k(_kDireccion), direccion);
    await prefs.setInt(_k('numeroEmpleados'), numeroEmpleados);

    await prefs.setString(_k(_kIdioma), idioma);
    await prefs.setString(_k(_kFormatoFecha), formatoFecha);
    await prefs.setString(_k(_kSimboloMoneda), simboloMoneda);
    await prefs.setBool(_k(_kAlertasImpagos), alertasImpagos);
    await prefs.setBool(_k(_kNotifCitas), notifCitas);
    await prefs.setBool(_k(_kNotifClientesInactivos), notifClientesInactivos);
    await prefs.setInt(_k(_kDiasInactividad), diasInactividad);

    await prefs.setInt(_k(_kColorBase), _colorBase.toARGB32());
    await prefs.setBool(_k(_kUsarPaletaAuto), _usarPaletaAuto);
    await prefs.setInt(_k(_kColorSecundarioManual), _colorSecundarioManual.toARGB32());
    await prefs.setInt(_k(_kColorTerciarioManual), _colorTerciarioManual.toARGB32());

    await prefs.setInt(_k('intervaloBackupDias'), intervaloBackupDias);
    await prefs.setString(_k('ultimaFechaBackup'), ultimaFechaBackup?.toIso8601String() ?? '');
  }

  // --------- SETTERS REACTIVOS ---------
  Future<void> setColorBase(Color c) async {
    _colorBase = c;
    await guardarAjustes();
    notifyListeners();
  }

  Future<void> setUsarPaletaAuto(bool v) async {
    _usarPaletaAuto = v;
    await guardarAjustes();
    notifyListeners();
  }

  Future<void> setColorSecundarioManual(Color c) async {
    _colorSecundarioManual = c;
    await guardarAjustes();
    notifyListeners();
  }

  Future<void> setColorTerciarioManual(Color c) async {
    _colorTerciarioManual = c;
    await guardarAjustes();
    notifyListeners();
  }

  void setFuente(String nuevaFuente) {
    fuente = nuevaFuente;
    guardarAjustes();
    notifyListeners();
  }

  void setTamanoFuente(double nuevoTamano) {
    tamanoFuente = nuevoTamano;
    guardarAjustes();
    notifyListeners();
  }

  void setOscuro(bool value) {
    oscuro = value;
    guardarAjustes();
    notifyListeners();
  }

  void setLogoPath(String path) {
    logoPath = path;
    guardarAjustes();
    notifyListeners();
  }

  void deleteLogoPath(String path) {
    logoPath = '';
    guardarAjustes();
    notifyListeners();
  }

  void setNombreEmpresa(String nombre) {
    nombreEmpresa = nombre;
    guardarAjustes();
    notifyListeners();
  }

  void setDireccion(String dir) {
    direccion = dir;
    guardarAjustes();
    notifyListeners();
  }

  void setTelefono(String tel) {
    telefono = tel;
    guardarAjustes();
    notifyListeners();
  }

  void setEmail(String mail) {
    email = mail;
    guardarAjustes();
    notifyListeners();
  }

  void setNumeroEmpleados(int n) {
    if (n < 1) n = 1;
    numeroEmpleados = n;
    guardarAjustes();
    notifyListeners();
  }

  void setIdioma(String id) {
    idioma = id;
    guardarAjustes();
    notifyListeners();
  }

  void setFormatoFecha(String f) {
    formatoFecha = f;
    guardarAjustes();
    notifyListeners();
  }

  void setSimboloMoneda(String sim) {
    simboloMoneda = sim;
    guardarAjustes();
    notifyListeners();
  }

  void setAlertasImpagos(bool v) {
    alertasImpagos = v;
    guardarAjustes();
    notifyListeners();
  }

  void setNotifCitas(bool v) {
    notifCitas = v;
    guardarAjustes();
    notifyListeners();
  }

  void setNotifClientesInactivos(bool v) {
    notifClientesInactivos = v;
    guardarAjustes();
    notifyListeners();
  }

  void setDiasInactividad(int v) {
    diasInactividad = v.clamp(7, 90);
    guardarAjustes();
    notifyListeners();
  }

  void setIntervaloBackupDias(int d) {
    intervaloBackupDias = d.clamp(1, 365);
    guardarAjustes();
    notifyListeners();
  }

  void setUltimaFechaBackup(DateTime dt) {
    ultimaFechaBackup = dt;
    guardarAjustes();
    notifyListeners();
  }

  // ---------- SNAPSHOT PARA BACKUP ----------
  Map<String, dynamic> toBackupMap() {
    return {
      'fuente': fuente,
      'tamanoFuente': tamanoFuente,
      'oscuro': oscuro,
      'usarPaletaAuto': usarPaletaAuto,
      'colorBase': colorBase.toARGB32(),
      'colorSecundarioManual': colorSecundarioManual.toARGB32(),
      'colorTerciarioManual': colorTerciarioManual.toARGB32(),
      'logoFile': logoPath.isEmpty ? '' : logoPath.split(Platform.pathSeparator).last,
      'nombreEmpresa': nombreEmpresa,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'numeroEmpleados': numeroEmpleados,
      'idioma': idioma,
      'formatoFecha': formatoFecha,
      'simboloMoneda': simboloMoneda,
      'alertasImpagos': alertasImpagos,
    };
  }

  Future<void> applyBackupMap(Map<String, dynamic> m, {String? overrideLogoPath}) async {
    fuente = (m['fuente'] ?? fuente) as String;
    tamanoFuente = (m['tamanoFuente'] ?? tamanoFuente) as double;
    oscuro = (m['oscuro'] ?? oscuro) as bool;

    await setUsarPaletaAuto(m['usarPaletaAuto'] ?? usarPaletaAuto);
    await setColorBase(Color((m['colorBase'] ?? colorBase.toARGB32()) as int));
    await setColorSecundarioManual(Color((m['colorSecundarioManual'] ?? colorSecundarioManual.toARGB32()) as int));
    await setColorTerciarioManual(Color((m['colorTerciarioManual'] ?? colorTerciarioManual.toARGB32()) as int));

    final logoFileInJson = (m['logoFile'] ?? '') as String;
    if (overrideLogoPath != null && overrideLogoPath.isNotEmpty) {
      logoPath = overrideLogoPath;
    } else if (logoFileInJson.isNotEmpty) {
      final userDir = await getUserDir();
      logoPath = p.join(userDir.path, logoFileInJson);
    }
    nombreEmpresa = (m['nombreEmpresa'] ?? nombreEmpresa) as String;
    direccion = (m['direccion'] ?? direccion) as String;
    telefono = (m['telefono'] ?? telefono) as String;
    email = (m['email'] ?? email) as String;
    numeroEmpleados = (m['numeroEmpleados'] ?? numeroEmpleados) as int;

    final rawIdioma = (m['idioma'] ?? idioma) as String;
    idioma = _migrarIdioma(rawIdioma);
    formatoFecha = (m['formatoFecha'] ?? formatoFecha) as String;
    simboloMoneda = (m['simboloMoneda'] ?? simboloMoneda) as String;
    alertasImpagos = (m['alertasImpagos'] ?? alertasImpagos) as bool;

    await guardarAjustes();
    notifyListeners();
  }

  // ------- RESTABLECER A VALORES POR DEFECTO -------
  void restablecerAjustes() {
    fuente = "Roboto";
    tamanoFuente = 1.0;
    oscuro = false;

    _colorBase = const Color(0xFF6750A4);
    _usarPaletaAuto = true;
    _colorSecundarioManual = const Color(0xFF625B71);
    _colorTerciarioManual  = const Color(0xFF7D5260);

    logoPath = "";
    nombreEmpresa = "Mi Empresa";
    direccion = "";
    telefono = "";
    email = "";
    idioma = "es";
    formatoFecha = "DD/MM/YYYY";
    simboloMoneda = "€";
    alertasImpagos = true;
    notifCitas = true;
    notifClientesInactivos = false;
    diasInactividad = 30;

    guardarAjustes();
    notifyListeners();
  }
}
