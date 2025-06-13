import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/citas_provider.dart';
import '../providers/extras_servicio_provider.dart';
import '../services/app_database.dart';
import 'package:drift/drift.dart' show Value;

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime fechaSeleccionada = DateTime.now();
  TimeOfDay horaInicio = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay horaFin = const TimeOfDay(hour: 20, minute: 0);

  List<Cita> citasDelDia = [];
  bool cargandoCitas = false;

  @override
  void initState() {
    super.initState();
    cargarCitasDia();
  }

  Future<void> cargarCitasDia() async {
    setState(() => cargandoCitas = true);
    final provider = context.read<CitasProvider>();
    final citas = await provider.obtenerCitasPorDia(fechaSeleccionada);
    setState(() {
      citasDelDia = citas;
      cargandoCitas = false;
    });
  }

  void cambiarFecha(DateTime nuevaFecha) {
    setState(() => fechaSeleccionada = nuevaFecha);
    cargarCitasDia();
  }

  void cambiarHoraInicio(TimeOfDay nuevaHora) {
    setState(() => horaInicio = nuevaHora);
  }

  void cambiarHoraFin(TimeOfDay nuevaHora) {
    setState(() => horaFin = nuevaHora);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final anterior = fechaSeleccionada.subtract(const Duration(days: 1));
              cambiarFecha(anterior);
            },
            tooltip: 'Día anterior',
          ),
          TextButton(
            onPressed: () async {
              final fecha = await showDatePicker(
                context: context,
                initialDate: fechaSeleccionada,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (fecha != null) cambiarFecha(fecha);
            },
            child: Text(
              '${fechaSeleccionada.day.toString().padLeft(2, '0')}/'
              '${fechaSeleccionada.month.toString().padLeft(2, '0')}/'
              '${fechaSeleccionada.year}',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final siguiente = fechaSeleccionada.add(const Duration(days: 1));
              cambiarFecha(siguiente);
            },
            tooltip: 'Día siguiente',
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              const Text('De:', style: TextStyle(color: Colors.black)),
              TextButton(
                onPressed: () async {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: horaInicio,
                  );
                  if (hora != null) cambiarHoraInicio(hora);
                },
                child: Text('${horaInicio.format(context)}', style: const TextStyle(color: Colors.black)),
              ),
              const Text('a', style: TextStyle(color: Colors.black)),
              TextButton(
                onPressed: () async {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: horaFin,
                  );
                  if (hora != null) cambiarHoraFin(hora);
                },
                child: Text('${horaFin.format(context)}', style: const TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
      body: cargandoCitas
          ? const Center(child: CircularProgressIndicator())
          : Padding(
            padding: const EdgeInsets.all(20),
            child: AgendaVisual(
                fecha: fechaSeleccionada,
                horaInicio: horaInicio,
                horaFin: horaFin,
                citas: citasDelDia,
              ),
          ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => NuevaCitaDialog(
              fecha: fechaSeleccionada,
              horaInicial: horaInicio,
            ),
          );
          if (result == true) cargarCitasDia();
        },
      ),
    );
  }
}

class AgendaVisual extends StatelessWidget {
  final DateTime fecha;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;
  final List<Cita> citas;

