// Utilidades para manejo de métodos de pago
// Los valores se almacenan en BD como strings constantes
// La traducción ocurre SOLO en la UI, nunca en la lógica de negocio

import '../models/cita.dart';

class MetodoPagoUtils {
  // Valores constantes que se guardan en BD (NUNCA cambiar estos strings)
  static const String efectivoValue = 'efectivo';
  static const String bizumValue = 'bizum';
  static const String tarjetaValue = 'tarjeta';
  static const String otroValue = 'otro';

  // Convertir enum a string para BD
  static String enumToDbString(MetodoPago pago) {
    return pago.name;
  }

  // Convertir string de BD a enum
  static MetodoPago? dbStringToEnum(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return MetodoPago.values.firstWhere((e) => e.name == value);
    } catch (e) {
      return null;
    }
  }

  // Traducir enum a texto legible en la UI
  static String translateMetodo(MetodoPago? pago, String locale) {
    if (pago == null) return '';

    switch (pago) {
      case MetodoPago.efectivo:
        return locale == 'en' ? 'Cash' : 'Efectivo';
      case MetodoPago.bizum:
        return 'Bizum';
      case MetodoPago.tarjeta:
        return locale == 'en' ? 'Card' : 'Tarjeta';
      case MetodoPago.otro:
        return locale == 'en' ? 'Other' : 'Otro';
    }
  }

  // Traducir string BD a texto legible (para código que aún usa strings)
  static String translateString(String? value, String locale) {
    if (value == null || value.isEmpty) return '';
    final enum_ = dbStringToEnum(value);
    return translateMetodo(enum_, locale);
  }
}
