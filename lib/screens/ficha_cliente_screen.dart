import 'dart:io';
import 'package:centerly/services/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/citas_provider.dart';
import '../providers/bonos_provider.dart';
import '../providers/servicios_provider.dart';
import 'package:drift/drift.dart' show OrderingTerm, OrderingMode;
import 'package:image_picker/image_picker.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/bonos_panel.dart';
import '../utils/metodo_pago_utils.dart';
import '../utils/responsive.dart';


class FichaClienteScreen extends StatefulWidget {
  final dynamic cliente; // ClienteData o null (crear)
  const FichaClienteScreen({super.key, this.cliente});

  @override
  State<FichaClienteScreen> createState() => _FichaClienteScreenState();
}
class _ClientePanelData {
  final double totalGastado;
  final double totalImpagos;
  final List<Cita> impagos;
  final List<Cita> ultimas10;

  _ClientePanelData({
    required this.totalGastado,
    required this.totalImpagos,
    required this.impagos,
    required this.ultimas10,
  });
}
class _FichaClienteScreenState extends State<FichaClienteScreen> {
  late TextEditingController nombreCtrl;
  late TextEditingController telefonoCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController notasCtrl;
  String? imagenPath;

  bool get esNuevo => widget.cliente == null;

  @override
  void initState() {
    super.initState();
    final c = widget.cliente;
    nombreCtrl   = TextEditingController(text: c?.nombre ?? '');
    telefonoCtrl = TextEditingController(text: c?.telefono ?? '');
    emailCtrl    = TextEditingController(text: c?.email ?? '');
    notasCtrl    = TextEditingController(text: c?.notas ?? '');
    imagenPath   = c?.imagenPath;
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    telefonoCtrl.dispose();
    emailCtrl.dispose();
    notasCtrl.dispose();
    super.dispose();
  }
  
  Future<_ClientePanelData> _cargarPanelCliente(String clienteId) async {
    final citasProv = context.read<CitasProvider>();
    final db = citasProv.db;
    final inicioHoy = DateTime.now();
    final hoy = DateTime(inicioHoy.year, inicioHoy.month, inicioHoy.day);

    // Traemos TODAS las citas del cliente (simple y suficiente para empezar)
    final citas = await (db.select(db.citas)
          ..where((c) => c.clienteId.equals(clienteId))
          ..orderBy([(c) => OrderingTerm(expression: c.inicio, mode: OrderingMode.desc)]))
        .get();

    // Total gastado: citas pagadas (pagada==true) o con método de pago asignado
    final totalGastado = citas
        .where((c) => c.pagada == true || ((c.metodoPago ?? '').isNotEmpty))
        .fold<double>(0.0, (a, c) => a + c.precio);

    // Impagos: citas pasadas SIN método de pago (y no marcadas pagadas)
    final impagos = citas.where((c) {
      final sinPago = (c.metodoPago == null || c.metodoPago!.isEmpty) && (c.pagada != true);
      return sinPago && c.inicio.isBefore(hoy);
    }).toList();

    final totalImpagos = impagos.fold<double>(0.0, (a, c) => a + c.precio);

  // Historial: últimas 10 citas PASADAS
  final ultimas10 = citas
      .where((c) => c.inicio.isBefore(hoy)) // solo pasadas (mismo criterio que impagos)
      .take(10)
      .toList();

    return _ClientePanelData(
      totalGastado: totalGastado,
      totalImpagos: totalImpagos,
      impagos: impagos,
      ultimas10: ultimas10,
    );
  }