  const AgendaVisual({
    Key? key,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.citas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Total de minutos de la jornada
    final minutosTotales = (horaFin.hour * 60 + horaFin.minute) -
        (horaInicio.hour * 60 + horaInicio.minute);

    const double paddingInternoSuperior = 16.0;
    const double paddingInternoInferior = 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final alturaAgenda = constraints.maxHeight - paddingInternoSuperior - paddingInternoInferior;
        final alturaPorMinuto = alturaAgenda / minutosTotales;
        final horas = List.generate(
          horaFin.hour - horaInicio.hour + 1,
          (i) => horaInicio.hour + i,
        );

        return Stack(
          children: [
            // Líneas y textos de horas
            ...horas.map((h) {
              final minDesdeInicio = (h - horaInicio.hour) * 60;
              final top = paddingInternoSuperior + minDesdeInicio * alturaPorMinuto;
              return Positioned(
                top: top,
                left: 0,
                right: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        '${h.toString().padLeft(2, '0')}:00',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey.shade400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              );
            }),
            // Bloques de citas (ajusta también el cálculo del top)
            ...citas.map((cita) {
              final minIni = (cita.inicio.hour * 60 + cita.inicio.minute) - (horaInicio.hour * 60 + horaInicio.minute);
              final duracion = cita.fin.difference(cita.inicio).inMinutes;
              final top = paddingInternoSuperior + minIni * alturaPorMinuto;
              final height = duracion * alturaPorMinuto;

              return Positioned(
                left: 88, // tras el texto de hora y separación
                right: 16,
                top: top,
                height: height < 24 ? 24 : height,
                child: Card(
                  color: Colors.blue.shade100,
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      'Cliente: ${cita.clienteId}\nServicio: ${cita.servicioId}\n'
                      '${cita.inicio.hour.toString().padLeft(2, '0')}:${cita.inicio.minute.toString().padLeft(2, '0')}'
                      ' - '
                      '${cita.fin.hour.toString().padLeft(2, '0')}:${cita.fin.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              );
            }),
            // Bloques de citas
            ...citas.map((cita) {
              final minIni = (cita.inicio.hour * 60 + cita.inicio.minute) -
                  (horaInicio.hour * 60 + horaInicio.minute);
              final duracion = cita.fin.difference(cita.inicio).inMinutes;
              final top = minIni * alturaPorMinuto;
              final height = duracion * alturaPorMinuto;

              return Positioned(
                left: 70, // después del texto de hora
                right: 16,
                top: top,
                height: height < 24 ? 24 : height,
                child: Card(
                  color: Colors.blue.shade100,
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      // Puedes sustituir los IDs por nombres reales buscando en providers
                      'Cliente: ${cita.clienteId}\nServicio: ${cita.servicioId}\n'
                      '${cita.inicio.hour.toString().padLeft(2, '0')}:${cita.inicio.minute.toString().padLeft(2, '0')}'
                      ' - '
                      '${cita.fin.hour.toString().padLeft(2, '0')}:${cita.fin.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}



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
  List<String> extrasSeleccionados = [];

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
    final extrasProvider = context.read<ExtrasServicioProvider>();

    return AlertDialog(
      title: const Text('Nueva cita'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: clienteId,
              items: clientes
                  .map((c) =>
                      DropdownMenuItem(value: c.id, child: Text(c.nombre)))
                  .toList(),
              onChanged: (val) => setState(() => clienteId = val),
              decoration: const InputDecoration(labelText: 'Cliente'),
            ),
            DropdownButtonFormField<String>(
              value: servicioId,
              items: servicios
                  .map((s) =>
                      DropdownMenuItem(value: s.id, child: Text(s.nombre)))
                  .toList(),
              onChanged: (val) => setState(() {
                servicioId = val;
                extrasSeleccionados.clear();
              }),
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
                    child: Text('Inicio: ${horaInicio!.format(context)}', style: const TextStyle(color: Colors.black)),
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
                    child: Text('Fin: ${horaFin!.format(context)}', style: const TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
            if (servicioId != null)
              FutureBuilder<List<ExtrasServicioData>>(
                future: extrasProvider.obtenerExtrasPorServicio(servicioId!),
                builder: (context, snapshot) {
                  final extras = snapshot.data ?? [];
                  if (extras.isEmpty) return const SizedBox();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Extras:'),
                      ...extras.map((extra) => CheckboxListTile(
                        value: extrasSeleccionados.contains(extra.id),
                        onChanged: (val) {
                          setState(() {
                            if (val == true) {
                              extrasSeleccionados.add(extra.id);
                            } else {
                              extrasSeleccionados.remove(extra.id);
                            }
                          });
                        },
                        title: Text('${extra.nombre} (+${extra.precio.toStringAsFixed(2)} €)'),
                      )),
                    ],
                  );
                },
              ),
            TextField(
              onChanged: (v) => notas = v,
              decoration: const InputDecoration(labelText: 'Notas'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            final servicios = context.read<ServiciosProvider>().servicios;
            if (clienteId == null || servicioId == null || horaInicio == null || horaFin == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Faltan datos')),
              );
              return;
            }
            final fecha = DateTime(widget.fecha.year, widget.fecha.month, widget.fecha.day, horaInicio!.hour, horaInicio!.minute);
            final fechaFin = DateTime(widget.fecha.year, widget.fecha.month, widget.fecha.day, horaFin!.hour, horaFin!.minute);
            final precioBase = servicios.firstWhere((s) => s.id == servicioId).precio;
            // Suma extras
            double totalExtras = 0.0;
            for (final extraId in extrasSeleccionados) {
            final extra = await (extrasProvider.db.select(extrasProvider.db.extrasServicio)
              ..where((e) => e.id.equals(extraId))
            ).getSingle();
              totalExtras += extra.precio;
            }
            final precioFinal = precioBase + totalExtras;

            final citasProvider = context.read<CitasProvider>();
            final idCita = DateTime.now().millisecondsSinceEpoch.toString();
            await citasProvider.insertarCita(
              clienteId: clienteId!,
              servicioId: servicioId!,
              inicio: fecha,
              fin: fechaFin,
              precio: precioFinal,
              notas: notas,
            );
            // Guarda los extras seleccionados en la tabla intermedia
            for (final extraId in extrasSeleccionados) {
              await extrasProvider.db.into(extrasProvider.db.extrasCita).insert(
                ExtrasCitaCompanion(
                  citaId: Value(idCita),
                  extraId: Value(extraId),
                ),
              );
            }

            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
