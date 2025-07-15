import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // --- PERSONALIZACIÓN VISUAL ---
  String fuente = "Roboto";
  double tamanoFuente = 1.0; // 0.85: pequeño, 1.0: mediano, 1.25: grande
  bool oscuro = false;
  Color colorPrimario = Colors.blue;
  Color colorSecundario = Colors.green;
  Color colorTerciario = Colors.orange;

  // --- DATOS DE EMPRESA ---
  String logoPath = "";
  String nombreEmpresa = "Mi Empresa";
  String direccion = "";
  String telefono = "";
  String email = "";

  // --- PREFERENCIAS DE INTERFAZ ---
  String idioma = "Español";
  String formatoFecha = "DD/MM/YYYY";
  String simboloMoneda = "€";
  double anchoMenu = 240.0;

  // --- NOTIFICACIONES Y CAMPOS EXTRA ---
  bool alertasImpagos = true;

  // --- AVANZADO/MULTIEMPRESA/USUARIOS ---
  // Puedes expandir aquí con arrays, maps o modelos

   Future<void> cargarAjustes() async {
    final prefs = await SharedPreferences.getInstance();
    fuente = prefs.getString('fuente') ?? "Roboto";
    tamanoFuente = prefs.getDouble('tamanoFuente') ?? 1.0;
    oscuro = prefs.getBool('oscuro') ?? false;
    colorPrimario = Color(prefs.getInt('colorPrimario') ?? Colors.blue.value);
    colorSecundario = Color(prefs.getInt('colorSecundario') ?? Colors.green.value);
    colorTerciario = Color(prefs.getInt('colorTerciario') ?? Colors.orange.value);
    logoPath = prefs.getString('logoPath') ?? "";
    nombreEmpresa = prefs.getString('nombreEmpresa') ?? "Mi Empresa";
    direccion = prefs.getString('direccion') ?? "";
    telefono = prefs.getString('telefono') ?? "";
    email = prefs.getString('email') ?? "";
    idioma = prefs.getString('idioma') ?? "Español";
    formatoFecha = prefs.getString('formatoFecha') ?? "DD/MM/YYYY";
    simboloMoneda = prefs.getString('simboloMoneda') ?? "€";
    anchoMenu = prefs.getDouble('anchoMenu') ?? 240.0;
    alertasImpagos = prefs.getBool('alertasImpagos') ?? true;
    notifyListeners();
  }

  Future<void> guardarAjustes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fuente', fuente);
    await prefs.setDouble('tamanoFuente', tamanoFuente);
    await prefs.setBool('oscuro', oscuro);
    await prefs.setInt('colorPrimario', colorPrimario.value);
    await prefs.setInt('colorSecundario', colorSecundario.value);
    await prefs.setInt('colorTerciario', colorTerciario.value);
    await prefs.setString('logoPath', logoPath);
    await prefs.setString('nombreEmpresa', nombreEmpresa);
    await prefs.setString('direccion', direccion);
    await prefs.setString('telefono', telefono);
    await prefs.setString('email', email);
    await prefs.setString('idioma', idioma);
    await prefs.setString('formatoFecha', formatoFecha);
    await prefs.setString('simboloMoneda', simboloMoneda);
    await prefs.setDouble('anchoMenu', anchoMenu);
    await prefs.setBool('alertasImpagos', alertasImpagos);
    print(prefs.getString('fuente'));
  }

  // --------- SETTERS REACTIVOS ---------
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
  void setColorPrimario(Color c) {
    colorPrimario = c;
    guardarAjustes();
    notifyListeners();
  }
  void setColorSecundario(Color c) {
    colorSecundario = c;
    guardarAjustes();
    notifyListeners();
  }
  void setColorTerciario(Color c) {
    colorTerciario = c;
    guardarAjustes();
    notifyListeners();
  }
  void setLogoPath(String path) {
    logoPath = path;
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

  // ------- RESTABLECER A VALORES POR DEFECTO -------
  void restablecerAjustes() {
    fuente = "Roboto";
    tamanoFuente = 1.0;
    oscuro = false;
    colorPrimario = Colors.blue;
    colorSecundario = Colors.green;
    colorTerciario = Colors.orange;
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

  // Aquí puedes añadir métodos para importar/exportar, backup, etc.

  // Métodos para guardar/cargar en shared_preferences o BD, según necesites
}
