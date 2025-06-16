import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/citas_provider.dart';
import '../providers/gastos_provider.dart'; // Supón que tienes este provider
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

const double anchoFiltros = 280;
const double anchoTotales = 260;

class ContabilidadScreen extends StatefulWidget {
  const ContabilidadScreen({super.key});

  @override
  State<ContabilidadScreen> createState() => _ContabilidadScreenState();
}

class _ContabilidadScreenState extends State<ContabilidadScreen>
    with TickerProviderStateMixin {
  int mesActual = DateTime.now().month;
  int anioActual = DateTime.now().year;

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

  // Controlador de pestañas (ingresos/gastos)
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<ClientesProvider>().cargarClientes();
    context.read<ServiciosProvider>().cargarServicios();
    context.read<GastosProvider>().gastosPorMes(mesActual, anioActual);
    _tabController = TabController(length: 2, vsync: this);
  }

  void resetearFiltros() {
    setState(() {
      metodoPagoSeleccionado.updateAll((key, value) => false);
      clienteId = null;
      servicioId = null;
      fechaSeleccionada = null;
    });
  }

  void cambiarMes(int nuevoMes) {
    setState(() => mesActual = nuevoMes);
    context.read<GastosProvider>().gastosPorMes(mesActual, anioActual);
    // Aquí también recargarías citas si lo necesitas
  }

  void cambiarAnio(int nuevoAnio) {
    setState(() => anioActual = nuevoAnio);
    context.read<GastosProvider>().gastosPorMes(mesActual, anioActual);
    // Aquí también recargarías citas si lo necesitas
  }

  @override
  Widget build(BuildContext context) {
    final clientes = context.watch<ClientesProvider>().clientes;
    final servicios = context.watch<ServiciosProvider>().servicios;
    final gastosProvider = context.watch<GastosProvider>();

    // Ejemplo: aquí obtendrías todas las citas del mes para los totales (¡sin filtrar!)
    final citasMes = context.watch<CitasProvider>().citasPorMes(mesActual, anioActual); // Implementa este método
    final gastosMes = gastosProvider.gastosPorMes(mesActual, anioActual); // Lista de gastos del provider

    // Calcula totales del mes (independientes de los filtros)
    final totalEfectivo = citasMes.where((c) => c.metodoPago == 'Efectivo').fold<double>(0.0, (a, c) => a + c.precio);
    final totalBizum = citasMes.where((c) => c.metodoPago == 'Bizum').fold<double>(0.0, (a, c) => a + c.precio);
    final totalTarjeta = citasMes.where((c) => c.metodoPago == 'Tarjeta').fold<double>(0.0, (a, c) => a + c.precio);
    final totalFacturado = totalEfectivo + totalBizum + totalTarjeta;
    final totalGastos = gastosMes.fold<double>(0.0, (a, g) => a + g.precio);
    final beneficio = totalFacturado - totalGastos;

    // Calcula los beneficios de todos los meses del año seleccionado para la grid de preview
    final beneficiosPorMes = List.generate(12, (i) {
      final mes = i + 1;
      final citas = context.watch<CitasProvider>().citasPorMes(mes, anioActual);
      final gastos = gastosProvider.gastosPorMes(mes, anioActual);
      final fact = citas.where((c) => c.metodoPago != null && c.metodoPago!.isNotEmpty).fold<double>(0.0, (a, c) => a + c.precio);
      final g = gastos.fold<double>(0.0, (a, gasto) => a + gasto.precio);
      return fact - g;
    });

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
                  const SizedBox(height: 16),
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
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              )
            )
          ),


            
          // ----------- Centro: Pestañas -------------
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).primaryColor,
                    tabs: const [
                      Tab(text: 'Ingresos'),
                      Tab(text: 'Gastos'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // --- Pestaña INGRESOS ---
                        IngresosTab(
                          mes: mesActual,
                          anio: anioActual,
                          metodoPagoSeleccionado: metodoPagoSeleccionado,
                          clienteId: clienteId,
                          servicioId: servicioId,
                          fechaSeleccionada: fechaSeleccionada,
                        ),
                        // --- Pestaña GASTOS ---
                        GastosTab(
                          mes: mesActual,
                          anio: anioActual,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ----------- Totales + Grid meses -------------
          Container(
            width: anchoTotales,
            color: Colors.grey.shade50,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Totales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: const Text('Efectivo'),
                    trailing: Text('${totalEfectivo.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Bizum'),
                    trailing: Text('${totalBizum.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Tarjeta'),
                    trailing: Text('${totalTarjeta.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const Divider(height: 32),
                Card(
                  color: Colors.lightBlue.shade50,
                  child: ListTile(
                    title: const Text('Facturado', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text('${totalFacturado.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Card(
                  color: Colors.red.shade50,
                  child: ListTile(
                    title: const Text('Gastos', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text('${totalGastos.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Card(
                  color: Colors.green.shade50,
                  child: ListTile(
                    title: const Text('Beneficio', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text('${beneficio.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Año: Vista mensual', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    children: List.generate(12, (i) {
                      final meses = ['ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'];
                      final selected = (i + 1) == mesActual;
                      return GestureDetector(
                        onTap: () {
                          cambiarMes(i + 1);
                        },
                        child: Card(
                          color: selected ? Colors.lightGreen.shade100 : Colors.white,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${meses[i]}', style: TextStyle(fontWeight: FontWeight.bold, color: selected ? Colors.green : Colors.black)),
                                const SizedBox(height: 2),
                                Text('${beneficiosPorMes[i].toStringAsFixed(2)} €', style: TextStyle(fontSize: 13, color: Colors.grey[800])),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          )
        ]
      )
    );
  }
}

// ------ Pestaña INGRESOS -------
class IngresosTab extends StatelessWidget {
  final int mes, anio;
  final Map<String, bool> metodoPagoSeleccionado;
  final String? clienteId, servicioId;
  final DateTime? fechaSeleccionada;

  const IngresosTab({
    super.key,
    required this.mes,
    required this.anio,
    required this.metodoPagoSeleccionado,
    this.clienteId,
    this.servicioId,
    this.fechaSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    final clientes = context.watch<ClientesProvider>().clientes;
    final servicios = context.watch<ServiciosProvider>().servicios;
    final citas = context.watch<CitasProvider>().citasPorMes(mes, anio);

    final citasFiltradas = citas.where((cita) {
      // Método de pago
      final pago = cita.metodoPago ?? '';
      final pagoOk = metodoPagoSeleccionado.entries.any((e) =>
          e.value &&
          ((e.key == 'Impagado' && (pago.isEmpty || pago == '')) ||
           (e.key != 'Impagado' && pago == e.key)));
      final metodoPagoOk = metodoPagoSeleccionado.values.every((v) => !v) || pagoOk;

      // Cliente
      final clienteOk = clienteId == null || cita.clienteId == clienteId;

      // Servicio
      final servicioOk = servicioId == null || cita.servicioId == servicioId;

      // Fecha exacta (día)
      final fechaOk = fechaSeleccionada == null ||
          (cita.inicio.year == fechaSeleccionada!.year &&
           cita.inicio.month == fechaSeleccionada!.month &&
           cita.inicio.day == fechaSeleccionada!.day);

      return metodoPagoOk && clienteOk && servicioOk && fechaOk;
    }).toList();

    return citasFiltradas.isEmpty
        ? const Center(child: Text('No hay citas en este periodo'))
        : ListView.builder(
            itemCount: citasFiltradas.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Cabecera
                return Container(
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
                );
              }

              final cita = citasFiltradas[index - 1];
              final cliente = clientes.firstWhereOrNull((c) => c.id == cita.clienteId);
              final servicio = servicios.firstWhereOrNull((s) => s.id == cita.servicioId);

              final esPasada = cita.inicio.isBefore(DateTime.now());
              final impagada = (cita.metodoPago == null || cita.metodoPago!.isEmpty) && esPasada;

              return Container(
                color: impagada ? Colors.red.shade100 : Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${cita.inicio.day.toString().padLeft(2, '0')}/'
                        '${cita.inicio.month.toString().padLeft(2, '0')}/'
                        '${cita.inicio.year}',
                      ),
                    ),
                    Expanded(flex: 3, child: Text(cliente?.nombre ?? 'Cliente')),
                    Expanded(flex: 3, child: Text(servicio?.nombre ?? 'Servicio')),
                    Expanded(flex: 2, child: Text('${cita.precio.toStringAsFixed(2)} €')),
                    Expanded(
                      child: Center(child: Checkbox(
                        value: cita.metodoPago == 'Efectivo',
                        onChanged: (val) async {
                          await actualizarMetodoPagoCita(context, cita, val! ? 'Efectivo' : null);
                        },
                      )),
                    ),
                    Expanded(
                      child: Center(child: Checkbox(
                        value: cita.metodoPago == 'Bizum',
                        onChanged: (val) async {
                          await actualizarMetodoPagoCita(context, cita, val! ? 'Bizum' : null);
                        },
                      )),
                    ),
                    Expanded(
                      child: Center(child: Checkbox(
                        value: cita.metodoPago == 'Tarjeta',
                        onChanged: (val) async {
                          await actualizarMetodoPagoCita(context, cita, val! ? 'Tarjeta' : null);
                        },
                      )),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Future<void> actualizarMetodoPagoCita(BuildContext context, Cita cita, String? nuevoMetodo) async {
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
}


// ------ Pestaña GASTOS -------
class GastosTab extends StatelessWidget {
  final int mes, anio;

  const GastosTab({
    super.key,
    required this.mes,
    required this.anio,
  });

  @override
  Widget build(BuildContext context) {
    final gastosProvider = context.watch<GastosProvider>();
    final gastos = gastosProvider.gastosPorMes(mes, anio); // Debe filtrar por mes/año

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Añadir gasto'),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) => DialogNuevoGasto(mes: mes, anio: anio),
              );
              gastosProvider.gastosPorMes(mes, anio); // refresca tras añadir
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: gastos.isEmpty
              ? const Center(child: Text('No hay gastos este mes'))
              : ListView.builder(
                  itemCount: gastos.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: const [
                            Expanded(flex: 4, child: Text('Concepto', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(flex: 2, child: Text('Precio', style: TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: SizedBox()),
                          ],
                        ),
                      );
                    }
                    final gasto = gastos[index - 1];
                    return Row(
                      children: [
                        Expanded(flex: 4, child: Text(gasto.concepto)),
                        Expanded(flex: 2, child: Text('${gasto.precio.toStringAsFixed(2)} €')),
                        Expanded(
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await gastosProvider.eliminarGasto(gasto.id);
                              gastosProvider.gastosPorMes(mes, anio);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// Ejemplo de diálogo para nuevo gasto
class DialogNuevoGasto extends StatefulWidget {
  final int mes, anio;
  const DialogNuevoGasto({super.key, required this.mes, required this.anio});

  @override
  State<DialogNuevoGasto> createState() => _DialogNuevoGastoState();
}

class _DialogNuevoGastoState extends State<DialogNuevoGasto> {
  final _conceptoController = TextEditingController();
  final _precioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo gasto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _conceptoController,
            decoration: const InputDecoration(labelText: 'Concepto'),
          ),
          TextField(
            controller: _precioController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Precio (€)'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: () async {
            final concepto = _conceptoController.text.trim();
            final precio = double.tryParse(_precioController.text.trim().replaceAll(',', '.'));
            if (concepto.isEmpty || precio == null || precio <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Introduce un concepto y un precio válido')),
              );
              return;
            }
            final gastosProvider = context.read<GastosProvider>();
            await gastosProvider.insertarGasto(
              concepto: concepto,
              precio: precio,
              mes: widget.mes,
              anio: widget.anio,
            );
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

