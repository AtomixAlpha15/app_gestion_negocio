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

const double anchoFiltros = 240;
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
    final contab = context.read<ContabilidadProvider>();
    final gastosProvider = context.watch<GastosProvider>();
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    // Citas y gastos del mes (para totales, SIN filtrar)
    final citasMes = context.watch<CitasProvider>().citasPorMes(mesActual, anioActual);
    final gastosMes = gastosProvider.gastosPorMes(mesActual, anioActual);

    // Totales independientes de filtros
    //final totalEfectivo = citasMes.where((c) => c.metodoPago == 'Efectivo').fold<double>(0.0, (a, c) => a + c.precio);
    //final totalBizum = citasMes.where((c) => c.metodoPago == 'Bizum').fold<double>(0.0, (a, c) => a + c.precio);
    //final totalTarjeta = citasMes.where((c) => c.metodoPago == 'Tarjeta').fold<double>(0.0, (a, c) => a + c.precio);
    //final totalFacturado = totalEfectivo + totalBizum + totalTarjeta;
    final totalGastos = gastosMes.fold<double>(0.0, (a, g) => a + g.precio);
    //final beneficio = totalFacturado - totalGastos;

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
                      const SizedBox(width: 12),
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
                FutureBuilder<Map<String, double>>(
                  future: context.read<ContabilidadProvider>()
                      .totalCobradoPorMetodoMes(anioActual, mesActual),
                  builder: (_, snap) {
                    final porMetodo = snap.data ?? {};
                    final efe = porMetodo['efectivo'] ?? 0.0;
                    final biz = porMetodo['bizum'] ?? 0.0;
                    final tar = porMetodo['tarjeta'] ?? 0.0;

                    // Facturado = caja total del mes (citas cobradas + pagos de bonos)
                    final totalFacturado = efe + biz + tar;

                    // Usa tu totalGastos ya calculado más arriba en build()
                    final beneficio = totalFacturado - totalGastos;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Efectivo / Bizum / Tarjeta
                        Card(
                          color: scheme.secondaryContainer,
                          child: ListTile(
                            title: Text('Efectivo', style: text.bodyMedium?.copyWith(color: scheme.onSecondaryContainer)),
                            trailing: Text('${efe.toStringAsFixed(2)} €',
                              style: text.titleMedium?.copyWith(color: scheme.onSecondaryContainer, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Card(
                          color: scheme.secondaryContainer,
                          child: ListTile(
                            title: Text('Bizum', style: text.bodyMedium?.copyWith(color: scheme.onSecondaryContainer)),
                            trailing: Text('${biz.toStringAsFixed(2)} €',
                              style: text.titleMedium?.copyWith(color: scheme.onSecondaryContainer, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Card(
                          color: scheme.secondaryContainer,
                          child: ListTile(
                            title: Text('Tarjeta', style: text.bodyMedium?.copyWith(color: scheme.onSecondaryContainer)),
                            trailing: Text('${tar.toStringAsFixed(2)} €',
                              style: text.titleMedium?.copyWith(color: scheme.onSecondaryContainer, fontWeight: FontWeight.bold)),
                          ),
                        ),

                        Divider(height: 32, color: scheme.outlineVariant),

                        // Facturado
                        Card(
                          color: scheme.primaryContainer,
                          child: ListTile(
                            title: Text('Facturado', style: text.titleMedium?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                            trailing: Text('${totalFacturado.toStringAsFixed(2)} €',
                              style: text.titleMedium?.copyWith(color: scheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                          ),
                        ),

                        // Gastos (mantenemos tu cálculo existente)
                        Card(
                          color: scheme.errorContainer,
                          child: ListTile(
                            title: Text('Gastos', style: text.titleMedium?.copyWith(color: scheme.onErrorContainer, fontWeight: FontWeight.bold)),
                            trailing: Text('${totalGastos.toStringAsFixed(2)} €',
                              style: text.titleMedium?.copyWith(color: scheme.onErrorContainer, fontWeight: FontWeight.bold)),
                          ),
                        ),

                        // Beneficio = Facturado - Gastos
                        Card(
                          color: scheme.tertiaryContainer,
                          child: ListTile(
                            title: Text('Beneficio', style: text.titleMedium?.copyWith(color: scheme.onTertiaryContainer, fontWeight: FontWeight.bold)),
                            trailing: Text('${beneficio.toStringAsFixed(2)} €',
                              style: text.titleMedium?.copyWith(color: scheme.onTertiaryContainer, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    );
                  },
                ),


                const SizedBox(height: 32),
                Text('Año: Vista mensual', style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
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
    return StreamBuilder<List<MovimientoContable>>(
    stream: context
        .read<ContabilidadProvider>()
        .movimientosMesStream(anio, mes),
    builder: (context, snap) {
      print('[UI movs] state=${snap.connectionState} hasData=${snap.hasData} len=${snap.data?.length} hasError=${snap.hasError} err=${snap.error}');

      final clientes  = context.watch<ClientesProvider>().clientes;
      final servicios = context.watch<ServiciosProvider>().servicios;
      final citasMes  = context.watch<CitasProvider>().citasPorMes(mes, anio);
      final scheme    = Theme.of(context).colorScheme;
      final text      = Theme.of(context).textTheme;

      // Usamos los datos que haya; si aún no ha llegado nada, lista vacía (sin spinner)
      final todos = snap.data ?? [];

      // === APLICAR FILTROS (igual que hacías antes, pero sobre 'todos') ===
      final movsFiltrados = todos.where((m) {
        final ml = (m.metodo ?? '').toLowerCase();

        // Métodos de pago
        final hayFiltrosMetodo = metodoPagoSeleccionado.values.any((v) => v);
        bool metodoOk = true;
        if (hayFiltrosMetodo) {
          bool coincide = false;
          if (metodoPagoSeleccionado['Efectivo'] == true && ml == 'efectivo'.toLowerCase()) coincide = true;
          if (metodoPagoSeleccionado['Bizum']    == true && ml == 'bizum'.toLowerCase())    coincide = true;
          if (metodoPagoSeleccionado['Tarjeta']  == true && ml == 'tarjeta'.toLowerCase())  coincide = true;

          // Impagado: solo citas sin método y pasadas
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
        return const Center(child: Text('No hay movimientos en este periodo'));
      }

      return ListView.builder(
        itemCount: movsFiltrados.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // Cabecera
            return Container(
              color: scheme.secondaryContainer,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text('Fecha',    style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer))),
                  Expanded(flex: 3, child: Text('Cliente',  style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer))),
                  Expanded(flex: 3, child: Text('Concepto', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer))),
                  Expanded(flex: 2, child: Text('Importe',  style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer))),
                  Expanded(child: Center(child: Text('Efectivo', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer)))),
                  Expanded(child: Center(child: Text('Bizum',    style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer)))),
                  Expanded(child: Center(child: Text('Tarjeta',  style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: scheme.onSecondaryContainer)))),
                ],
              ),
            );
          }

          final m = movsFiltrados[index - 1];

          final clienteNombre = clientes
                  .firstWhereOrNull((c) => c.id == m.clienteId)
                  ?.nombre
              ?? 'Cliente';

          final servicioNombre = (m.servicioId != null)
              ? servicios.firstWhereOrNull((s) => s.id == m.servicioId)?.nombre
              : null;

          final detalle = (m.tipo == MovimientoTipo.cita)
              ? (servicioNombre ?? 'Cita')
              : (m.detalle.isNotEmpty ? m.detalle : (servicioNombre != null ? 'Pago bono $servicioNombre' : 'Pago bono'));

          // Cita completa para poder actualizar método de pago
          final citaParaEditar = (m.tipo == MovimientoTipo.cita && m.citaId != null)
              ? citasMes.firstWhereOrNull((c) => c.id == m.citaId)
              : null;

          final metodo = m.metodo ?? '';

          // Impagadas (solo citas)
          bool impagada = false;
          if (m.tipo == MovimientoTipo.cita) {
            final now = DateTime.now();
            final hoy = DateTime(now.year, now.month, now.day);
            final esPasada = m.fecha.isBefore(hoy);
            impagada = (metodo.isEmpty) && esPasada;
          }

          final bg = impagada ? scheme.tertiaryContainer : Colors.transparent;
          final fg = impagada ? scheme.onTertiaryContainer : null;
          final cellText = text.bodyMedium?.copyWith(color: fg);

          return Container(
            color: bg,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // Fecha
                Expanded(
                  flex: 2,
                  child: Text(
                    '${m.fecha.day.toString().padLeft(2, '0')}/${m.fecha.month.toString().padLeft(2, '0')}/${m.fecha.year}',
                    style: cellText,
                  ),
                ),
                // Cliente
                Expanded(flex: 3, child: Text(clienteNombre, style: cellText)),
                // Concepto/Servicio
                Expanded(flex: 3, child: Text(detalle, style: cellText)),
                // Importe
                Expanded(
                  flex: 2,
                  child: Text('${m.importe.toStringAsFixed(2)} €', style: cellText),
                ),

                // Efectivo
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
                // Bizum
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
                // Tarjeta
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
        padding: EdgeInsetsGeometry.only(top:10),
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
                gastosProvider.gastosPorMes(mes, anio); // refresca tras añadir
              },
            ),
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
                        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
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
                    return Padding(
                      padding: EdgeInsetsGeometry.only(left: 8), 
                      child:Row(
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
    return AlertDialog(
      title: const Text('Nuevo gasto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _conceptoController,
            decoration: const InputDecoration(labelText: 'Concepto'),
          ),
          const SizedBox(height: 10),
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
