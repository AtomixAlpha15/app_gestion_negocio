import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_provider.dart';

// ── Provider local para el estado de la pantalla ─────────────────────────────

class _SuscripcionState {
  final bool cargando;
  final String? error;
  final String billingPeriod; // 'monthly' | 'annual'
  final String? planActual;
  final String? planStatus;
  final bool tieneStripeSubscription;
  final DateTime? planExpiresAt;

  const _SuscripcionState({
    this.cargando = false,
    this.error,
    this.billingPeriod = 'monthly',
    this.planActual,
    this.planStatus,
    this.tieneStripeSubscription = false,
    this.planExpiresAt,
  });

  _SuscripcionState copyWith({
    bool? cargando,
    String? error,
    String? billingPeriod,
    String? planActual,
    String? planStatus,
    bool? tieneStripeSubscription,
  }) =>
      _SuscripcionState(
        cargando: cargando ?? this.cargando,
        error: error ?? this.error,
        billingPeriod: billingPeriod ?? this.billingPeriod,
        planActual: planActual ?? this.planActual,
        planStatus: planStatus ?? this.planStatus,
        tieneStripeSubscription: tieneStripeSubscription ?? this.tieneStripeSubscription,
        planExpiresAt: planExpiresAt,
      );
}

// ── Datos de cada plan ────────────────────────────────────────────────────────

class _PlanInfo {
  final String id;
  final String nombre;
  final double precioMensual;
  final double precioAnual;
  final List<String> features;
  final IconData icono;
  final Color color;

  const _PlanInfo({
    required this.id,
    required this.nombre,
    required this.precioMensual,
    required this.precioAnual,
    required this.features,
    required this.icono,
    required this.color,
  });
}

const _planes = [
  _PlanInfo(
    id: 'basic',
    nombre: 'Basic',
    precioMensual: 7,
    precioAnual: 70,
    icono: Icons.star_outline,
    color: Colors.blueGrey,
    features: [
      '1 dispositivo a la vez',
      'Sincronización al iniciar sesión',
      'Clientes, Servicios y Agenda',
      'Bonos y Contabilidad',
    ],
  ),
  _PlanInfo(
    id: 'pro',
    nombre: 'Pro',
    precioMensual: 15,
    precioAnual: 150,
    icono: Icons.star_half,
    color: Colors.indigo,
    features: [
      'Multi-dispositivo',
      'Sincronización en tiempo real',
      'Todo lo de Basic',
      'Multi-agenda (varios trabajadores)',
    ],
  ),
  _PlanInfo(
    id: 'ultra',
    nombre: 'Ultra',
    precioMensual: 30,
    precioAnual: 300,
    icono: Icons.star,
    color: Colors.amber,
    features: [
      'Todo lo de Pro',
      'Multi-establecimiento',
      'Cambiar entre locales en la misma cuenta',
      'Soporte prioritario',
    ],
  ),
];

// ── Pantalla principal ────────────────────────────────────────────────────────

class SuscripcionScreen extends ConsumerStatefulWidget {
  const SuscripcionScreen({super.key});

  @override
  ConsumerState<SuscripcionScreen> createState() => _SuscripcionScreenState();
}

