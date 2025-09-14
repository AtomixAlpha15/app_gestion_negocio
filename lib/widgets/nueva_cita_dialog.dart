import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/citas_provider.dart';
import '../providers/bonos_provider.dart';

class NuevaCitaDialog extends StatefulWidget {
  final DateTime fecha;
  final TimeOfDay? horaInicial;

  const NuevaCitaDialog({super.key, required this.fecha, this.horaInicial});

  @override
  State<NuevaCitaDialog> createState() => _NuevaCitaDialogState();
}

class _NuevaCitaDialogState extends State<NuevaCitaDialog> {
  String? clienteId;
  String? servicioId;
  TimeOfDay? horaInicio;
  TimeOfDay? horaFin;
  String? notas;
  bool pagada = false;
  String? metodoPago;

  @override
  void initState() {
    super.initState();
    horaInicio = widget.horaInicial ?? const TimeOfDay(hour: 9, minute: 0);
    horaFin = TimeOfDay(hour: horaInicio!.hour + 1, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    final clientes = context.read<ClientesProvider>().clientes;
    final servicios = context.read<ServiciosProvider>().servicios;

    return AlertDialog(
      title: const Text('Nueva cita'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: clienteId,
              items: clientes.map((c) =>
                DropdownMenuItem(value: c.id, child: Text(c.nombre))).toList(),
              onChanged: (val) => setState(() => clienteId = val),
              decoration: const InputDecoration(labelText: 'Cliente'),
            ),
            DropdownButtonFormField<String>(
              value: servicioId,
              items: servicios.map((s) =>
                DropdownMenuItem(value: s.id, child: Text(s.nombre))).toList(),
              onChanged: (val) => setState(() => servicioId = val),
              decoration: const InputDecoration(labelText: 'Servicio'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: horaInicio!,
                      );
                      if (picked != null) setState(() => horaInicio = picked);
                    },
                    child: Text('Inicio: ${horaInicio!.format(context)}'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: horaFin!,
                      );
                      if (picked != null) setState(() => horaFin = picked);
                    },
                    child: Text('Fin: ${horaFin!.format(context)}'),
                  ),
                ),
              ],
            ),
            TextField(
              onChanged: (v) => notas = v,
              decoration: const InputDecoration(labelText: 'Notas'),
            ),
            CheckboxListTile(
              value: pagada,
              onChanged: (v) => setState(() => pagada = v ?? false),
              title: const Text('Pagada'),
            ),
            DropdownButtonFormField<String>(
              value: metodoPago,
              items: const [
                DropdownMenuItem(value: null, child: Text('')),
                DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                DropdownMenuItem(value: 'Bizum', child: Text('Bizum')),
                DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
              ],
              onChanged: (v) => setState(() => metodoPago = v),
              decoration: const InputDecoration(labelText: 'Método de pago'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            if (clienteId == null || servicioId == null || horaInicio == null || horaFin == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Faltan datos')),
              );
              return;
            }
            final fecha = DateTime(widget.fecha.year, widget.fecha.month, widget.fecha.day, horaInicio!.hour, horaInicio!.minute);
            final fechaFin = DateTime(widget.fecha.year, widget.fecha.month, widget.fecha.day, horaFin!.hour, horaFin!.minute);
            final precioBase = servicios.firstWhere((s) => s.id == servicioId).precio;

            // 1) Inserta la cita y obtén su ID
            final citasProv = context.read<CitasProvider>();
            final citaId = await citasProv.insertarCitaYDevolverId(
              clienteId: clienteId!,
              servicioId: servicioId!,
              inicio: fecha,
              fin: fechaFin,
              precio: precioBase,
              metodoPago: metodoPago,
              notas: notas,
              pagada: pagada,
            );

            // 2) Intenta aplicar un bono automáticamente (si existe para ese servicio)
            final bonosProv = context.read<BonosProvider>();
            await bonosProv.aplicarBonoSiDisponiblePorId(
              clienteId: clienteId!,
              servicioId: servicioId!,
              citaId: citaId,
            );

            // 3) Refresca y cierra
            await context.read<CitasProvider>().cargarCitasAnio(widget.fecha.year);
            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
