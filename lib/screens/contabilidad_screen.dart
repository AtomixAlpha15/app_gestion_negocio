import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/citas_provider.dart';
import '../services/app_database.dart';

extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

// Puedes ajustar el ancho de los paneles según tus preferencias
const double anchoFiltros = 280;
const double anchoTotales = 220;

class ContabilidadScreen extends StatefulWidget {
  const ContabilidadScreen({super.key});

  @override
  State<ContabilidadScreen> createState() => _ContabilidadScreenState();
}

class _ContabilidadScreenState extends State<ContabilidadScreen> {
  // Filtros
  final Map<String, bool> metodoPagoSeleccionado = {
    'Efectivo': false,
    'Bizum': false,
    'Tarjeta': false,
    'Impagado': false,
  };
  String? clienteId;
  String? servicioId;
  DateTime? fechaSeleccionada;

  int mesActual = DateTime.now().month;
  int anioActual = DateTime.now().year;

  List<Cita> citasFiltradas = [];
  bool cargandoCitas = false;

  @override
  void initState() {
    super.initState();
    context.read<ClientesProvider>().cargarClientes();
    context.read<ServiciosProvider>().cargarServicios();
    cargarCitasMes();
  }
  Future<void> cargarCitasMes() async {
    setState(() => cargandoCitas = true);
    final provider = context.read<CitasProvider>();
    final citas = provider.citasPorMes(mesActual, anioActual); // Añade este método en el provider si no existe
    setState(() {
      citasFiltradas = citas;
      cargandoCitas = false;
    });
  }

  void resetearFiltros() {
    setState(() {
      metodoPagoSeleccionado.updateAll((key, value) => false);
      clienteId = null;
      servicioId = null;
      fechaSeleccionada = null;
    });
  }
  Future<void> actualizarMetodoPagoCita(Cita cita, String? nuevoMetodo) async {
    final provider = context.read<CitasProvider>();
    await provider.actualizarCita(
      id: cita.id,
      clienteId: cita.clienteId,
      servicioId: cita.servicioId,
      inicio: cita.inicio,
      fin: cita.fin,
      precio: cita.precio,
      notas: cita.notas,
      metodoPago: nuevoMetodo,
    );
  }