  Future<void> _guardar() async {
    final nombre = nombreCtrl.text.trim();
    final localized = AppLocalizations.of(context);
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localized.validationRequired, style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer)),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer),
      );
      return;
    }

    final provider = context.read<ClientesProvider>();
    if (esNuevo) {
      await provider.insertarCliente(
        nombre: nombre,
        telefono: telefonoCtrl.text.trim().isEmpty ? null : telefonoCtrl.text.trim(),
        email:    emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
        notas:    notasCtrl.text.trim().isEmpty ? null : notasCtrl.text.trim(),
        imagenSeleccionada: imagenPath,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localized.clientsCreated, style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer)),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
        );
        Navigator.pop(context, true);
      }
    } else {
      await provider.actualizarCliente(
        id: widget.cliente.id,
        nombre: nombre,
        telefono: telefonoCtrl.text.trim().isEmpty ? null : telefonoCtrl.text.trim(),
        email:    emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
        notas:    notasCtrl.text.trim().isEmpty ? null : notasCtrl.text.trim(),
        nuevaImagenSeleccionada: imagenPath,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localized.clientsUpdated, style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer)),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
        );
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _eliminar() async {
    final localized = AppLocalizations.of(context);
    final provider = context.read<ClientesProvider>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(localized.clientsDelete),
        content: Text(localized.clientsConfirmDelete),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(localized.actionCancel)),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localized.actionDelete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await provider.eliminarCliente(widget.cliente.id, imagenPath: widget.cliente.imagenPath);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localized.clientsDeleted, style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
            backgroundColor: Theme.of(context).colorScheme.errorContainer),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final localized = AppLocalizations.of(context);
    final mobile = isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? localized.clientsNew : localized.clientsCardTitle),
        actions: mobile
            ? [
                if (!esNuevo)
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: scheme.error),
                    tooltip: localized.actionDelete,
                    onPressed: _eliminar,
                  ),
                IconButton(
                  icon: const Icon(Icons.save_outlined),
                  tooltip: localized.actionSave,
                  onPressed: _guardar,
                ),
                const SizedBox(width: 4),
              ]
            : null,
      ),
      body: mobile ? _buildMobileBody(context) : _buildDesktopBody(context),
    );
  }

  Widget _buildDesktopBody(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final localized = AppLocalizations.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1320),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda: avatar + acciones
              SizedBox(
                width: 280,
                child: Card(
                  color: scheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundImage: (imagenPath != null && imagenPath!.isNotEmpty)
                              ? Image.file(File(imagenPath!)).image
                              : null,
                          child: (imagenPath == null || imagenPath!.isEmpty)
                              ? Icon(Icons.person, size: 64, color: scheme.onSecondaryContainer.withValues(alpha:0.6))
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final picked = await picker.pickImage(source: ImageSource.gallery);
                                if (picked != null) setState(() => imagenPath = picked.path);
                              },
                              icon: const Icon(Icons.image),
                              label: Text(localized.clientsChangeImage),
                            ),
                            if (imagenPath != null && imagenPath!.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                tooltip: localized.clientsRemoveImage,
                                onPressed: () => setState(() => imagenPath = null),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (!esNuevo)
                          FutureBuilder<_ClientePanelData>(
                            future: _cargarPanelCliente(widget.cliente.id),
                            builder: (context, snap) {
                              if (!snap.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: CircularProgressIndicator(color: scheme.primary)),
                                );
                              }
                              final data = snap.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(localized.clientsSummary,
                                      style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: [
                                      _totalChip(context,
                                        label: localized.clientsTotalSpent,
                                        value: context.read<SettingsProvider>().formatCurrency(data.totalGastado),
                                        bg: scheme.secondaryContainer,
                                        fg: scheme.onSecondaryContainer,
                                      ),
                                      _totalChip(context,
                                        label: localized.dashUnpaidTotal,
                                        value: context.read<SettingsProvider>().formatCurrency(data.totalImpagos),
                                        bg: data.totalImpagos > 0 ? scheme.tertiaryContainer : scheme.surfaceContainerHighest,
                                        fg: data.totalImpagos > 0 ? scheme.onTertiaryContainer : scheme.onSurfaceVariant,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        const Spacer(),
                        if (!esNuevo)
                          FilledButton.tonalIcon(
                            icon: const Icon(Icons.delete),
                            style: FilledButton.styleFrom(
                              backgroundColor: scheme.errorContainer,
                              foregroundColor: scheme.onErrorContainer,
                            ),
                            onPressed: _eliminar,
                            label: Text(localized.actionDelete),
                          ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          icon: const Icon(Icons.save),
                          onPressed: _guardar,
                          label: Text(localized.actionSave),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Columna central: datos
              Expanded(
                flex: 3,
                child: Card(
                  color: scheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(localized.clientsCardData, style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: nombreCtrl,
                                  decoration: InputDecoration(labelText: localized.labelName),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: telefonoCtrl,
                                  decoration: InputDecoration(labelText: localized.labelPhone),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: emailCtrl,
                            decoration: InputDecoration(labelText: localized.labelEmail),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: notasCtrl,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: localized.labelNotes,
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (!esNuevo)
                            FutureBuilder<_ClientePanelData>(
                              future: _cargarPanelCliente(widget.cliente.id),
                              builder: (context, snap) {
                                if (!snap.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Center(child: CircularProgressIndicator(color: scheme.primary)),
                                  );
                                }
                                final data = snap.data!;
                                if (data.impagos.isEmpty) return const SizedBox();

                                final servicios = context.read<ServiciosProvider>().servicios;
                                final serviciosMap = {for (var s in servicios) s.id: s.nombre};

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(localized.clientsUnpaidAppointments,
                                        style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Card(
                                      color: scheme.tertiaryContainer,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: SizedBox(
                                          height: 220,
                                          child: ListView.separated(
                                            itemCount: data.impagos.length,
                                            separatorBuilder: (_, __) => Divider(height: 10, color: scheme.outlineVariant),
                                            itemBuilder: (_, i) {
                                              final c = data.impagos[i];
                                              final servicioNombre = serviciosMap[c.servicioId] ?? 'Servicio';
                                              final s = context.read<SettingsProvider>();
                                              return ListTile(
                                                dense: true,
                                                contentPadding: EdgeInsets.zero,
                                                title: Text('$servicioNombre · ${s.formatCurrency(c.precio)}',
                                                    style: text.bodyMedium?.copyWith(color: scheme.onTertiaryContainer)),
                                                subtitle: Text(s.formatDateTime(c.inicio),
                                                    style: text.bodySmall?.copyWith(
                                                        color: scheme.onTertiaryContainer.withValues(alpha:0.9))),
                                                trailing: FilledButton.tonal(
                                                  onPressed: () async {
                                                    await context.read<CitasProvider>().actualizarCita(
                                                      id: c.id,
                                                      clienteId: c.clienteId,
                                                      servicioId: c.servicioId,
                                                      inicio: c.inicio,
                                                      fin: c.fin,
                                                      precio: c.precio,
                                                      notas: c.notas,
                                                      metodoPago: MetodoPagoUtils.efectivoValue,
                                                    );
                                                    if (context.mounted) setState(() {});
                                                  },
                                                  child: Text(localized.agendaMarkPaid),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          if (!esNuevo) ...[
                            const SizedBox(height: 20),
                            BonosPanel(clienteId: widget.cliente.id),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Columna derecha: historial
              Expanded(
                flex: 2,
                child: Card(
                  color: scheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${localized.clientsHistory} (últimas 10)',
                            style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (esNuevo)
                          Text(localized.clientsNoHistoryYet)
                        else
                          Expanded(
                            child: FutureBuilder<_ClientePanelData>(
                              future: _cargarPanelCliente(widget.cliente.id),
                              builder: (context, snap) {
                                if (!snap.hasData) {
                                  return Center(child: CircularProgressIndicator(color: scheme.primary));
                                }
                                final data = snap.data!;
                                if (data.ultimas10.isEmpty) {
                                  return Center(child: Text(localized.clientsNoAppointmentsRecorded));
                                }
                                final servicios = context.read<ServiciosProvider>().servicios;
                                final serviciosMap = {for (var s in servicios) s.id: s.nombre};
                                return ListView.separated(
                                  itemCount: data.ultimas10.length,
                                  separatorBuilder: (_, __) => Divider(height: 8, color: scheme.outlineVariant),
                                  itemBuilder: (_, i) {
                                    final c = data.ultimas10[i];
                                    final servicioNombre = serviciosMap[c.servicioId] ?? 'Servicio';
                                    final s = context.read<SettingsProvider>();
                                    final pagado = (c.pagada == true) || ((c.metodoPago ?? '').isNotEmpty);
                                    return ListTile(
                                      dense: true,
                                      title: Text(servicioNombre),
                                      subtitle: Text(s.formatDateTime(c.inicio)),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(s.formatCurrency(c.precio),
                                              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 2),
                                          Text(
                                            pagado ? (c.metodoPago ?? localized.agendaPaid) : localized.agendaUnpaid,
                                            style: text.bodySmall?.copyWith(
                                              color: pagado ? scheme.primary : scheme.tertiary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileBody(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final localized = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Avatar ---
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundImage: (imagenPath != null && imagenPath!.isNotEmpty)
                  ? Image.file(File(imagenPath!)).image
                  : null,
              child: (imagenPath == null || imagenPath!.isEmpty)
                  ? Icon(Icons.person, size: 48, color: scheme.onSurfaceVariant.withValues(alpha:0.6))
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) setState(() => imagenPath = picked.path);
                },
                icon: const Icon(Icons.image),
                label: Text(localized.clientsChangeImage),
              ),
              if (imagenPath != null && imagenPath!.isNotEmpty) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: localized.clientsRemoveImage,
                  onPressed: () => setState(() => imagenPath = null),
                  icon: const Icon(Icons.close),
                ),
              ],
            ],
          ),

          // --- Chips de resumen ---
          if (!esNuevo) ...[
            const SizedBox(height: 20),
            FutureBuilder<_ClientePanelData>(
              future: _cargarPanelCliente(widget.cliente.id),
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox(height: 8);
                final data = snap.data!;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _totalChip(context,
                      label: localized.clientsTotalSpent,
                      value: context.read<SettingsProvider>().formatCurrency(data.totalGastado),
                      bg: scheme.secondaryContainer,
                      fg: scheme.onSecondaryContainer,
                    ),
                    _totalChip(context,
                      label: localized.dashUnpaidTotal,
                      value: context.read<SettingsProvider>().formatCurrency(data.totalImpagos),
                      bg: data.totalImpagos > 0 ? scheme.tertiaryContainer : scheme.surfaceContainerHighest,
                      fg: data.totalImpagos > 0 ? scheme.onTertiaryContainer : scheme.onSurfaceVariant,
                    ),
                  ],
                );
              },
            ),
          ],

          // --- Campos del formulario ---
          const SizedBox(height: 24),
          Text(localized.clientsCardData,
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: nombreCtrl,
            decoration: InputDecoration(labelText: localized.labelName),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: telefonoCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: localized.labelPhone),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: localized.labelEmail),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: notasCtrl,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: localized.labelNotes,
              alignLabelWithHint: true,
            ),
          ),

          // --- Impagos ---
          if (!esNuevo)
            FutureBuilder<_ClientePanelData>(
              future: _cargarPanelCliente(widget.cliente.id),
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox();
                final data = snap.data!;
                if (data.impagos.isEmpty) return const SizedBox();

                final servicios = context.read<ServiciosProvider>().servicios;
                final serviciosMap = {for (var s in servicios) s.id: s.nombre};

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text(localized.clientsUnpaidAppointments,
                        style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Card(
                      color: scheme.tertiaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.impagos.length,
                          separatorBuilder: (_, __) => Divider(height: 10, color: scheme.outlineVariant),
                          itemBuilder: (_, i) {
                            final c = data.impagos[i];
                            final servicioNombre = serviciosMap[c.servicioId] ?? 'Servicio';
                            final s = context.read<SettingsProvider>();
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              title: Text('$servicioNombre · ${s.formatCurrency(c.precio)}',
                                  style: text.bodyMedium?.copyWith(color: scheme.onTertiaryContainer)),
                              subtitle: Text(s.formatDateTime(c.inicio),
                                  style: text.bodySmall?.copyWith(
                                      color: scheme.onTertiaryContainer.withValues(alpha:0.9))),
                              trailing: FilledButton.tonal(
                                onPressed: () async {
                                  await context.read<CitasProvider>().actualizarCita(
                                    id: c.id,
                                    clienteId: c.clienteId,
                                    servicioId: c.servicioId,
                                    inicio: c.inicio,
                                    fin: c.fin,
                                    precio: c.precio,
                                    notas: c.notas,
                                    metodoPago: MetodoPagoUtils.efectivoValue,
                                  );
                                  if (context.mounted) setState(() {});
                                },
                                child: Text(localized.agendaMarkPaid),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

          // --- Bonos ---
          if (!esNuevo) ...[
            const SizedBox(height: 20),
            BonosPanel(clienteId: widget.cliente.id),
          ],

          // --- Historial ---
          if (!esNuevo)
            FutureBuilder<_ClientePanelData>(
              future: _cargarPanelCliente(widget.cliente.id),
              builder: (context, snap) {
                if (!snap.hasData) return const SizedBox();
                final data = snap.data!;
                final servicios = context.read<ServiciosProvider>().servicios;
                final serviciosMap = {for (var s in servicios) s.id: s.nombre};

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text('${localized.clientsHistory} (últimas 10)',
                        style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (data.ultimas10.isEmpty)
                      Text(localized.clientsNoAppointmentsRecorded,
                          style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant))
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.ultimas10.length,
                        separatorBuilder: (_, __) => Divider(height: 8, color: scheme.outlineVariant),
                        itemBuilder: (_, i) {
                          final c = data.ultimas10[i];
                          final servicioNombre = serviciosMap[c.servicioId] ?? 'Servicio';
                          final s = context.read<SettingsProvider>();
                          final pagado = (c.pagada == true) || ((c.metodoPago ?? '').isNotEmpty);
                          return ListTile(
                            dense: true,
                            title: Text(servicioNombre),
                            subtitle: Text(s.formatDateTime(c.inicio)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(s.formatCurrency(c.precio),
                                    style: text.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(
                                  pagado ? (c.metodoPago ?? localized.agendaPaid) : localized.agendaUnpaid,
                                  style: text.bodySmall?.copyWith(
                                    color: pagado ? scheme.primary : scheme.tertiary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),

          // --- Botón guardar ---
          const SizedBox(height: 28),
          FilledButton.icon(
            icon: const Icon(Icons.save),
            onPressed: _guardar,
            label: Text(localized.actionSave),
          ),
        ],
      ),
    );
  }
}

Widget _totalChip(BuildContext context,
    {required String label, required String value, required Color bg, required Color fg}) {
  final text = Theme.of(context).textTheme;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: text.labelLarge?.copyWith(color: fg)),
        const SizedBox(height: 4),
        Text(value, style: text.titleMedium?.copyWith(color: fg, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

class _DialogCrearBono extends StatefulWidget {
  final String clienteId;
  const _DialogCrearBono({required this.clienteId});

  @override
  State<_DialogCrearBono> createState() => _DialogCrearBonoState();
}

class _DialogCrearBonoState extends State<_DialogCrearBono> {
  String? servicioId;
  int sesiones = 10;
  final nombreCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  DateTime? caducaEl;

  @override
  Widget build(BuildContext context) {
    final servicios = context.read<ServiciosProvider>().servicios;
    final localized = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(localized.bonosCreateTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: servicioId,
              items: servicios.map((s) =>
                DropdownMenuItem(value: s.id, child: Text(s.nombre))).toList(),
              onChanged: (v) => setState(() => servicioId = v),
              decoration: InputDecoration(labelText: localized.bonosServiceLabel),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nombreCtrl,
              decoration: InputDecoration(labelText: localized.bonosNameOptional),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(localized.bonosSessionsLabel),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: sesiones,
                  items: List.generate(30, (i) => i + 1)
                      .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                      .toList(),
                  onChanged: (v) => setState(() => sesiones = v ?? 10),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: localized.bonosPriceLabel),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text(caducaEl == null ? localized.bonosNoDueDate :
                  '${localized.bonosDueDate} ${context.read<SettingsProvider>().formatDate(caducaEl!)}')),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 180)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) setState(() => caducaEl = picked);
                  },
                  child: Text(localized.bonosChooseDate),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(localized.actionCancel)),
        FilledButton(
          onPressed: () async {
            if (servicioId == null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(localized.bonosSelectService)));
              return;
            }
            final precio = double.tryParse(precioCtrl.text.replaceAll(',', '.'));
            await context.read<BonosProvider>().crearBonoSesiones(
              clienteId: widget.clienteId,
              servicioId: servicioId!,
              sesiones: sesiones,
              nombre: nombreCtrl.text.trim().isEmpty ? null : nombreCtrl.text.trim(),
              precioBono: precio,
              caducaEl: caducaEl,
            );
            if (context.mounted) Navigator.pop(context, true);
          },
          child: Text(localized.bonosCreateButton),
        ),
      ],
    );
  }
}
