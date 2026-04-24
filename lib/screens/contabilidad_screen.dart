import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/citas_provider.dart';
import '../providers/gastos_provider.dart';
import '../services/app_database.dart';
import '../models/movimiento_contable.dart';
import '../providers/contabilidad_provider.dart';

// Helper para Dart < 3
extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

const double anchoFiltros = 260;
const double anchoTotales = 280;

class ContabilidadScreen extends StatefulWidget {
  const ContabilidadScreen({super.key});

  @override
  State<ContabilidadScreen> createState() => _ContabilidadScreenState();
}

class _ContabilidadScreenState extends State<ContabilidadScreen>
    with TickerProviderStateMixin {
  int mesActual = DateTime.now().month;
  int anioActual = DateTime.now().year;

  final Map<String, bool> metodoPagoSeleccionado = {
    'Efectivo': false,
    'Bizum': false,
    'Tarjeta': false,
    'Impagado': false,
  };
  String? clienteId;
  String? servicioId;
  DateTime? fechaSeleccionada;

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

    final gastosMes = gastosProvider.gastosPorMes(mesActual, anioActual);
    final totalGastos = gastosMes.fold<double>(0.0, (a, g) => a + g.precio);

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
        elevation: 0,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFiltrosPanel(context, clientes, servicios, scheme, text),
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
          _buildTotalesPanel(context, scheme, text, totalGastos, beneficiosPorMes),
        ],
      ),
    );
  }

  Widget _buildFiltrosPanel(BuildContext context, List clientes, List servicios, ColorScheme scheme, TextTheme text) {
    return Container(
      width: anchoFiltros,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          right: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filtros', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            _buildFiltroSeccion(
              'Método de pago',
              ['Efectivo', 'Bizum', 'Tarjeta', 'Impagado'],
              text,
            ),
            const SizedBox(height: 20),
            _buildDropdownSeccion('Cliente', clienteId, [null, ...clientes.map((c) => c.id)],
              (c) => c == null ? 'Todos' : clientes.firstWhereOrNull((x) => x.id == c)?.nombre ?? 'Cliente',
              (val) => setState(() => clienteId = val),
              text,
            ),
            const SizedBox(height: 20),
            _buildDropdownSeccion('Servicio', servicioId, [null, ...servicios.map((s) => s.id)],
              (s) => s == null ? 'Todos' : servicios.firstWhereOrNull((x) => x.id == s)?.nombre ?? 'Servicio',
              (val) => setState(() => servicioId = val),
              text,
            ),
            const SizedBox(height: 20),
            _buildFechaSeccion(text),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Limpiar filtros'),
                onPressed: resetearFiltros,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: scheme.outlineVariant),
            const SizedBox(height: 16),
            _buildSelectoresMesAnio(text),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltroSeccion(String titulo, List<String> opciones, TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...opciones.map((metodo) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: CheckboxListTile(
            value: metodoPagoSeleccionado[metodo],
            onChanged: (val) {
              setState(() => metodoPagoSeleccionado[metodo] = val ?? false);
            },
            title: Text(metodo, style: const TextStyle(fontSize: 14)),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        )),
      ],
    );
  }

  Widget _buildDropdownSeccion(String titulo, dynamic valor, List opciones, String Function(dynamic) labelFn, Function(dynamic) onChanged, TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<dynamic>(
          value: valor,
          items: opciones.map((o) => DropdownMenuItem(value: o, child: Text(labelFn(o)))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildFechaSeccion(TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fecha', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.calendar_today, size: 18),
          label: Text(
            fechaSeleccionada == null
                ? 'Seleccionar'
                : '${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year}',
            style: const TextStyle(fontSize: 14),
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
      ],
    );
  }

  Widget _buildSelectoresMesAnio(TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Periodo', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mes', style: text.labelSmall),
                  const SizedBox(height: 4),
                  DropdownButton<int>(
                    value: mesActual,
                    isExpanded: true,
                    items: List.generate(12, (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1}'.padLeft(2, '0')),
                    )),
                    onChanged: (val) {
                      if (val != null) setState(() => mesActual = val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Año', style: text.labelSmall),
                  const SizedBox(height: 4),
                  DropdownButton<int>(
                    value: anioActual,
                    isExpanded: true,
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
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalesPanel(BuildContext context, ColorScheme scheme, TextTheme text, double totalGastos, List<double> beneficiosPorMes) {
    return Container(
      width: anchoTotales,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          left: BorderSide(color: scheme.outlineVariant, width: 1),
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Resumen', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          FutureBuilder<Map<String, double>>(
            future: context.read<ContabilidadProvider>()
                .totalCobradoPorMetodoMes(anioActual, mesActual),
            builder: (_, snap) {
              final porMetodo = snap.data ?? {};
              final efe = porMetodo['efectivo'] ?? 0.0;
              final biz = porMetodo['bizum'] ?? 0.0;
              final tar = porMetodo['tarjeta'] ?? 0.0;
              final totalFacturado = efe + biz + tar;
              final beneficio = totalFacturado - totalGastos;

              return Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTotalCard('Efectivo', efe, scheme.secondaryContainer, scheme.onSecondaryContainer, Icons.money, text),
                      const SizedBox(height: 10),
                      _buildTotalCard('Bizum', biz, scheme.secondaryContainer, scheme.onSecondaryContainer, Icons.phone_android, text),
                      const SizedBox(height: 10),
                      _buildTotalCard('Tarjeta', tar, scheme.secondaryContainer, scheme.onSecondaryContainer, Icons.credit_card, text),
                      const SizedBox(height: 16),
                      Divider(color: scheme.outlineVariant, height: 16),
                      const SizedBox(height: 16),
                      _buildTotalCard('Facturado', totalFacturado, scheme.primaryContainer, scheme.onPrimaryContainer, Icons.trending_up, text),
                      const SizedBox(height: 10),
                      _buildTotalCard('Gastos', totalGastos, scheme.errorContainer, scheme.onErrorContainer, Icons.trending_down, text),
                      const SizedBox(height: 10),
                      _buildTotalCard('Beneficio', beneficio, scheme.tertiaryContainer, scheme.onTertiaryContainer,
                        beneficio >= 0 ? Icons.check_circle : Icons.error, text),
                      const SizedBox(height: 24),
                      _buildVistaAnual(text, scheme, beneficiosPorMes),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCard(String titulo, double valor, Color bgColor, Color fgColor, IconData icon, TextTheme text) {
    return Card(
      color: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: fgColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: text.labelSmall?.copyWith(color: fgColor, fontWeight: FontWeight.w500)),
                  Text('${valor.toStringAsFixed(2)} €',
                    style: text.titleSmall?.copyWith(color: fgColor, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVistaAnual(TextTheme text, ColorScheme scheme, List<double> beneficiosPorMes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumen anual', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.1,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: List.generate(12, (i) {
            final meses = ['ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC'];
            final selected = (i + 1) == mesActual;
            final cardColor = selected ? scheme.primaryContainer : scheme.surfaceVariant;
            final titleColor = selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;

            return GestureDetector(
              onTap: () => cambiarMes(i + 1),
              child: Card(
                color: cardColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(meses[i], style: text.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: titleColor)),
                      const SizedBox(height: 4),
                      Text('${beneficiosPorMes[i].toStringAsFixed(0)}€',
                        style: text.labelSmall?.copyWith(color: titleColor, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
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
    return StreamBuilder<List<MovimientoContable>>(
      stream: context.read<ContabilidadProvider>().movimientosMesStream(anio, mes),
      builder: (context, snap) {
        final clientes  = context.watch<ClientesProvider>().clientes;
        final servicios = context.watch<ServiciosProvider>().servicios;
        final citasMes  = context.watch<CitasProvider>().citasPorMes(mes, anio);
        final scheme    = Theme.of(context).colorScheme;
        final text      = Theme.of(context).textTheme;

        final todos = snap.data ?? [];

        final movsFiltrados = todos.where((m) {
          final ml = (m.metodo ?? '').toLowerCase();
          final hayFiltrosMetodo = metodoPagoSeleccionado.values.any((v) => v);
          bool metodoOk = true;
          if (hayFiltrosMetodo) {
            bool coincide = false;
            if (metodoPagoSeleccionado['Efectivo'] == true && ml == 'efectivo'.toLowerCase()) coincide = true;
            if (metodoPagoSeleccionado['Bizum']    == true && ml == 'bizum'.toLowerCase())    coincide = true;
            if (metodoPagoSeleccionado['Tarjeta']  == true && ml == 'tarjeta'.toLowerCase())  coincide = true;
            if (metodoPagoSeleccionado['Impagado'] == true &&
                m.tipo == MovimientoTipo.cita &&
                (m.metodo == null || m.metodo!.isEmpty)) {
              final now = DateTime.now();
              final hoy = DateTime(now.year, now.month, now.day);
              if (m.fecha.isBefore(hoy)) coincide = true;
            }
            metodoOk = coincide;
          }
          final clienteOk  = (clienteId == null)  || (m.clienteId == clienteId);
          final servicioOk = (servicioId == null) || (m.servicioId == servicioId);
          final fechaOk    = (fechaSeleccionada == null) ||
                            (m.fecha.year  == fechaSeleccionada!.year &&
                              m.fecha.month == fechaSeleccionada!.month &&
                              m.fecha.day   == fechaSeleccionada!.day);
          return metodoOk && clienteOk && servicioOk && fechaOk;
        }).toList();

        if (movsFiltrados.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 48, color: scheme.outline),
                const SizedBox(height: 16),
                Text('No hay movimientos en este periodo', style: text.bodyLarge),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: movsFiltrados.length + 1,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text('Fecha', style: text.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSecondaryContainer))),
                      Expanded(flex: 3, child: Text('Cliente', style: text.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSecondaryContainer))),
                      Expanded(flex: 3, child: Text('Concepto', style: text.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSecondaryContainer))),
                      Expanded(flex: 2, child: Text('Importe', style: text.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSecondaryContainer))),
                      Expanded(child: Center(child: Icon(Icons.money, size: 16, color: scheme.onSecondaryContainer))),
                      Expanded(child: Center(child: Icon(Icons.phone_android, size: 16, color: scheme.onSecondaryContainer))),
                      Expanded(child: Center(child: Icon(Icons.credit_card, size: 16, color: scheme.onSecondaryContainer))),
                    ],
                  ),
                ),
              );
            }

            final m = movsFiltrados[index - 1];
            final clienteNombre = clientes.firstWhereOrNull((c) => c.id == m.clienteId)?.nombre ?? 'Cliente';
            final servicioNombre = (m.servicioId != null)
                ? servicios.firstWhereOrNull((s) => s.id == m.servicioId)?.nombre
                : null;
            final detalle = (m.tipo == MovimientoTipo.cita)
                ? (servicioNombre ?? 'Cita')
                : (m.detalle.isNotEmpty ? m.detalle : (servicioNombre != null ? 'Pago bono $servicioNombre' : 'Pago bono'));
            final citaParaEditar = (m.tipo == MovimientoTipo.cita && m.citaId != null)
                ? citasMes.firstWhereOrNull((c) => c.id == m.citaId)
                : null;
            final metodo = m.metodo ?? '';

            bool impagada = false;
            if (m.tipo == MovimientoTipo.cita) {
              final now = DateTime.now();
              final hoy = DateTime(now.year, now.month, now.day);
              final esPasada = m.fecha.isBefore(hoy);
              impagada = (metodo.isEmpty) && esPasada;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                elevation: 0,
                color: impagada ? scheme.errorContainer.withAlpha(50) : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: impagada ? scheme.error.withAlpha(100) : scheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${m.fecha.day.toString().padLeft(2, '0')}/${m.fecha.month.toString().padLeft(2, '0')}/${m.fecha.year}',
                          style: text.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(flex: 3, child: Text(clienteNombre, style: text.bodySmall)),
                      Expanded(flex: 3, child: Text(detalle, style: text.bodySmall)),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${m.importe.toStringAsFixed(2)} €',
                          style: text.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: m.tipo == MovimientoTipo.cita
                              ? Checkbox(
                                  value: metodo == 'Efectivo',
                                  onChanged: (val) async {
                                    if (citaParaEditar == null) return;
                                    await _actualizarMetodoPagoCita(context, citaParaEditar, val == true ? 'Efectivo' : null);
                                  },
                                )
                              : IgnorePointer(
                                  child: Checkbox(
                                    value: metodo == 'Efectivo',
                                    onChanged: (_) {},
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: m.tipo == MovimientoTipo.cita
                              ? Checkbox(
                                  value: metodo == 'Bizum',
                                  onChanged: (val) async {
                                    if (citaParaEditar == null) return;
                                    await _actualizarMetodoPagoCita(context, citaParaEditar, val == true ? 'Bizum' : null);
                                  },
                                )
                              : IgnorePointer(
                                  child: Checkbox(
                                    value: metodo == 'Bizum',
                                    onChanged: (_) {},
                                  ),
                                ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: m.tipo == MovimientoTipo.cita
                              ? Checkbox(
                                  value: metodo == 'Tarjeta',
                                  onChanged: (val) async {
                                    if (citaParaEditar == null) return;
                                    await _actualizarMetodoPagoCita(context, citaParaEditar, val == true ? 'Tarjeta' : null);
                                  },
                                )
                              : IgnorePointer(
                                  child: Checkbox(
                                    value: metodo == 'Tarjeta',
                                    onChanged: (_) {},
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

Future<void> _actualizarMetodoPagoCita(BuildContext context, Cita cita, String? nuevoMetodo) async {
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
        Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Añadir gasto'),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (_) => DialogNuevoGasto(mes: mes, anio: anio),
                );
                gastosProvider.gastosPorMes(mes, anio);
              },
            ),
          ),
        ),
        Expanded(
          child: gastos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt, size: 48, color: scheme.outline),
                      const SizedBox(height: 16),
                      Text('No hay gastos este mes', style: text.bodyLarge),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: gastos.length + 1,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: scheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          child: Row(
                            children: [
                              Expanded(flex: 4, child: Text('Concepto', style: text.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSecondaryContainer))),
                              Expanded(flex: 2, child: Text('Precio', style: text.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: scheme.onSecondaryContainer))),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                      );
                    }
                    final gasto = gastos[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: scheme.outlineVariant, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Row(
                            children: [
                              Icon(Icons.receipt, size: 18, color: scheme.outline),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(gasto.concepto, style: text.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${gasto.precio.toStringAsFixed(2)} €',
                                  style: text.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(Icons.delete_outline, color: scheme.error, size: 18),
                                    onPressed: () async {
                                      await gastosProvider.eliminarGasto(gasto.id, anio: anio);
                                      gastosProvider.gastosPorMes(mes, anio);
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
    final text = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text('Nuevo gasto', style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _conceptoController,
            decoration: InputDecoration(
              labelText: 'Concepto',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _precioController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Precio (€)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.add),
          onPressed: () async {
            final concepto = _conceptoController.text.trim();
            final precio = double.tryParse(_precioController.text.trim().replaceAll(',', '.'));
            if (concepto.isEmpty || precio == null || precio <= 0) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Introduce un concepto y un precio válido')),
                );
              }
              return;
            }
            final gastosProvider = context.read<GastosProvider>();
            await gastosProvider.insertarGasto(
              concepto: concepto,
              precio: precio,
              mes: widget.mes,
              anio: widget.anio,
            );
            if (mounted && context.mounted) {
              Navigator.pop(context);
            }
          },
          label: const Text('Guardar'),
        ),
      ],
    );
  }
}
