import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/citas_provider.dart';
import '../providers/bonos_provider.dart';
import '../providers/extras_servicio_provider.dart';
import '../services/app_database.dart';

// Helper para Dart < 3
extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

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
  Map<String, List<String>> _servicioYExtrasPorCita = {};
  bool cargandoCitas = false;

  @override
  void initState() {
    super.initState();
    cargarCitasDia();
    context.read<ServiciosProvider>().cargarServicios();
    context.read<ClientesProvider>().cargarClientes();
  }

  Future<void> cargarCitasDia() async {
    setState(() => cargandoCitas = true);
    final provider = context.read<CitasProvider>();
    final serviciosProvider = context.read<ServiciosProvider>();
    final extrasProvider = context.read<ExtrasServicioProvider>();

    final citas = await provider.obtenerCitasPorDia(fechaSeleccionada);
    final serviciosMap = {for (var s in serviciosProvider.servicios) s.id: s.nombre};

    final Map<String, List<String>> servicioYExtrasPorCita = {};
    final db = extrasProvider.db;

    for (final cita in citas) {
      final nombres = <String>[serviciosMap[cita.servicioId] ?? 'Servicio'];
      final extrasCita = await (db.select(db.extrasCita)..where((e) => e.citaId.equals(cita.id))).get();
      for (final ec in extrasCita) {
        final extra = await (db.select(db.extrasServicio)..where((ex) => ex.id.equals(ec.extraId))).getSingle();
        nombres.add(extra.nombre);
      }
      servicioYExtrasPorCita[cita.id] = nombres;
    }

    setState(() {
      citasDelDia = citas;
      _servicioYExtrasPorCita = servicioYExtrasPorCita;
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
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
              style: text.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface),
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
              Text('De:', style: text.bodyMedium?.copyWith(color: scheme.onSurface)),
              TextButton(
                onPressed: () async {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: horaInicio,
                  );
                  if (hora != null) cambiarHoraInicio(hora);
                },
                child: Text(horaInicio.format(context)),
              ),
              Text('a', style: text.bodyMedium?.copyWith(color: scheme.onSurface)),
              TextButton(
                onPressed: () async {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: horaFin,
                  );
                  if (hora != null) cambiarHoraFin(hora);
                },
                child: Text(horaFin.format(context)),
              ),
            ],
          ),
        ],
      ),
      body: cargandoCitas
          ? const Center(child: CircularProgressIndicator())
          : AgendaVisual(
              fecha: fechaSeleccionada,
              horaInicio: horaInicio,
              horaFin: horaFin,
              citas: citasDelDia,
              servicioYExtrasPorCita: _servicioYExtrasPorCita,
              onEditarCita: (cita) async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => NuevaCitaDialog(
                    fecha: cita.inicio,
                    cita: cita,
                  ),
                );
                if (result == true) cargarCitasDia();
              },
            ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AgendaVisual extends StatelessWidget {
  final DateTime fecha;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;
  final List<Cita> citas;
  final Map<String, List<String>> servicioYExtrasPorCita;
  final void Function(Cita cita)? onEditarCita;

  const AgendaVisual({
    Key? key,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.citas,
    required this.servicioYExtrasPorCita,
    this.onEditarCita,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double paddingInternoSuperior = 16.0;
    const double paddingInternoInferior = 64.0;
    final minutosTotales =
        (horaFin.hour * 60 + horaFin.minute) - (horaInicio.hour * 60 + horaInicio.minute);

    final clientes = context.watch<ClientesProvider>().clientes;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
                        style: text.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: scheme.outlineVariant,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Bloques de citas
            ...citas.map((cita) {
              final minIni = (cita.inicio.hour * 60 + cita.inicio.minute) + 8
                  - (horaInicio.hour * 60 + horaInicio.minute);
              final duracion = cita.fin.difference(cita.inicio).inMinutes;
              final top = paddingInternoSuperior + minIni * alturaPorMinuto;
              final height = duracion * alturaPorMinuto;

              final cliente = clientes.firstWhereOrNull((c) => c.id == cita.clienteId);
              final nombreCliente = cliente?.nombre ?? 'Cliente';
              final nombreServicioYExtras = (servicioYExtrasPorCita[cita.id] ?? []).join(' + ');

              final inicioHoy = DateTime.now();
              final hoy = DateTime(inicioHoy.year, inicioHoy.month, inicioHoy.day);

              final esPasada = cita.inicio.isBefore(hoy);
              final impagada = (cita.metodoPago == null || cita.metodoPago!.isEmpty) && esPasada;

              final Color bg =
                  impagada ? scheme.tertiaryContainer : scheme.secondaryContainer;
              final Color fg =
                  impagada ? scheme.onTertiaryContainer : scheme.onSecondaryContainer;

              final textStyle = text.bodySmall?.copyWith(color: fg);

              return Positioned(
                left: 88,
                right: 16,
                top: top,
                height: height < 28 ? 28 : height,
                child: GestureDetector(
                  onTap: () {
                    if (onEditarCita != null) onEditarCita!(cita);
                  },
                  child: Card(
                    color: bg,
                    elevation: 1,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: scheme.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        '$nombreCliente\n'
                        '$nombreServicioYExtras\n'
                        '${cita.inicio.hour.toString().padLeft(2, '0')}:${cita.inicio.minute.toString().padLeft(2, '0')}'
                        ' - '
                        '${cita.fin.hour.toString().padLeft(2, '0')}:${cita.fin.minute.toString().padLeft(2, '0')}',
                        style: textStyle,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
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
  final Cita? cita; 

  const NuevaCitaDialog({super.key, required this.fecha, this.horaInicial, this.cita});

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
  bool pagada = false;
  String? metodoPago;

  @override
  void initState() {
    super.initState();
    if (widget.cita != null) {
      clienteId = widget.cita!.clienteId;
      servicioId = widget.cita!.servicioId;
      horaInicio = TimeOfDay(hour: widget.cita!.inicio.hour, minute: widget.cita!.inicio.minute);
      horaFin = TimeOfDay(hour: widget.cita!.fin.hour, minute: widget.cita!.fin.minute);
      notas = widget.cita!.notas;
    } else {
      horaInicio = widget.horaInicial ?? const TimeOfDay(hour: 9, minute: 0);
      horaFin = TimeOfDay(hour: horaInicio!.hour + 1, minute: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final clientes = context.read<ClientesProvider>().clientes;
    final servicios = context.read<ServiciosProvider>().servicios;
    final extrasProvider = context.read<ExtrasServicioProvider>();

    return AlertDialog(
      title: Text(widget.cita == null ? 'Nueva cita' : 'Editar cita'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: clienteId,
              items: clientes
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre)))
                  .toList(),
              onChanged: (val) => setState(() => clienteId = val),
              decoration: const InputDecoration(labelText: 'Cliente'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: servicioId,
              items: servicios
                  .map((s) => DropdownMenuItem(value: s.id, child: Text(s.nombre)))
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
                    child: Text('Inicio: ${horaInicio?.format(context) ?? ''}'),
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
                    child: Text('Fin: ${horaFin?.format(context) ?? ''}'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (servicioId != null)
              FutureBuilder<List<ExtrasServicioData>>(
                future: extrasProvider.obtenerExtrasPorServicio(servicioId!),
                builder: (context, snapshot) {
                  final extras = snapshot.data ?? [];
                  if (extras.isEmpty) return const SizedBox();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Extras:', style: text.titleSmall),
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
              controller: TextEditingController(text: notas ?? ''),
              onChanged: (v) => notas = v,
              decoration: const InputDecoration(labelText: 'Notas'),
            ),
          ],
        ),
      ),
      actions: [
        if (widget.cita != null)
          TextButton(
            onPressed: () async {
              final bonosProv = context.read<BonosProvider>();
              final citasProv = context.read<CitasProvider>();

              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('¿Eliminar cita?'),
                  content: const Text('Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
                  ],
                ),
              );

              if (confirm == true) {
                final citaId  = widget.cita!.id;
                final anio    = widget.cita!.inicio.year;

                // 1) Eliminar la cita
                await citasProv.eliminarCita(citaId, anio: anio);

                // 2) Intentar eliminar el consumo asociado, si lo hay
                await bonosProv.eliminarConsumoPorCita(citaId);

                if (context.mounted) Navigator.pop(context, true);
              }
            },
            child: Text('Eliminar cita', style: TextStyle(color: scheme.error)),
          ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
        onPressed: () async {
          if (clienteId == null || servicioId == null || horaInicio == null || horaFin == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Faltan datos')),
            );
            return;
          }

          final inicio = DateTime(widget.fecha.year, widget.fecha.month, widget.fecha.day, horaInicio!.hour, horaInicio!.minute);
          final fin    = DateTime(widget.fecha.year, widget.fecha.month, widget.fecha.day, horaFin!.hour, horaFin!.minute);

          final servicios  = context.read<ServiciosProvider>().servicios;
          final precioBase = servicios.firstWhere((s) => s.id == servicioId).precio;

          final citasProv = context.read<CitasProvider>();
          final bonosProv = context.read<BonosProvider>();

          // Bono disponible => metodoPago 'Bono' y precio 0
          double precioFinal = precioBase;
          String? metodoPagoFinal = metodoPago;

          final bonoActivo = await bonosProv.bonoActivoPara(clienteId!, servicioId!);
          final hayBonoDisponible = bonoActivo != null &&
                                    (await bonosProv.sesionesAsignadasBono(bonoActivo.id)) < bonoActivo.sesionesTotales;

          if (hayBonoDisponible) {
            metodoPagoFinal = 'Bono';
            precioFinal = 0.0;
          }

          final editando = widget.cita != null;
          String citaId;

          if (editando) {
            // EDITAR: actualizar la misma cita (NO tocar consumo)
            citaId = widget.cita!.id;

            await citasProv.actualizarCita(
              id: citaId,
              clienteId: clienteId!,
              servicioId: servicioId!,
              inicio: inicio,
              fin: fin,
              metodoPago: metodoPagoFinal,
              precio: precioFinal,
              pagada: (metodoPagoFinal != null && metodoPagoFinal.isNotEmpty),
              notas: notas,
            );

            // NO crear ni borrar consumo aquí: mover fecha no cambia asignación.

          } else {
            // CREAR: insertar y obtener id
            citaId = await citasProv.insertarCita(
              clienteId: clienteId!,
              servicioId: servicioId!,
              inicio: inicio,
              fin: fin,
              precio: precioFinal,
              metodoPago: metodoPagoFinal,
              notas: notas,
              pagada: (metodoPagoFinal != null && metodoPagoFinal.isNotEmpty),
            );

            // Asignación inmediata si hay bono
            if (hayBonoDisponible && bonoActivo != null) {
              await bonosProv.consumirSesion(bonoActivo.id, citaId,DateTime.now());
            }
          }

          await citasProv.cargarCitasAnio(widget.fecha.year);
          if (context.mounted) Navigator.pop(context, true);
        },
        child: Text(widget.cita == null ? 'Guardar' : 'Guardar cambios'),
      )


      ],
    );
  }
}