  @override
  Widget build(BuildContext context) {
    final clientes = context.watch<ClientesProvider>().clientes;
    final servicios = context.watch<ServiciosProvider>().servicios;

    final citasFiltradasVista = citasFiltradas.where((cita) {
      // Método de pago
      final pago = cita.metodoPago ?? '';
      final pagoOk = metodoPagoSeleccionado.entries.any((e) =>
          e.value &&
          ((e.key == 'Impagado' && pago == '') ||
          (e.key != 'Impagado' && pago == e.key)));
      // Si ningún filtro de método de pago está marcado, acepta todos
      final metodoPagoOk = metodoPagoSeleccionado.values.every((v) => !v) || pagoOk;

      // Cliente
      final clienteOk = clienteId == null || cita.clienteId == clienteId;

      // Servicio
      final servicioOk = servicioId == null || cita.servicioId == servicioId;

      // Fecha
      final fechaOk = fechaSeleccionada == null ||
        (cita.inicio.year == fechaSeleccionada!.year &&
        cita.inicio.month == fechaSeleccionada!.month &&
        cita.inicio.day == fechaSeleccionada!.day);

      return metodoPagoOk && clienteOk && servicioOk && fechaOk;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contabilidad'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ----------- Filtros -------------
          Container(
            width: anchoFiltros,
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filtrar por', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  const Text('Método de pago', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...['Efectivo', 'Bizum', 'Tarjeta', 'Impagado'].map((metodo) => CheckboxListTile(
                        value: metodoPagoSeleccionado[metodo],
                        onChanged: (val) {
                          setState(() => metodoPagoSeleccionado[metodo] = val ?? false);
                        },
                        title: Text(metodo),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      )),
                  const SizedBox(height: 16),
                  const Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<String>(
                    value: clienteId,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todos')),
                      ...clientes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre))),
                    ],
                    onChanged: (val) => setState(() => clienteId = val),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Servicio', style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButtonFormField<String>(
                    value: servicioId,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todos')),
                      ...servicios.map((s) => DropdownMenuItem(value: s.id, child: Text(s.nombre))),
                    ],
                    onChanged: (val) => setState(() => servicioId = val),
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(fechaSeleccionada == null
                        ? 'Seleccionar fecha'
                        : '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}'),
                    onPressed: () async {
                      final fecha = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (fecha != null) setState(() => fechaSeleccionada = fecha);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restablecer filtros'),
                    onPressed: resetearFiltros,
                  ),
                ],
              ),
            ),
          ),
          // ----------- Lista de Citas -------------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Selector de mes y año
                  Row(
                    children: [
                      const Text('Mes:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: mesActual,
                        items: List.generate(12, (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('${i + 1}'.padLeft(2, '0')),
                        )),
                        onChanged: (val) {
                          if (val != null) setState(() => mesActual = val);
                            cargarCitasMes();
                        },
                      ),
                      const SizedBox(width: 24),
                      const Text('Año:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: anioActual,
                        items: List.generate(8, (i) => DropdownMenuItem(
                          value: 2020 + i,
                          child: Text('${2020 + i}'),
                        )),
                        onChanged: (val) {
                          if (val != null) setState(() => anioActual = val);
                            cargarCitasMes();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Cabeceras
                  Container(
                    color: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: const [
                        Expanded(flex: 2, child: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 3, child: Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 3, child: Text('Servicio', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text('Precio', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(child: Center(child: Text('Efectivo', style: TextStyle(fontWeight: FontWeight.bold)))),
                        Expanded(child: Center(child: Text('Bizum', style: TextStyle(fontWeight: FontWeight.bold)))),
                        Expanded(child: Center(child: Text('Tarjeta', style: TextStyle(fontWeight: FontWeight.bold)))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Lista de citas
                  Expanded(
                    child: ListView.builder(
                      itemCount: citasFiltradasVista.length,
                      itemBuilder: (context, index) {
                        final cita = citasFiltradasVista[index];
                        final cliente = clientes.firstWhereOrNull((c) => c.id == cita.clienteId);
                        final servicio = servicios.firstWhereOrNull((s) => s.id == cita.servicioId);
                        final esPasada = cita.inicio.isBefore(DateTime.now());
                        final impagada = (cita.metodoPago == null || cita.metodoPago!.isEmpty) && esPasada;

                        return Container(
                          color: impagada ? Colors.red.shade100 : Colors.white,
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text('${cita.inicio.day.toString().padLeft(2, '0')}/${cita.inicio.month.toString().padLeft(2, '0')}/${cita.inicio.year}')),
                              Expanded(flex: 3, child: Text(cliente?.nombre ?? 'Cliente')),
                              Expanded(flex: 3, child: Text(servicio?.nombre ?? 'Servicio')),
                              Expanded(flex: 2, child: Text('${cita.precio.toStringAsFixed(2)} €')),
                              Expanded(
                                child: Center(child: Checkbox(
                                  value: cita.metodoPago == 'Efectivo',
                                  onChanged: (val) async {
                                    await actualizarMetodoPagoCita(cita, val! ? 'Efectivo' : null);
                                    cargarCitasMes();
                                  },
                                )),
                              ),
                              Expanded(
                                child: Center(child: Checkbox(
                                  value: cita.metodoPago == 'Bizum',
                                  onChanged: (val) async {
                                    await actualizarMetodoPagoCita(cita, val! ? 'Bizum' : null);
                                    cargarCitasMes();
                                  },
                                )),
                              ),
                              Expanded(
                                child: Center(child: Checkbox(
                                  value: cita.metodoPago == 'Tarjeta',
                                  onChanged: (val) async {
                                    await actualizarMetodoPagoCita(cita, val! ? 'Tarjeta' : null);
                                    cargarCitasMes();
                                  },
                                )),
                              ),
                            ],
                          ),
                        );
                      }

                    ),
                  ),
                ],
              ),
            ),
          ),
          // ----------- Placeholder Totales -------------
          Container(
            width: anchoTotales,
            color: Colors.grey.shade50,
            child: const Center(
              child: Text('Totales\n(Pendiente)', textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}
