import 'cliente.dart';
import 'servicio.dart';

enum MetodoPago { efectivo, bizum, tarjeta, otro }

class Cita {
  final String id;
  final Cliente cliente;
  final Servicio servicio;
  final DateTime inicio;
  final DateTime fin;
  final double precio;
  final MetodoPago? metodoPago;
  final String notas;

  Cita({
    required this.id,
    required this.cliente,
    required this.servicio,
    required this.inicio,
    required this.fin,
    required this.precio,
    this.metodoPago,
    required this.notas,
  });
}