class _SuscripcionScreenState extends ConsumerState<SuscripcionScreen>
    with WidgetsBindingObserver {
  _SuscripcionState _state = const _SuscripcionState();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cargarPlan();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Refresca el plan cuando el usuario vuelve desde el navegador (post-checkout)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _cargarPlan();
    }
  }

  Future<void> _cargarPlan() async {
    setState(() => _state = _state.copyWith(cargando: true, error: null));
    try {
      final apiService = ref.read(apiServiceProvider);
      final data = await apiService.getSubscription();
      final expiresAtStr = data['plan_expires_at'] as String?;
      final expiresAt = expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;
      setState(() => _state = _SuscripcionState(
            billingPeriod: _state.billingPeriod,
            planActual: data['plan'] as String? ?? 'basic',
            planStatus: data['plan_status'] as String? ?? 'active',
            tieneStripeSubscription: data['stripe_subscription_id'] != null,
            planExpiresAt: expiresAt,
          ));
    } catch (e) {
      setState(() => _state = _state.copyWith(cargando: false, error: e.toString()));
    }
  }

  Future<void> _contratar(String planId) async {
    setState(() => _state = _state.copyWith(cargando: true, error: null));
    try {
      final apiService = ref.read(apiServiceProvider);
      final url = await apiService.createCheckoutSession(
        plan: planId,
        billingPeriod: _state.billingPeriod,
      );
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      setState(() => _state = _state.copyWith(error: e.toString()));
    } finally {
      setState(() => _state = _state.copyWith(cargando: false));
    }
  }

  Future<void> _gestionarSuscripcion() async {
    setState(() => _state = _state.copyWith(cargando: true, error: null));
    try {
      final apiService = ref.read(apiServiceProvider);
      final url = await apiService.getBillingPortalUrl();
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      setState(() => _state = _state.copyWith(error: e.toString()));
    } finally {
      setState(() => _state = _state.copyWith(cargando: false));
    }
  }

  Future<void> _cancelarSuscripcion() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar suscripción'),
        content: const Text(
          'Tu suscripción se cancelará al final del período actual. '
          'Seguirás teniendo acceso completo hasta la fecha de renovación.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Mantener plan'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _state = _state.copyWith(cargando: true, error: null));
    try {
      final apiService = ref.read(apiServiceProvider);
      await apiService.cancelSubscription();
      await _cargarPlan();
    } catch (e) {
      setState(() => _state = _state.copyWith(cargando: false, error: e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final annual = _state.billingPeriod == 'annual';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suscripción'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Verificar estado',
            onPressed: _state.cargando ? null : _cargarPlan,
          ),
        ],
      ),
      body: _state.cargando && _state.planActual == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Plan actual
                if (_state.planActual != null) ...[
                  _PlanActualBanner(
                    plan: _state.planActual!,
                    status: _state.planStatus ?? 'active',
                    planExpiresAt: _state.planExpiresAt,
                  ),
                  const SizedBox(height: 24),
                ],

                // Error
                if (_state.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _state.error!,
                      style: TextStyle(color: cs.onErrorContainer, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Toggle mensual / anual
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Mensual'),
                    const SizedBox(width: 8),
                    Switch(
                      value: annual,
                      onChanged: (_) => setState(() => _state = _state.copyWith(
                            billingPeriod: annual ? 'monthly' : 'annual',
                          )),
                    ),
                    const SizedBox(width: 8),
                    const Text('Anual'),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '2 meses gratis',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tarjetas de planes
                ..._planes.map((plan) => _PlanCard(
                      plan: plan,
                      esActual: plan.id == _state.planActual,
                      annual: annual,
                      cargando: _state.cargando,
                      onContratar: () => _contratar(plan.id),
                    )),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),

                // Gestionar suscripción (si ya tiene una)
                if (_state.tieneStripeSubscription) ...[
                  ListTile(
                    leading: const Icon(Icons.manage_accounts_outlined),
                    title: const Text('Gestionar suscripción'),
                    subtitle: const Text(
                        'Cambiar método de pago, ver facturas…'),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                    onTap: _state.cargando ? null : _gestionarSuscripcion,
                  ),
                  if (_state.planStatus == 'active')
                    ListTile(
                      leading: Icon(Icons.cancel_outlined, color: Colors.red.shade400),
                      title: Text('Cancelar suscripción',
                          style: TextStyle(color: Colors.red.shade400)),
                      subtitle: const Text('El acceso se mantiene hasta el fin del período pagado'),
                      onTap: _state.cargando ? null : _cancelarSuscripcion,
                    ),
                ],

                ListTile(
                  leading: const Icon(Icons.refresh_outlined),
                  title: const Text('Verificar estado del pago'),
                  subtitle: const Text('Si acabas de pagar, toca aquí para actualizar tu plan'),
                  onTap: _state.cargando ? null : _cargarPlan,
                ),

                const SizedBox(height: 8),
                Text(
                  'Los precios no incluyen impuestos. Puedes cancelar en cualquier momento desde el portal de gestión.',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}

// ── Banner plan actual ────────────────────────────────────────────────────────

class _PlanActualBanner extends StatelessWidget {
  final String plan;
  final String status;
  final DateTime? planExpiresAt;
  const _PlanActualBanner({required this.plan, required this.status, this.planExpiresAt});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final isCanceledWithAccess = status == 'canceled' &&
        planExpiresAt != null &&
        planExpiresAt!.isAfter(DateTime.now());

    final badgeColor = switch (status) {
      'active' => Colors.green.shade600,
      'canceled' when isCanceledWithAccess => Colors.orange.shade700,
      'past_due' => cs.error,
      _ => cs.error,
    };
    final statusLabel = switch (status) {
      'active' => 'Activo',
      'past_due' => 'Pago pendiente',
      'canceled' => 'Cancelado',
      _ => status,
    };

    String? expiryNote;
    if (isCanceledWithAccess) {
      final d = planExpiresAt!;
      expiryNote =
          'Acceso hasta el ${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.account_circle_outlined, color: cs.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plan actual',
                    style: TextStyle(
                        fontSize: 12,
                        color: cs.onPrimaryContainer.withValues(alpha: 0.7))),
                Text(
                  _nombrePlan(plan),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimaryContainer),
                ),
                if (expiryNote != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    expiryNote,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _nombrePlan(String id) => switch (id) {
        'basic' => 'Basic',
        'pro' => 'Pro',
        'ultra' => 'Ultra',
        _ => id,
      };
}

// ── Tarjeta de plan ───────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final _PlanInfo plan;
  final bool esActual;
  final bool annual;
  final bool cargando;
  final VoidCallback onContratar;

  const _PlanCard({
    required this.plan,
    required this.esActual,
    required this.annual,
    required this.cargando,
    required this.onContratar,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final precio = annual ? plan.precioAnual / 12 : plan.precioMensual;
    final precioLabel = annual
        ? '€${plan.precioAnual.toStringAsFixed(0)}/año'
        : '€${plan.precioMensual.toStringAsFixed(0)}/mes';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: esActual
            ? BorderSide(color: cs.primary, width: 2)
            : BorderSide(color: cs.outlineVariant),
      ),
      elevation: esActual ? 2 : 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Row(
              children: [
                Icon(plan.icono, color: plan.color, size: 28),
                const SizedBox(width: 10),
                Text(
                  plan.nombre,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: plan.color,
                      ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '€${precio.toStringAsFixed(0)}/mes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    if (annual)
                      Text(
                        precioLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Features
            ...plan.features.map(
              (f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 16, color: plan.color),
                    const SizedBox(width: 8),
                    Expanded(child: Text(f, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Botón
            SizedBox(
              width: double.infinity,
              child: esActual
                  ? OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Plan actual'),
                    )
                  : FilledButton(
                      onPressed: cargando ? null : onContratar,
                      style: FilledButton.styleFrom(backgroundColor: plan.color),
                      child: cargando
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Contratar'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
