import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/citas_provider.dart';
import '../providers/gastos_provider.dart';
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
  }

  void cambiarAnio(int nuevoAnio) {
    setState(() => anioActual = nuevoAnio);
    context.read<GastosProvider>().gastosPorMes(mesActual, anioActual);
  }

  @override
  Widget build(BuildContext context) {
    final clientes = context.watch<ClientesProvider>().clientes;
    final servicios = context.watch<ServiciosProvider>().servicios;
    final gastosProvider = context.watch<GastosProvider>();
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // Citas y gastos del mes (para totales, SIN filtrar)
    final citasMes = context.watch<CitasProvider>().citasPorMes(mesActual, anioActual);
    final gastosMes = gastosProvider.gastosPorMes(mesActual, anioActual);

    // Totales independientes de filtros
    final totalEfectivo = citasMes.where((c) => c.metodoPago == 'Efectivo').fold<double>(0.0, (a, c) => a + c.precio);
    final totalBizum = citasMes.where((c) => c.metodoPago == 'Bizum').fold<double>(0.0, (a, c) => a + c.precio);
    final totalTarjeta = citasMes.where((c) => c.metodoPago == 'Tarjeta').fold<double>(0.0, (a, c) => a + c.precio);
    final totalFacturado = totalEfectivo + totalBizum + totalTarjeta;
    final totalGastos = gastosMes.fold<double>(0.0, (a, g) => a + g.precio);
    final beneficio = totalFacturado - totalGastos;

    // Preview de año
    final beneficiosPorMes = List.generate(12, (i) {
      final mes = i + 1;
      final citas = context.watch<CitasProvider>().citasPorMes(mes, anioActual);
      final gastos = gastosProvider.gastosPorMes(mes, anioActual);
      final fact = citas.where((c) => (c.metodoPago ?? '').isNotEmpty).fold<double>(0.0, (a, c) => a + c.precio);
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
            color: scheme.surface,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filtrar por', style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  Text('Método de pago', style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
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

                  Text('Cliente', style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
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

                  Text('Servicio', style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
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

                  Text('Fecha', style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      fechaSeleccionada == null
                          ? 'Seleccionar fecha'
                          : '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}',
                    ),
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

                  FilledButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restablecer filtros'),
                    onPressed: resetearFiltros,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Text('Mes:', style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
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
                      Text('Año:', style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
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
              ),
            ),
          ),

          // ----------- Centro: Pestañas -------------
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Ingresos'),
                      Tab(text: 'Gastos'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        IngresosTab(
                          mes: mesActual,
                          anio: anioActual,
                          metodoPagoSeleccionado: metodoPagoSeleccionado,
                          clienteId: clienteId,
                          servicioId: servicioId,
                          fechaSeleccionada: fechaSeleccionada,
                        ),
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
            color: scheme.surface,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Totales', style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface)),
                const SizedBox(height: 16),

                // Efectivo / Bizum / Tarjeta -> secondaryContainer
                Card(
                  color: scheme.secondaryContainer,
                  child: ListTile(
                    title: Text('Efectivo', style: text.bodyMedium?.copyWith(color: scheme.onSecondaryContainer)),
                    trailing: Text('${totalEfectivo.toStringAsFixed(2)} €',
                        style: text.titleMedium?.copyWith(color: scheme.onSecondaryContainer, fontWeight: FontWeight.bold)),
                  ),
                ),
                Card(
                  color: scheme.secondaryContainer,
                  child: ListTile(
                    title: Text('Bizum', style: text.bodyMedium?.copyWith(color: scheme.onSecondaryContainer)),
                    trailing: Text('${totalBizum.toStringAsFixed(2)} €',
                        style: text.titleMedium?.copyWith(color: scheme.onSecondaryContainer, fontWeight: FontWeight.bold)),
                  ),
                ),
                Card(
                  color: scheme.secondaryContainer,
                  child: ListTile(
                    title: Text('Tarjeta', style: text.bodyMedium?.copyWith(color: scheme.onSecondaryContainer)),
                    trailing: Text('${totalTarjeta.toStringAsFixed(2)} €',
                        style: text.titleMedium?.copyWith(color: scheme.onSecondaryContainer, fontWeight: FontWeight.bold)),
                  ),
                ),

                Divider(height: 32, color: scheme.outlineVariant),

                // Facturado -> primaryContainer
                Card(
                  color: scheme.primaryContainer,
                  child: ListTile(
                    title: Text('Facturado', style: text.titleMedium?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                    trailing: Text('${totalFacturado.toStringAsFixed(2)} €',
                        style: text.titleMedium?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                  ),
                ),

                // Gastos -> errorContainer
                Card(
                  color: scheme.errorContainer,
                  child: ListTile(
                    title: Text('Gastos', style: text.titleMedium?.copyWith(color: scheme.onErrorContainer, fontWeight: FontWeight.bold)),
                    trailing: Text('${totalGastos.toStringAsFixed(2)} €',
                        style: text.titleMedium?.copyWith(color: scheme.onErrorContainer, fontWeight: FontWeight.bold)),
                  ),
                ),

                // Beneficio -> terciario
                Card(
                  color: scheme.tertiaryContainer,
                  child: ListTile(
                    title: Text('Beneficio', style: text.titleMedium?.copyWith(color: scheme.onTertiaryContainer, fontWeight: FontWeight.bold)),
                    trailing: Text('${beneficio.toStringAsFixed(2)} €',
                        style: text.titleMedium?.copyWith(color: scheme.onTertiaryContainer, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 32),
                Text('Año: Vista mensual', style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 2.2,
                    children: List.generate(12, (i) {
                      final meses = ['ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'];
                      final selected = (i + 1) == mesActual;

                      final cardColor = selected ? scheme.primaryContainer : scheme.surfaceVariant;
                      final titleColor = selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;

                      return GestureDetector(
                        onTap: () => cambiarMes(i + 1),
                        child: Card(
                          color: cardColor,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(meses[i], style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: titleColor)),
                                const SizedBox(height: 2),
                                Text('${beneficiosPorMes[i].toStringAsFixed(2)} €',
                                    style: text.bodySmall?.copyWith(color: titleColor)),
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
          ),
        ],
      ),
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
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final citasFiltradas = citas.where((cita) {
      final pago = cita.metodoPago ?? '';
      final pagoOk = metodoPagoSeleccionado.entries.any((e) =>
          e.value &&
          ((e.key == 'Impagado' && (pago.isEmpty || pago == '')) ||
           (e.key != 'Impagado' && pago == e.key)));
      final metodoPagoOk = metodoPagoSeleccionado.values.every((v) => !v) || pagoOk;

      final clienteOk = clienteId == null || cita.clienteId == clienteId;
      final servicioOk = servicioId == null || cita.servicioId == servicioId;

      final fechaOk = fechaSeleccionada == null ||
          (cita.inicio.year == fechaSeleccionada!.year &&
           cita.inicio.month == fechaSeleccionada!.month &&
           cita.inicio.day == fechaSeleccionada!.day);

      return metodoPagoOk && clienteOk && servicioOk && fechaOk;
    }).toList();

    if (citasFiltradas.isEmpty) {
      return const Center(child: Text('No hay citas en este periodo'));
    }

    return ListView.builder(
      itemCount: citasFiltradas.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // Cabecera
          return Container(
            color: scheme.secondaryContainer,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Fecha', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer))),
                Expanded(flex: 3, child: Text('Cliente', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer))),
                Expanded(flex: 3, child: Text('Servicio', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer))),
                Expanded(flex: 2, child: Text('Precio', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer))),
                Expanded(child: Center(child: Text('Efectivo', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer)))),
                Expanded(child: Center(child: Text('Bizum', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer)))),
                Expanded(child: Center(child: Text('Tarjeta', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer)))),
              ],
            ),
          );
        }

        final cita = citasFiltradas[index - 1];
        final cliente = clientes.firstWhereOrNull((c) => c.id == cita.clienteId);
        final servicio = servicios.firstWhereOrNull((s) => s.id == cita.servicioId);

        final esPasada = cita.inicio.isBefore(DateTime.now());
        final impagada = (cita.metodoPago == null || cita.metodoPago!.isEmpty) && esPasada;

        final bg = impagada ? scheme.tertiaryContainer : Colors.transparent;
        final fg = impagada ? scheme.onTertiaryContainer : null;

        final cellText = Theme.of(context).textTheme.bodyMedium?.copyWith(color: fg);

        return Container(
          color: bg,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '${cita.inicio.day.toString().padLeft(2, '0')}/${cita.inicio.month.toString().padLeft(2, '0')}/${cita.inicio.year}',
                  style: cellText,
                ),
              ),
              Expanded(flex: 3, child: Text(cliente?.nombre ?? 'Cliente', style: cellText)),
              Expanded(flex: 3, child: Text(servicio?.nombre ?? 'Servicio', style: cellText)),
              Expanded(flex: 2, child: Text('${cita.precio.toStringAsFixed(2)} €', style: cellText)),
              Expanded(
                child: Center(
                  child: Checkbox(
                    value: cita.metodoPago == 'Efectivo',
                    onChanged: (val) async {
                      await actualizarMetodoPagoCita(context, cita, val! ? 'Efectivo' : null);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Checkbox(
                    value: cita.metodoPago == 'Bizum',
                    onChanged: (val) async {
                      await actualizarMetodoPagoCita(context, cita, val! ? 'Bizum' : null);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Checkbox(
                    value: cita.metodoPago == 'Tarjeta',
                    onChanged: (val) async {
                      await actualizarMetodoPagoCita(context, cita, val! ? 'Tarjeta' : null);
                    },
                  ),
                ),
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

  const GastosTab({super.key, required this.mes, required this.anio});

  @override
  Widget build(BuildContext context) {
    final gastosProvider = context.watch<GastosProvider>();
    final gastos = gastosProvider.gastosPorMes(mes, anio);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
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
                      // Cabecera
                      return Container(
                        color: scheme.secondaryContainer,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(flex: 4, child: Text('Concepto', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer))),
                            Expanded(flex: 2, child: Text('Precio', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer))),
                            const Expanded(child: SizedBox()),
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
                            icon: Icon(Icons.delete, color: scheme.error),
                            onPressed: () async {
                              await gastosProvider.eliminarGasto(gasto.id, anio: anio);
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

// Diálogo para nuevo gasto
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
        FilledButton(
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
