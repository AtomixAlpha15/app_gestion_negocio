import 'dart:math';
import 'dart:ui' as ui;
import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/citas_provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/settings_provider.dart';
import '../services/app_database.dart';
import '../l10n/app_localizations.dart';

// ── Modelos internos ──────────────────────────────────────────────
class _ClienteRank {
  final String nombre;
  final double total;
  const _ClienteRank(this.nombre, this.total);
}

class _ServicioRank {
  final String nombre;
  final int count;
  const _ServicioRank(this.nombre, this.count);
}

class _DashData {
  final List<Cita> citasHoy;
  final double ingresosEsteMes;
  final double impagosTotal;
  final int bonosActivosCount;
  final List<double> ingresosMeses;
  final List<double> gastosMeses;
  final List<String> labelsMeses;
  final List<_ClienteRank> topClientes;
  final List<_ServicioRank> topServicios;
  final List<Cita> impagosRecientes;
  final Map<String, String> clienteNombres;
  final Map<String, String> servicioNombres;

  const _DashData({
    required this.citasHoy,
    required this.ingresosEsteMes,
    required this.impagosTotal,
    required this.bonosActivosCount,
    required this.ingresosMeses,
    required this.gastosMeses,
    required this.labelsMeses,
    required this.topClientes,
    required this.topServicios,
    required this.impagosRecientes,
    required this.clienteNombres,
    required this.servicioNombres,
  });
}

