import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/citas_provider.dart';
import '../services/app_database.dart';
import '../widgets/nueva_cita_dialog.dart';

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
              style: const TextStyle(color: Colors.white),
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
              const Text('De:', style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: () async {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: horaInicio,
                  );
                  if (hora != null) cambiarHoraInicio(hora);
                },
                child: Text('${horaInicio.format(context)}', style: const TextStyle(color: Colors.white)),
              ),
              const Text('a', style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: () async {
                  final hora = await showTimePicker(
                    context: context,
                    initialTime: horaFin,
                  );
                  if (hora != null) cambiarHoraFin(hora);
                },
                child: Text('${horaFin.format(context)}', style: const TextStyle(color: Colors.white)),
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
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
      onPressed: () async {
        final result = await showDialog(
          context: context,
          builder: (_) => NuevaCitaDialog(
            fecha: fechaSeleccionada,
            // Puedes pasar horaInicial si el usuario pulsa en una hora concreta del canvas
          ),
        );
        if (result == true) {
          setState(() {}); // o recarga las citas del día
        }
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
    final inicio = horaInicio.hour;
    final fin = horaFin.hour;
    final horas = List.generate(fin - inicio + 1, (i) => inicio + i);

    return ListView(
      children: horas.map((h) {
        final citasEnEstaHora = citas.where((cita) => cita.inicio.hour == h).toList();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 60,
                child: Text('${h.toString().padLeft(2, '0')}:00',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                      ),
                    ),
                    ...citasEnEstaHora.map((cita) => Positioned(
                      left: 0,
                      top: 0,
                      child: Card(
                        color: Colors.blue.shade100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            'Cliente: ${cita.clienteId}\nServicio: ${cita.servicioId}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
