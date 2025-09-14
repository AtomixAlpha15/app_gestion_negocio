import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SettingsProvider extends ChangeNotifier {
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
  int numeroEmpleados = 1; // nuevo (mínimo 1)

  // --- PREFERENCIAS DE INTERFAZ ---
  String idioma = "Español";
  String formatoFecha = "DD/MM/YYYY";
  String simboloMoneda = "€";
  double anchoMenu = 240.0;

  // --- NOTIFICACIONES Y CAMPOS EXTRA ---
  bool alertasImpagos = true;

  // --- NUEVO MODELO DE COLORES ---
  Color _colorBase = const Color(0xFF6750A4); // por defecto agradable M3
  bool _usarPaletaAuto = true;

  // Colores manuales opcionales (modo avanzado)
  Color _colorSecundarioManual = const Color(0xFF625B71);
  Color _colorTerciarioManual = const Color(0xFF7D5260);

  // Getters nuevos
  Color get colorBase => _colorBase;
  bool get usarPaletaAuto => _usarPaletaAuto;
  Color get colorSecundarioManual => _colorSecundarioManual;
  Color get colorTerciarioManual => _colorTerciarioManual;

  // ====== AUTO BACKUP LOCAL ======
  int intervaloBackupDias = 7;      // cada cuántos días hacer copia
  DateTime? ultimaFechaBackup;      // cuándo se hizo la última copia

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
  static const _kAnchoMenu              = 'aj_ancho_menu';
  static const _kAlertasImpagos         = 'aj_alertas_impagos';

  // Nuevas
  static const _kColorBase              = 'aj_color_base';
  static const _kUsarPaletaAuto         = 'aj_usar_paleta_auto';
  static const _kColorSecundarioManual  = 'aj_color_secundario_manual';
  static const _kColorTerciarioManual   = 'aj_color_terciario_manual';

  // ---------- CARGAR ----------
  Future<void> cargarAjustes() async {
    final prefs = await SharedPreferences.getInstance();

    fuente        = prefs.getString(_kFuente)        ?? "Roboto";
    tamanoFuente  = prefs.getDouble(_kTamanoFuente)  ?? 1.0;
    oscuro        = prefs.getBool(_kOscuro)          ?? false;

    nombreEmpresa = prefs.getString(_kNombreEmpresa) ?? "Mi Empresa";
    logoPath      = prefs.getString(_kLogoPath)      ?? "";
    telefono      = prefs.getString(_kTelefono)      ?? "";
    email         = prefs.getString(_kEmail)         ?? "";
    direccion     = prefs.getString(_kDireccion)     ?? "";
    numeroEmpleados = prefs.getInt('numeroEmpleados') ?? 1;

    idioma        = prefs.getString(_kIdioma)        ?? "Español";
    formatoFecha  = prefs.getString(_kFormatoFecha)  ?? "DD/MM/YYYY";
    simboloMoneda = prefs.getString(_kSimboloMoneda) ?? "€";
    anchoMenu     = prefs.getDouble(_kAnchoMenu)     ?? 240.0;
    alertasImpagos= prefs.getBool(_kAlertasImpagos)  ?? true;

    // Nuevos colores
    final baseInt = prefs.getInt(_kColorBase);
    if (baseInt != null) _colorBase = Color(baseInt);

    _usarPaletaAuto = prefs.getBool(_kUsarPaletaAuto) ?? true;

    final secManInt = prefs.getInt(_kColorSecundarioManual);
    if (secManInt != null) _colorSecundarioManual = Color(secManInt);

    final terManInt = prefs.getInt(_kColorTerciarioManual);
    if (terManInt != null) _colorTerciarioManual = Color(terManInt);

    //Auto Backup
    intervaloBackupDias = prefs.getInt('intervaloBackupDias') ?? 7;
    final lastIso = prefs.getString('ultimaFechaBackup');
    ultimaFechaBackup = lastIso != null ? DateTime.tryParse(lastIso) : null;

    notifyListeners();
  }

  // ---------- GUARDAR ----------
  Future<void> guardarAjustes() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_kFuente, fuente);
    await prefs.setDouble(_kTamanoFuente, tamanoFuente);
    await prefs.setBool(_kOscuro, oscuro);

    await prefs.setString(_kNombreEmpresa, nombreEmpresa);
    await prefs.setString(_kLogoPath, logoPath);
    await prefs.setString(_kTelefono, telefono);
    await prefs.setString(_kEmail, email);
    await prefs.setString(_kDireccion, direccion);
    await prefs.setInt('numeroEmpleados', numeroEmpleados);

    await prefs.setString(_kIdioma, idioma);
    await prefs.setString(_kFormatoFecha, formatoFecha);
    await prefs.setString(_kSimboloMoneda, simboloMoneda);
    await prefs.setDouble(_kAnchoMenu, anchoMenu);
    await prefs.setBool(_kAlertasImpagos, alertasImpagos);

    // Nuevos colores
    await prefs.setInt(_kColorBase, _colorBase.value);
    await prefs.setBool(_kUsarPaletaAuto, _usarPaletaAuto);
    await prefs.setInt(_kColorSecundarioManual, _colorSecundarioManual.value);
    await prefs.setInt(_kColorTerciarioManual, _colorTerciarioManual.value);

    //Auto Backup

    await prefs.setInt('intervaloBackupDias', intervaloBackupDias);
    await prefs.setString('ultimaFechaBackup', ultimaFechaBackup?.toIso8601String() ?? '');

  }

  // --------- SETTERS REACTIVOS (nuevos) ---------
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

  // --------- SETTERS REACTIVOS (existentes) ---------
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
  void setAnchoMenu(double ancho) {
    anchoMenu = ancho;
    guardarAjustes();
    notifyListeners();
  }
  void setAlertasImpagos(bool v) {
    alertasImpagos = v;
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

  // ---------- SNAPSHOT A/B DEL PROVIDER (para backup) ----------

  // -> Exporta todos los valores “duraderos” a un Map sencillo
  Map<String, dynamic> toBackupMap() {
    return {
      // Visual
      'fuente': fuente,
      'tamanoFuente': tamanoFuente,
      'oscuro': oscuro,
      // Paleta
      'usarPaletaAuto': usarPaletaAuto,
      'colorBase': colorBase.value,
      'colorSecundarioManual': colorSecundarioManual.value,
      'colorTerciarioManual': colorTerciarioManual.value,

      // Empresa
      // IMPORTANTE: guardamos SOLO el nombre de archivo del logo (lo mapearemos al path real al restaurar)
      'logoFile': logoPath.isEmpty ? '' : logoPath.split(Platform.pathSeparator).last,
      'nombreEmpresa': nombreEmpresa,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'numeroEmpleados': numeroEmpleados,

      // Interfaz
      'idioma': idioma,
      'formatoFecha': formatoFecha,
      'simboloMoneda': simboloMoneda,
      'anchoMenu': anchoMenu,
      'alertasImpagos': alertasImpagos,
    };
  }

  // -> Aplica un Map (normalmente el settings.json del backup)
  //    Si ya has copiado los assets y conoces el path real del logo,
  //    pásalo en overrideLogoPath para almacenarlo tal cual.
  Future<void> applyBackupMap(Map<String, dynamic> m, {String? overrideLogoPath}) async {
    // Visual
    fuente = (m['fuente'] ?? fuente) as String;
    tamanoFuente = (m['tamanoFuente'] ?? tamanoFuente) as double;
    oscuro = (m['oscuro'] ?? oscuro) as bool;

    // Paleta
    await setUsarPaletaAuto(m['usarPaletaAuto'] ?? usarPaletaAuto);
    await setColorBase(Color((m['colorBase'] ?? colorBase.value) as int));
    await setColorSecundarioManual(Color((m['colorSecundarioManual'] ?? colorSecundarioManual.value) as int));
    await setColorTerciarioManual(Color((m['colorTerciarioManual'] ?? colorTerciarioManual.value) as int));

    // Empresa
    final logoFileInJson = (m['logoFile'] ?? '') as String;
    if (overrideLogoPath != null && overrideLogoPath.isNotEmpty) {
      logoPath = overrideLogoPath; // ya mapeado a ruta absoluta restaurada
    } else if (logoFileInJson.isNotEmpty) {
      // Si no nos pasaron override, intentamos resolverlo en Documentos
      final docs = await getApplicationDocumentsDirectory();
      logoPath = '${docs.path}${Platform.pathSeparator}$logoFileInJson';
    }
    nombreEmpresa = (m['nombreEmpresa'] ?? nombreEmpresa) as String;
    direccion = (m['direccion'] ?? direccion) as String;
    telefono = (m['telefono'] ?? telefono) as String;
    email = (m['email'] ?? email) as String;
    numeroEmpleados = (m['numeroEmpleados'] ?? numeroEmpleados) as int;

    // Interfaz
    idioma = (m['idioma'] ?? idioma) as String;
    formatoFecha = (m['formatoFecha'] ?? formatoFecha) as String;
    simboloMoneda = (m['simboloMoneda'] ?? simboloMoneda) as String;
    anchoMenu = (m['anchoMenu'] ?? anchoMenu) as double;
    alertasImpagos = (m['alertasImpagos'] ?? alertasImpagos) as bool;

    await guardarAjustes();
    notifyListeners();
  }

  // ------- RESTABLECER A VALORES POR DEFECTO -------
  void restablecerAjustes() {
    fuente = "Roboto";
    tamanoFuente = 1.0;
    oscuro = false;

    // Reset nuevo modelo de colores
    _colorBase = const Color(0xFF6750A4);
    _usarPaletaAuto = true;
    _colorSecundarioManual = const Color(0xFF625B71);
    _colorTerciarioManual  = const Color(0xFF7D5260);

    logoPath = "";
    nombreEmpresa = "Mi Empresa";
    direccion = "";
    telefono = "";
    email = "";
    idioma = "Español";
    formatoFecha = "DD/MM/YYYY";
    simboloMoneda = "€";
    anchoMenu = 240.0;
    alertasImpagos = true;

    guardarAjustes();
    notifyListeners();
  }
}
