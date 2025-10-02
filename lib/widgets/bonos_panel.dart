import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bonos_provider.dart';
import '../providers/servicios_provider.dart';
import '../services/app_database.dart'; // Tipos Bono/BonoConsumo (generados por Drift)

// PANEL DE BONOS
class BonosPanel extends StatefulWidget {
  final String clienteId;
  const BonosPanel({super.key, required this.clienteId});

  @override
  State<BonosPanel> createState() => _BonosPanelState();
}

class _BonosPanelState extends State<BonosPanel> {
  @override
  Widget build(BuildContext context) {
    final text   = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final clienteId = widget.clienteId;

    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bonos', style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Bono activo destacado + CTA crear
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<List<Bono>>(
                    future: context.read<BonosProvider>().bonosActivosCliente(clienteId),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const _Loader();
                      }
                      final activos = snap.data ?? [];
                      if (activos.isEmpty) {
                        return Text(
                          'No hay bonos activos.',
                          style: text.bodyMedium?.copyWith(color: scheme.onSurface.withOpacity(0.8)),
                        );
                      }
                      // Muestra el primero activo (si hay más, abajo listamos todo)
                      final bono = activos.first;
                      return _BonoFaceplate(
                        bono: bono,
                        onChanged: () => setState(() {}),
                      );
                    },
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
                      setState(() {}); // recarga ambos FutureBuilder
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

            const SizedBox(height: 16),
            Divider(color: scheme.outlineVariant, height: 24),

            // Lista completa (activos + históricos)
            FutureBuilder<List<Bono>>(
              future: context.read<BonosProvider>().bonosCliente(clienteId),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const _Loader();
                }
                final bonos = snap.data ?? [];
                if (bonos.isEmpty) {
                  return Text('Sin bonos registrados.', style: text.bodyMedium);
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bonos.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: scheme.outlineVariant),
                  itemBuilder: (_, i) => _BonoListTile(bono: bonos[i]),
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

    final usadas   = bono.sesionesUsadas;
    final totales  = bono.sesionesTotales;
    final restante = (totales - usadas).clamp(0, totales);

    final nombreServicio = context.select<ServiciosProvider, String?>(
      (sp) => sp.nombreServicioPorId(bono.servicioId),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bono.nombre ?? 'Bono de sesiones',
            style: text.titleSmall?.copyWith(
              color: scheme.onSecondaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            nombreServicio ?? 'Servicio',
            style: text.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: scheme.onSecondaryContainer,
            ),
            overflow: TextOverflow.ellipsis,
          ),

          Row(
            children: [
              Text('Sesiones: ',
                  style: text.bodyMedium?.copyWith(color: scheme.onSecondaryContainer)),
              Text(
                '$usadas / $totales',
                style: text.bodyMedium?.copyWith(
                  color: scheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (bono.caducaEl != null)
                Text(
                  'Caduca: ${_fmtDate(bono.caducaEl!)}',
                  style: text.bodySmall?.copyWith(
                    color: scheme.onSecondaryContainer.withOpacity(0.9),
                  ),
                ),
              const Spacer(),
              // Eliminar bono
              IconButton(
                tooltip: 'Eliminar bono',
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Eliminar bono'),
                      content: const Text('Esta acción no se puede deshacer.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                  if (ok == true && context.mounted) {
                    await context.read<BonosProvider>().eliminarBono(bono.id);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Bono eliminado')));
                    onChanged?.call(); // refresca el panel
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Tiras de progreso (chips)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(totales, (i) {
              final isUsed = i < usadas;
              return Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: isUsed ? scheme.primary : scheme.surface,
                  border: Border.all(color: scheme.outlineVariant),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),

          if (!bono.activo) ...[
            const SizedBox(height: 8),
            Text(
              'Bono agotado o inactivo',
              style: text.bodySmall?.copyWith(
                color: scheme.onSecondaryContainer.withOpacity(0.8),
              ),
            ),
          ],

          if (restante > 0 && bono.activo) ...[
            const SizedBox(height: 12),
            Text(
              'Quedan $restante sesión(es).',
              style: text.bodySmall?.copyWith(
                color: scheme.onSecondaryContainer.withOpacity(0.95),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Ítem de lista (bonos activos e históricos)
class _BonoListTile extends StatelessWidget {
  final Bono bono;
  const _BonoListTile({required this.bono});

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
      contentPadding: EdgeInsets.zero,
      title: Text(
        bono.nombre ?? 'Bono',
        style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nombreServicio ?? 'Servicio',
            style: text.bodyMedium?.copyWith(color: scheme.onSurface.withOpacity(0.8)),
          ),
          Text(
            'Sesiones: $usadas / $totales',
            style: text.bodyMedium?.copyWith(color: scheme.onSurface.withOpacity(0.8)),
          ),
          if (bono.caducaEl != null)
            Text(
              'Caduca: ${_fmtDate(bono.caducaEl!)}',
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
                      caducaEl == null ? 'Sin caducidad' : 'Caduca: ${_fmtDate(caducaEl!)}',
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

// Utilidad de formateo de fecha
String _fmtDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