// ── DashboardScreen ───────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Future<_DashData> _dataFuture;


  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _dataFuture = _cargar();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<_DashData> _cargar() async {
    final now = DateTime.now();
    final citasProv = context.read<CitasProvider>();
    final clientesProv = context.read<ClientesProvider>();
    final serviciosProv = context.read<ServiciosProvider>();
    final db = context.read<AppDatabase>();
    final settings = context.read<SettingsProvider>();

    await citasProv.cargarCitasAnio(now.year);

    final clienteNombres = {for (var c in clientesProv.clientes) c.id: c.nombre};
    final servicioNombres = {for (var s in serviciosProv.servicios) s.id: s.nombre};

    final citasHoy = await citasProv.obtenerCitasPorDia(now);
    final ingresosEsteMes =
        await citasProv.totalCobradoMes(now.year, now.month);

    // Total impagos global (solo citas pasadas, no de hoy)
    final hoy = DateTime(now.year, now.month, now.day);
    final impRow = await db.customSelect(
      "SELECT COALESCE(SUM(precio), 0.0) AS t FROM citas "
      "WHERE inicio < ? AND (metodo_pago IS NULL OR metodo_pago = '')",
      variables: [d.Variable<DateTime>(hoy)],
    ).get();
    final impagosTotal = impRow.isNotEmpty
        ? ((impRow.first.data['t'] as num?) ?? 0.0).toDouble()
        : 0.0;

    // Bonos activos
    final bonosActivos =
        await (db.select(db.bonos)..where((b) => b.activo.equals(true))).get();

    // Últimos 6 meses de ingresos y gastos
    final List<double> ingresosMeses = [];
    final List<double> gastosMeses = [];
    final List<String> labelsMeses = [];
    for (int i = 5; i >= 0; i--) {
      int mes = now.month - i;
      int anio = now.year;
      if (mes <= 0) {
        mes += 12;
        anio -= 1;
      }
      final ing = await citasProv.totalCobradoMes(anio, mes);
      final inicio = DateTime(anio, mes, 1);
      final fin = DateTime(anio, mes + 1, 1).subtract(const Duration(days: 1));
      final gasRows = await (db.select(db.gastos)
            ..where((g) => g.fecha.isBetweenValues(inicio, fin)))
          .get();
      final gas = gasRows.fold(0.0, (s, g) => s + g.precio);
      ingresosMeses.add(ing);
      gastosMeses.add(gas);
      labelsMeses.add(settings.monthAbbrev(mes));
    }

    // Top 3 clientes por gasto total
    final topClientesRows = await db.customSelect(
      "SELECT cliente_id, COALESCE(SUM(precio),0) AS t FROM citas "
      "WHERE metodo_pago IS NOT NULL AND metodo_pago <> '' "
      "GROUP BY cliente_id ORDER BY t DESC LIMIT 3",
    ).get();
    final topClientes = topClientesRows.map((r) {
      final id = r.data['cliente_id'] as String? ?? '';
      final total = ((r.data['t'] as num?) ?? 0).toDouble();
      return _ClienteRank(clienteNombres[id] ?? 'Cliente', total);
    }).toList();

    // Top 3 servicios por frecuencia
    final topServiciosRows = await db.customSelect(
      "SELECT servicio_id, COUNT(*) AS c FROM citas "
      "GROUP BY servicio_id ORDER BY c DESC LIMIT 3",
    ).get();
    final topServicios = topServiciosRows.map((r) {
      final id = r.data['servicio_id'] as String? ?? '';
      final count = (r.data['c'] as int?) ?? 0;
      return _ServicioRank(servicioNombres[id] ?? 'Servicio', count);
    }).toList();

    // Impagos recientes (solo citas pasadas, no de hoy)
    final impagosRecientes = await (db.select(db.citas)
          ..where((c) =>
              c.inicio.isSmallerThanValue(hoy) &
              (c.metodoPago.isNull() | c.metodoPago.equals('')))
          ..orderBy([(c) => d.OrderingTerm.desc(c.inicio)])
          ..limit(8))
        .get();

    if (mounted) _anim.forward();

    return _DashData(
      citasHoy: citasHoy,
      ingresosEsteMes: ingresosEsteMes,
      impagosTotal: impagosTotal,
      bonosActivosCount: bonosActivos.length,
      ingresosMeses: ingresosMeses,
      gastosMeses: gastosMeses,
      labelsMeses: labelsMeses,
      topClientes: topClientes,
      topServicios: topServicios,
      impagosRecientes: impagosRecientes,
      clienteNombres: clienteNombres,
      servicioNombres: servicioNombres,
    );
  }

  Animation<double> _interval(double from, double to) => CurvedAnimation(
        parent: _anim,
        curve: Interval(from, to, curve: Curves.easeOutCubic),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_DashData>(
      future: _dataFuture,
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snap.data!;
        final settings = ctx.watch<SettingsProvider>();
        final l = AppLocalizations.of(ctx);
        final sim = settings.simboloMoneda;
        final scheme = Theme.of(ctx).colorScheme;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Saludo ──────────────────────────────────────────
              _animated(
                anim: _interval(0.0, 0.35),
                offsetY: 0.06,
                child: _GreetingCard(nombreEmpresa: settings.nombreEmpresa),
              ),
              const SizedBox(height: 16),

              // ── KPIs ────────────────────────────────────────────
              Row(children: [
                Expanded(
                  child: _animated(
                    anim: _interval(0.1, 0.45),
                    offsetY: 0.08,
                    child: _KpiCard(
                      label: l.dashMonthlyRevenue,
                      value: data.ingresosEsteMes,
                      icon: Icons.trending_up_rounded,
                      color: scheme.primary,
                      suffix: ' $sim',
                      anim: _interval(0.2, 0.8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _animated(
                    anim: _interval(0.15, 0.5),
                    offsetY: 0.08,
                    child: _KpiCard(
                      label: l.dashAppointmentsToday,
                      value: data.citasHoy.length.toDouble(),
                      icon: Icons.event_rounded,
                      color: scheme.secondary,
                      suffix: '',
                      anim: _interval(0.25, 0.8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _animated(
                    anim: _interval(0.2, 0.55),
                    offsetY: 0.08,
                    child: _KpiCard(
                      label: l.dashUnpaidTotal,
                      value: data.impagosTotal,
                      icon: Icons.warning_amber_rounded,
                      color: scheme.error,
                      suffix: ' $sim',
                      anim: _interval(0.3, 0.85),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _animated(
                    anim: _interval(0.25, 0.6),
                    offsetY: 0.08,
                    child: _KpiCard(
                      label: l.dashActiveBonuses,
                      value: data.bonosActivosCount.toDouble(),
                      icon: Icons.card_giftcard_rounded,
                      color: scheme.tertiary,
                      suffix: '',
                      anim: _interval(0.35, 0.85),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              // ── Gráfica + Agenda de hoy ──────────────────────────
              SizedBox(
                height: 420,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _animated(
                        anim: _interval(0.3, 0.65),
                        offsetY: 0.06,
                        child: _ChartCard(data: data, anim: _interval(0.4, 1.0), sim: sim),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: _animated(
                        anim: _interval(0.35, 0.7),
                        offsetY: 0.06,
                        child: _AgendaHoyCard(
                          citas: data.citasHoy,
                          clienteNombres: data.clienteNombres,
                          servicioNombres: data.servicioNombres,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Top 3 + Impagos ──────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _animated(
                      anim: _interval(0.5, 0.85),
                      offsetY: 0.06,
                      child: _TopCard(
                        titulo: l.dashTopClients,
                        icon: Icons.emoji_events_rounded,
                        items: data.topClientes
                            .map((c) => (c.nombre, settings.formatCurrency(c.total, decimals: 0)))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _animated(
                      anim: _interval(0.55, 0.9),
                      offsetY: 0.06,
                      child: _TopCard(
                        titulo: l.dashTopServices,
                        icon: Icons.auto_awesome_rounded,
                        items: data.topServicios
                            .map((s) => (s.nombre, '${s.count}'))
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _animated(
                      anim: _interval(0.6, 0.95),
                      offsetY: 0.06,
                      child: _ImpagosPendientesCard(
                        impagos: data.impagosRecientes,
                        clienteNombres: data.clienteNombres,
                        servicioNombres: data.servicioNombres,
                        sim: sim,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _animated({
    required Animation<double> anim,
    required Widget child,
    double offsetY = 0.05,
  }) {
    return AnimatedBuilder(
      animation: anim,
      child: child,
      builder: (_, ch) => FadeTransition(
        opacity: anim,
        child: Transform.translate(
          offset: Offset(0, (1 - anim.value) * offsetY * 400),
          child: ch,
        ),
      ),
    );
  }
}

// ── _GreetingCard ─────────────────────────────────────────────────
class _GreetingCard extends StatelessWidget {
  final String nombreEmpresa;
  const _GreetingCard({required this.nombreEmpresa});

  String _saludo(String locale) {
    final h = DateTime.now().hour;
    if (locale == 'en') {
      if (h < 12) return 'Good morning';
      if (h < 20) return 'Good afternoon';
      return 'Good evening';
    }
    if (h < 12) return 'Buenos días';
    if (h < 20) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String _fechaLarga(SettingsProvider settings) {
    final now = DateTime.now();
    final dayName = settings.weekdayAbbrev(now.weekday);
    final monthName = settings.monthName(now.month);
    if (settings.idioma == 'en') {
      return '$dayName, ${monthName[0].toUpperCase()}${monthName.substring(1)} ${now.day}, ${now.year}';
    }
    return '$dayName, ${now.day} de $monthName de ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final settings = context.watch<SettingsProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_saludo(settings.idioma)},',
                  style: text.titleLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 4),
                Text(
                  nombreEmpresa.isEmpty
                      ? AppLocalizations.of(context).appName
                      : nombreEmpresa,
                  style: text.headlineMedium?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.wb_sunny_rounded,
                  color: Colors.white.withValues(alpha: 0.85), size: 36),
              const SizedBox(height: 6),
              Text(
                _fechaLarga(settings),
                style: text.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.75)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── _KpiCard ──────────────────────────────────────────────────────
class _KpiCard extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;
  final String suffix;
  final Animation<double> anim;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.suffix,
    required this.anim,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: anim,
            builder: (_, __) {
              final v = value * anim.value;
              final display = suffix.isNotEmpty
                  ? '${v.toStringAsFixed(v >= 100 ? 0 : 1)}$suffix'
                  : v.toInt().toString();
              return Text(display,
                  style: text.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold, color: color));
            },
          ),
          const SizedBox(height: 4),
          Text(label,
              style: text.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

// ── _ChartCard ────────────────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  final _DashData data;
  final Animation<double> anim;
  final String sim;

  const _ChartCard(
      {required this.data, required this.anim, required this.sim});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(AppLocalizations.of(context).dashRevenueVsExpenses,
                style: text.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            _LegendDot(color: scheme.primary, label: AppLocalizations.of(context).accountingIncome),
            const SizedBox(width: 12),
            _LegendDot(color: scheme.error, label: AppLocalizations.of(context).accountingExpenses),
          ]),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedBuilder(
              animation: anim,
              builder: (_, __) => CustomPaint(
                painter: _BarChartPainter(
                  ingresos: data.ingresosMeses,
                  gastos: data.gastosMeses,
                  labels: data.labelsMeses,
                  progress: anim.value,
                  colorIngresos: scheme.primary,
                  colorGastos: scheme.error,
                  colorGrid: scheme.outlineVariant,
                  colorLabel: scheme.onSurfaceVariant,
                  sim: sim,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: 10, height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
    ]);
  }
}

class _BarChartPainter extends CustomPainter {
  final List<double> ingresos;
  final List<double> gastos;
  final List<String> labels;
  final double progress;
  final Color colorIngresos, colorGastos, colorGrid, colorLabel;
  final String sim;

  const _BarChartPainter({
    required this.ingresos,
    required this.gastos,
    required this.labels,
    required this.progress,
    required this.colorIngresos,
    required this.colorGastos,
    required this.colorGrid,
    required this.colorLabel,
    required this.sim,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const padL = 52.0;
    const padB = 28.0;
    const padT = 8.0;
    const padR = 8.0;
    final W = size.width - padL - padR;
    final H = size.height - padB - padT;

    final allVals = [...ingresos, ...gastos];
    final maxVal = allVals.isEmpty ? 1.0 : allVals.reduce(max);
    if (maxVal <= 0) return;

    // Calcular intervalo redondeado
    double _roundInterval(double max) {
      if (max <= 0) return 100;
      final exp = (log(max) / ln10).floor();
      final base = pow(10, exp).toDouble();
      final normalized = max / base;

      if (normalized <= 1) return base / 10;
      if (normalized <= 2) return base / 5;
      if (normalized <= 5) return base / 2;
      return base;
    }

    final interval = _roundInterval(maxVal);
    final roundedMax = ((maxVal / interval).ceil() * interval);

    final gridP = Paint()
      ..color = colorGrid
      ..strokeWidth = 1;
    final ingP = Paint()
      ..color = colorIngresos
      ..style = PaintingStyle.fill;
    final gasP = Paint()
      ..color = colorGastos
      ..style = PaintingStyle.fill;

    // Grid lines con escala redonda
    int gridCount = ((roundedMax / interval) + 1).toInt();
    for (int i = 0; i < gridCount; i++) {
      final val = i * interval;
      final ratio = val / roundedMax;
      final y = padT + H * (1 - ratio);
      if (y >= padT && y <= padT + H) {
        canvas.drawLine(Offset(padL, y), Offset(padL + W, y), gridP);
        _drawText(
            canvas,
            val >= 1000 ? '${(val / 1000).toStringAsFixed(0)}k' : val.toInt().toString(),
            Offset(padL - 6, y),
            colorLabel,
            10,
            align: TextAlign.right);
      }
    }

    // Bars
    final n = ingresos.length;
    final groupW = W / n;
    const groupPad = 6.0;
    const barGap = 3.0;
    final barW = (groupW - groupPad * 2 - barGap) / 2;
    const radius = Radius.circular(4);

    for (int i = 0; i < n; i++) {
      final gx = padL + i * groupW + groupPad;

      final ingH = (ingresos[i] / roundedMax) * H * progress;
      final ingRect = Rect.fromLTWH(gx, padT + H - ingH, barW, ingH);
      canvas.drawRRect(
          RRect.fromRectAndCorners(ingRect, topLeft: radius, topRight: radius),
          ingP);

      final gasH = (gastos[i] / roundedMax) * H * progress;
      final gasRect =
          Rect.fromLTWH(gx + barW + barGap, padT + H - gasH, barW, gasH);
      canvas.drawRRect(
          RRect.fromRectAndCorners(gasRect, topLeft: radius, topRight: radius),
          gasP);

      // X label
      _drawText(
          canvas,
          i < labels.length ? labels[i] : '',
          Offset(padL + i * groupW + groupW / 2, size.height - padB + 6),
          colorLabel,
          10,
          align: TextAlign.center);
    }
  }

  void _drawText(Canvas canvas, String text, Offset position, Color color,
      double fontSize,
      {TextAlign align = TextAlign.left}) {
    final pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: align,
      fontSize: fontSize,
    ))
      ..pushStyle(ui.TextStyle(color: color))
      ..addText(text);
    final p = pb.build()..layout(ui.ParagraphConstraints(width: 60));
    canvas.drawParagraph(
        p,
        Offset(
          align == TextAlign.center ? position.dx - 30 : position.dx - 52,
          position.dy - p.height / 2,
        ));
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.progress != progress ||
      old.ingresos != ingresos ||
      old.gastos != gastos;
}

// ── _AgendaHoyCard ────────────────────────────────────────────────
class _AgendaHoyCard extends StatelessWidget {
  final List<Cita> citas;
  final Map<String, String> clienteNombres;
  final Map<String, String> servicioNombres;

  const _AgendaHoyCard({
    required this.citas,
    required this.clienteNombres,
    required this.servicioNombres,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.today_rounded, size: 18, color: scheme.primary),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).agendaTitle,
                style:
                    text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: citas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_available_rounded,
                            size: 40, color: scheme.outlineVariant),
                        const SizedBox(height: 8),
                        Text(AppLocalizations.of(context).dashNoAppointmentsToday,
                            style: text.bodyMedium
                                ?.copyWith(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: citas.length,
                    itemBuilder: (_, idx) {
                      final c = citas[idx];
                      final isPast = c.fin.isBefore(now);
                      final isNow = c.inicio.isBefore(now) && c.fin.isAfter(now);
                      final hIni =
                          '${c.inicio.hour.toString().padLeft(2, '0')}:${c.inicio.minute.toString().padLeft(2, '0')}';
                      final hFin =
                          '${c.fin.hour.toString().padLeft(2, '0')}:${c.fin.minute.toString().padLeft(2, '0')}';
                      final cliente = clienteNombres[c.clienteId] ?? '';
                      final servicio = servicioNombres[c.servicioId] ?? '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isNow
                              ? scheme.primaryContainer
                              : isPast
                                  ? scheme.surfaceContainerHighest
                                  : scheme.secondaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: isNow
                              ? Border.all(color: scheme.primary, width: 1.5)
                              : null,
                        ),
                        child: Row(children: [
                          Text('$hIni\n$hFin',
                              style: text.labelSmall?.copyWith(
                                color: isNow
                                    ? scheme.onPrimaryContainer
                                    : scheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cliente,
                                    style: text.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isNow
                                            ? scheme.onPrimaryContainer
                                            : scheme.onSurface),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(servicio,
                                    style: text.labelSmall?.copyWith(
                                        color: isNow
                                            ? scheme.onPrimaryContainer
                                                .withValues(alpha: 0.7)
                                            : scheme.onSurfaceVariant),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          if (isNow)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(AppLocalizations.of(context).agendaStart,
                                  style: text.labelSmall
                                      ?.copyWith(color: scheme.onPrimary)),
                            ),
                        ]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── _TopCard ──────────────────────────────────────────────────────
class _TopCard extends StatelessWidget {
  final String titulo;
  final IconData icon;
  final List<(String nombre, String valor)> items;

  const _TopCard({
    required this.titulo,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    const medals = ['🥇', '🥈', '🥉'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 18, color: scheme.secondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(titulo,
                  style: text.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ]),
          const SizedBox(height: 14),
          if (items.isEmpty)
            Text(AppLocalizations.of(context).dashNoData,
                style: text.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant))
          else
            ...items.asMap().entries.map((entry) {
              final i = entry.key;
              final (nombre, valor) = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(children: [
                  Text(i < medals.length ? medals[i] : '${i + 1}.',
                      style: text.titleMedium),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(nombre,
                        style: text.bodyMedium?.copyWith(
                            fontWeight: i == 0
                                ? FontWeight.bold
                                : FontWeight.normal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text(valor,
                      style: text.labelMedium?.copyWith(
                          color: scheme.primary, fontWeight: FontWeight.w600)),
                ]),
              );
            }),
        ],
      ),
    );
  }
}

// ── _ImpagosPendientesCard ────────────────────────────────────────
class _ImpagosPendientesCard extends StatelessWidget {
  final List<Cita> impagos;
  final Map<String, String> clienteNombres;
  final Map<String, String> servicioNombres;
  final String sim;

  const _ImpagosPendientesCard({
    required this.impagos,
    required this.clienteNombres,
    required this.servicioNombres,
    required this.sim,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.receipt_long_rounded, size: 18, color: scheme.error),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context).dashUnpaidRecent,
                style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: scheme.error)),
          ]),
          const SizedBox(height: 12),
          if (impagos.isEmpty)
            Row(children: [
              Icon(Icons.check_circle_rounded,
                  color: scheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context).dashNoData,
                  style: text.bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant)),
            ])
          else
            ...impagos.map((c) {
              final settings = context.read<SettingsProvider>();
              final cliente = clienteNombres[c.clienteId] ?? '';
              final servicio = servicioNombres[c.servicioId] ?? '';
              final fecha = settings.formatDate(c.inicio);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cliente,
                            style: text.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text('$servicio · $fecha',
                            style: text.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Text(
                    settings.formatCurrency(c.precio, decimals: 0),
                    style: text.labelMedium
                        ?.copyWith(color: scheme.error, fontWeight: FontWeight.w600),
                  ),
                ]),
              );
            }),
        ],
      ),
    );
  }
}
