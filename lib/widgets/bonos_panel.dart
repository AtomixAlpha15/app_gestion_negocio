import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bonos_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/settings_provider.dart';
import '../services/app_database.dart'; // Tipos Bono/BonoConsumo (generados por Drift)

// PANEL DE BONOS
class BonosPanel extends StatefulWidget {
  final String clienteId;
  const BonosPanel({super.key, required this.clienteId});

  @override
  State<BonosPanel> createState() => _BonosPanelState();
}

class _BonosPanelState extends State<BonosPanel> {
  String? _bonoSeleccionadoId; // id del bono seleccionado en la lista

  @override
  Widget build(BuildContext context) {
    final text      = Theme.of(context).textTheme;
    final scheme    = Theme.of(context).colorScheme;
    final clienteId = widget.clienteId;

    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Cabecera + botón crear ----
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Bonos',
                    style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.card_membership),
                  label: const Text('Crear bono'),
                  onPressed: () async {
                    final creado = await showDialog<bool>(
                      context: context,
                      builder: (_) => _CrearBonoDialog(clienteId: clienteId),
                    );
                    if (creado == true && mounted) {
                      setState(() {
                        _bonoSeleccionadoId = null; // resetea selección
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Bono creado'),
                          backgroundColor: scheme.secondaryContainer,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ---- Faceplate + lista de bonos (activos + histórico) ----
            FutureBuilder<List<Bono>>(
              future: context.read<BonosProvider>().bonosCliente(clienteId),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const _Loader();
                }

                final todos = snap.data ?? [];
                if (todos.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No hay bonos activos.',
                        style: text.bodyMedium?.copyWith(
                          color: scheme.onSurface.withValues(alpha:0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sin bonos registrados.',
                        style: text.bodyMedium,
                      ),
                    ],
                  );
                }

                // Separamos activos e inactivos
                final activos   = todos.where((b) => b.activo).toList();
                final inactivos = todos.where((b) => !b.activo).toList();

                // Ordenamos por fecha de creación (más recientes primero)
                activos.sort((a, b) => b.creadoEl.compareTo(a.creadoEl));
                inactivos.sort((a, b) => b.creadoEl.compareTo(a.creadoEl));

                final ultimosInactivos = inactivos.take(3).toList();

                // Bono seleccionado (si el id sigue existiendo)
                Bono? seleccionado;
                if (_bonoSeleccionadoId != null) {
                  try {
                    seleccionado = todos.firstWhere((b) => b.id == _bonoSeleccionadoId);
                  } catch (_) {
                    seleccionado = null;
                  }
                }

                final hayActivos         = activos.isNotEmpty;
                final haySeleccionManual = seleccionado != null;

                // ¿Qué mostramos en el faceplate?
                Bono? bonoFaceplate;
                if (haySeleccionManual) {
                  bonoFaceplate = seleccionado;
                } else if (hayActivos) {
                  bonoFaceplate = activos.first;
                }

                final children = <Widget>[];

                // ---- Sección faceplate / mensaje sin bonos activos ----
                if (!hayActivos && !haySeleccionManual) {
                  children.add(
                    Text(
                      'No hay bonos activos.',
                      style: text.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha:0.8),
                      ),
                    ),
                  );
                } else if (bonoFaceplate != null) {
                  children.add(
                    _BonoFaceplate(
                      bono: bonoFaceplate,
                      onChanged: () {
                        setState(() {
                          _bonoSeleccionadoId = null;
                        });
                      },
                    ),
                  );
                }

                children.add(const SizedBox(height: 16));
                children.add(Divider(color: scheme.outlineVariant, height: 24));

                // ---- Lista de bonos activos ----
                if (activos.isNotEmpty) {
                  children.add(
                    Text(
                      'Bonos activos',
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: scheme.onSurface,
                      ),
                    ),
                  );
                  children.add(const SizedBox(height: 8));

                  children.add(
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activos.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: scheme.outlineVariant,
                      ),
                      itemBuilder: (_, i) {
                        final bono = activos[i];
                        final seleccionado = bono.id == _bonoSeleccionadoId;
                        return _BonoListTile(
                          bono: bono,
                          seleccionado: seleccionado,
                          onTap: () {
                            setState(() {
                              _bonoSeleccionadoId = bono.id;
                            });
                          },
                        );
                      },
                    ),
                  );
                }

                // ---- Historial: últimos 3 inactivos ----
                if (ultimosInactivos.isNotEmpty) {
                  if (activos.isNotEmpty) {
                    children.add(const SizedBox(height: 16));
                  }
                  children.add(
                    Text(
                      'Histórico (últimos 3)',
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: scheme.onSurface,
                      ),
                    ),
                  );
                  children.add(const SizedBox(height: 8));

                  children.add(
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ultimosInactivos.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: scheme.outlineVariant,
                      ),
                      itemBuilder: (_, i) {
                        final bono = ultimosInactivos[i];
                        final seleccionado = bono.id == _bonoSeleccionadoId;
                        return _BonoListTile(
                          bono: bono,
                          seleccionado: seleccionado,
                          onTap: () {
                            setState(() {
                              _bonoSeleccionadoId = bono.id;
                            });
                          },
                        );
                      },
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// Faceplate grande del bono (progreso visual + acciones)
class _BonoFaceplate extends StatelessWidget {
  final Bono bono;
  final VoidCallback? onChanged; // notifica cambios al panel
  const _BonoFaceplate({required this.bono, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text   = Theme.of(context).textTheme;

    final totales  = bono.sesionesTotales;

    final nombreServicio = context.select<ServiciosProvider, String?>(
      (sp) => sp.nombreServicioPorId(bono.servicioId),
    );

    return FutureBuilder<int>(
      future: context.read<BonosProvider>().sesionesAsignadasBono(bono.id),
      builder: (context, snap) {
        final usadas = snap.data ?? bono.sesionesUsadas;
        final restante = (totales - usadas).clamp(0, totales);
        final progreso = totales > 0 ? usadas / totales : 0.0;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.secondaryContainer,
                scheme.secondaryContainer.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outlineVariant, width: 1),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado con nombre y botón eliminar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bono.nombre,
                            style: text.headlineSmall?.copyWith(
                              color: scheme.onSecondaryContainer,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            nombreServicio ?? 'Servicio',
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: scheme.onSecondaryContainer.withValues(alpha:0.85),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Eliminar bono',
                      icon: const Icon(Icons.delete_outline),
                      color: Theme.of(context).colorScheme.error,
                      onPressed: () async {
                        final ctx = context;
                        final ok = await showDialog<bool>(
                          context: ctx,
                          builder: (_) => AlertDialog(
                            title: const Text('Eliminar bono'),
                            content: const Text('Esta acción no se puede deshacer.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancelar'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
                        );
                        if (ok == true && ctx.mounted) {
                          await ctx.read<BonosProvider>().eliminarBono(bono.id);
                          ScaffoldMessenger.of(ctx)
                              .showSnackBar(const SnackBar(content: Text('Bono eliminado')));
                          onChanged?.call();
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Indicador de progreso circular
                Center(
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progreso,
                          strokeWidth: 8,
                          backgroundColor: scheme.surface.withValues(alpha:0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            restante > 0 ? scheme.primary : scheme.tertiary,
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$usadas',
                              style: text.displaySmall?.copyWith(
                                color: scheme.onSecondaryContainer,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'de $totales',
                              style: text.bodySmall?.copyWith(
                                color: scheme.onSecondaryContainer.withValues(alpha:0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Info de sesiones restantes
                if (restante > 0 && bono.activo)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha:0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: scheme.primary.withValues(alpha:0.3)),
                    ),
                    child: Text(
                      '✓ Quedan $restante sesión${restante != 1 ? 'es' : ''} disponible${restante != 1 ? 's' : ''}',
                      style: text.bodyMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Fecha de caducidad
                if (bono.caducaEl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: scheme.tertiary.withValues(alpha:0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: scheme.tertiary.withValues(alpha:0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.event, size: 16, color: scheme.tertiary),
                          const SizedBox(width: 8),
                          Text(
                            'Caduca: ${_fmtDate(bono.caducaEl!, context)}',
                            style: text.bodyMedium?.copyWith(
                              color: scheme.tertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Botón para añadir pago (destacado)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () async {
                      final ctx = context;
                      final ok = await showDialog<bool>(
                        context: ctx,
                        builder: (_) => _AnadirPagoDialog(bonoId: bono.id),
                      );
                      if (ok == true && ctx.mounted) {
                        // ignore: use_build_context_synchronously
                        (ctx.findAncestorStateOfType<_BonosPanelState>())?.setState(() {});
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Pago registrado')),
                        );
                      }
                    },
                    label: const Text('Añadir pago'),
                  ),
                ),

                const SizedBox(height: 16),
                Divider(color: scheme.outlineVariant.withValues(alpha:0.5), height: 1),
                const SizedBox(height: 16),

                // === Sección Pagos ===
                FutureBuilder<List<BonoPago>>(
                  future: context.read<BonosProvider>().pagosDeBono(bono.id),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const _Loader();
                    }
                    final pagos = snap.data ?? [];
                    if (pagos.isEmpty) {
                      return Text(
                        'Sin pagos registrados.',
                        style: text.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer.withValues(alpha:0.7),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pagos registrados',
                          style: text.titleSmall?.copyWith(
                            color: scheme.onSecondaryContainer,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...pagos.map((p) {
                          final bgColor = pagos.indexOf(p) % 2 == 0
                              ? scheme.surface.withValues(alpha:0.2)
                              : Colors.transparent;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.payments, size: 16, color: scheme.primary.withValues(alpha:0.7)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${_fmtDate(p.fecha, context)} · ${p.metodo ?? '—'}',
                                    style: text.bodyMedium?.copyWith(
                                      color: scheme.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                                Text(
                                  context.read<SettingsProvider>().formatCurrency(p.importe),
                                  style: text.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: scheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),
                Divider(color: scheme.outlineVariant.withValues(alpha:0.5), height: 1),
                const SizedBox(height: 16),

                // === Totales ===
                FutureBuilder<double>(
                  future: context.read<BonosProvider>().totalCobradoBono(bono.id),
                  builder: (context, cobroSnap) {
                    final cobrado = cobroSnap.data ?? 0.0;
                    return FutureBuilder<double>(
                      future: context.read<BonosProvider>().ingresoReconocidoBono(bono.id),
                      builder: (context, ingSnap) {
                        final reconocido = ingSnap.data ?? 0.0;
                        final diferido = (cobrado - reconocido);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Resumen económico',
                              style: text.titleSmall?.copyWith(
                                color: scheme.onSecondaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildFinancialRow(
                              context,
                              label: 'Cobrado',
                              value: context.read<SettingsProvider>().formatCurrency(cobrado),
                              icon: Icons.attach_money,
                              color: scheme.primary,
                            ),
                            const SizedBox(height: 8),
                            _buildFinancialRow(
                              context,
                              label: 'Ingresos reconocidos',
                              value: context.read<SettingsProvider>().formatCurrency(reconocido),
                              icon: Icons.check_circle,
                              color: scheme.tertiary,
                            ),
                            const SizedBox(height: 8),
                            _buildFinancialRow(
                              context,
                              label: 'Diferido',
                              value: context.read<SettingsProvider>().formatCurrency(diferido),
                              icon: Icons.schedule,
                              color: scheme.outline,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                if (!bono.activo) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: scheme.errorContainer.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: scheme.error.withValues(alpha:0.3)),
                    ),
                    child: Text(
                      '⚠ Bono agotado o inactivo',
                      style: text.bodySmall?.copyWith(
                        color: scheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFinancialRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: text.bodyMedium?.copyWith(
              color: scheme.onSecondaryContainer,
            ),
          ),
        ),
        Text(
          value,
          style: text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Ítem de lista (bonos activos e históricos)
class _BonoListTile extends StatelessWidget {
  final Bono bono;
  final bool seleccionado;
  final VoidCallback? onTap;

  const _BonoListTile({
    required this.bono,
    this.seleccionado = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text   = Theme.of(context).textTheme;

    final usadas  = bono.sesionesUsadas;
    final totales = bono.sesionesTotales;
    final nombreServicio = context.select<ServiciosProvider, String?>(
      (sp) => sp.nombreServicioPorId(bono.servicioId),
    );

    return ListTile(
      onTap: onTap,
      selected: seleccionado,
      selectedTileColor: scheme.secondaryContainer.withValues(alpha:0.15),
      contentPadding: EdgeInsets.zero,
      title: Text(
        bono.nombre,
        style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nombreServicio ?? 'Servicio',
            style: text.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha:0.8)),
          ),
          Text(
            'Sesiones: $usadas / $totales',
            style: text.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha:0.8)),
          ),
          if (bono.caducaEl != null)
            Text(
              'Caduca: ${_fmtDate(bono.caducaEl!, context)}',
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
        ],
      ),
      trailing: bono.activo
          ? Chip(
              label: const Text('Activo'),
              backgroundColor: scheme.secondaryContainer,
              labelStyle: text.labelLarge?.copyWith(color: scheme.onSecondaryContainer),
              side: BorderSide(color: scheme.outlineVariant),
            )
          : Chip(
              label: const Text('Inactivo'),
              backgroundColor: scheme.surfaceVariant,
              labelStyle: text.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
              side: BorderSide(color: scheme.outlineVariant),
            ),
    );
  }
}


/// Diálogo para crear un bono nuevo (SIN pedir clienteId)
class _CrearBonoDialog extends StatefulWidget {
  final String clienteId; // llega desde BonosPanel
  const _CrearBonoDialog({required this.clienteId});

  @override
  State<_CrearBonoDialog> createState() => _CrearBonoDialogState();
}

class _CrearBonoDialogState extends State<_CrearBonoDialog> {
  String? servicioId;
  int sesiones = 5;
  double? precio;
  DateTime? caducaEl;

  @override
  Widget build(BuildContext context) {
    final serviciosProvider  = context.read<ServiciosProvider>();
    final servicios          = serviciosProvider.servicios;

    return AlertDialog(
      title: const Text('Crear bono de sesiones'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: servicioId,
              items: servicios
                  .map((s) => DropdownMenuItem(value: s.id, child: Text(s.nombre)))
                  .toList(),
              onChanged: (v) => setState(() => servicioId = v),
              decoration: const InputDecoration(labelText: 'Servicio'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: sesiones,
                    items: List.generate(32, (i) => i + 1)
                        .map((n) => DropdownMenuItem(value: n, child: Text('$n sesiones')))
                        .toList(),
                    onChanged: (v) => setState(() => sesiones = v ?? 5),
                    decoration: const InputDecoration(labelText: 'Nº de sesiones'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Precio del bono (opcional)'),
                    onChanged: (v) => precio = double.tryParse(v.replaceAll(',', '.')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: DateTime(now.year - 1),
                        lastDate: DateTime(now.year + 5),
                      );
                      if (picked != null) setState(() => caducaEl = picked);
                    },
                    icon: const Icon(Icons.event),
                    label: Text(
                      caducaEl == null ? 'Sin caducidad' : 'Caduca: ${_fmtDate(caducaEl!, context)}',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () async {
            if (servicioId == null || sesiones <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Completa servicio y nº de sesiones')),
              );
              return;
            }

            await context.read<BonosProvider>().crearBonoSesiones(
              clienteId: widget.clienteId,   // automático desde el panel
              servicioId: servicioId!,
              sesiones: sesiones,
              precioBono: precio,
              caducaEl: caducaEl,
            );

            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }
}

class _AnadirPagoDialog extends StatefulWidget {
  final String bonoId;
  const _AnadirPagoDialog({required this.bonoId});

  @override
  State<_AnadirPagoDialog> createState() => _AnadirPagoDialogState();
}

class _AnadirPagoDialogState extends State<_AnadirPagoDialog> {
  final _formKey = GlobalKey<FormState>();
  double? importe;
  String? metodo; // efectivo | bizum | tarjeta
  DateTime fecha = DateTime.now();
  String? nota;

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text('Añadir pago de bono'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Importe'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                final x = double.tryParse((v ?? '').replaceAll(',', '.'));
                if (x == null) return 'Importe inválido';
                return null;
              },
              onSaved: (v) => importe = double.tryParse((v ?? '').replaceAll(',', '.')),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Método'),
              value: metodo,
              items: const [
                DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                DropdownMenuItem(value: 'Bizum', child: Text('Bizum')),
                DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
              ],
              onChanged: (v) => setState(() => metodo = v),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.event),
                    label: Text(_fmtDate(fecha, context)),
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: fecha,
                        firstDate: DateTime(now.year - 1),
                        lastDate: DateTime(now.year + 5),
                      );
                      if (picked != null) setState(() => fecha = picked);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nota (opcional)'),
              onChanged: (v) => nota = v.isEmpty ? null : v,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState!.save();

            await context.read<BonosProvider>().insertarPagoBono(
              bonoId: widget.bonoId,
              importe: importe!, // validado
              metodo: metodo,
              fecha: fecha,
              nota: nota,
            );
            if (context.mounted) Navigator.pop(context, true);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}


// Utilidad de formateo de fecha — usa el formato elegido por el usuario
String _fmtDate(DateTime d, BuildContext context) =>
    context.read<SettingsProvider>().formatDate(d);
