enum MovimientoTipo { cita, bonoPago }

class MovimientoContable {
  final DateTime fecha;
  final String? clienteId;
  final String? servicioId;
  final String? citaId;
  final String detalle;
  final String? metodo;
  final double importe;
  final MovimientoTipo tipo;

  MovimientoContable({
    required this.fecha,
    required this.detalle,
    required this.importe,
    required this.tipo,
    this.clienteId,
    this.servicioId,
    this.citaId,
    this.metodo,
  });
}
