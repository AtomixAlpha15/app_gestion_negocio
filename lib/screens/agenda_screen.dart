import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/citas_provider.dart';
import '../providers/bonos_provider.dart';
import '../providers/extras_servicio_provider.dart';
import '../providers/settings_provider.dart';
import '../services/app_database.dart';
import '../l10n/app_localizations.dart';

extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime fechaSeleccionada = DateTime.now();
  TimeOfDay horaInicio = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay horaFin = const TimeOfDay(hour: 20, minute: 0);

  // Día izquierdo
  List<Cita> _citasIzq = [];
  Map<String, List<String>> _extrasIzq = {};

  // Día derecho (fechaSeleccionada + 1)
  List<Cita> _citasDer = [];
  Map<String, List<String>> _extrasDer = {};

  bool cargandoCitas = false;

  // Zoom compartido entre los dos paneles
  double _zoom = 1.0;

  // Scroll sincronizado
  final _scrollIzq = ScrollController();
  final _scrollDer = ScrollController();
  bool _syncingScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollIzq.addListener(_syncFromIzq);
    _scrollDer.addListener(_syncFromDer);
    cargarCitasDia();
    context.read<ServiciosProvider>().cargarServicios();
    context.read<ClientesProvider>().cargarClientes();
  }

  @override
  void dispose() {
    _scrollIzq.removeListener(_syncFromIzq);
    _scrollDer.removeListener(_syncFromDer);
    _scrollIzq.dispose();
    _scrollDer.dispose();
    super.dispose();
  }

  void _syncFromIzq() {
    if (_syncingScroll) return;
    _syncingScroll = true;
    if (_scrollDer.hasClients) _scrollDer.jumpTo(_scrollIzq.offset);
    _syncingScroll = false;
  }

  void _syncFromDer() {
    if (_syncingScroll) return;
    _syncingScroll = true;
    if (_scrollIzq.hasClients) _scrollIzq.jumpTo(_scrollDer.offset);
    _syncingScroll = false;
  }

  Future<Map<String, List<String>>> _cargarExtras(
      List<Cita> citas, Map<String, String> serviciosMap, AppDatabase db) async {
    final Map<String, List<String>> resultado = {};
    for (final cita in citas) {
      final nombres = <String>[serviciosMap[cita.servicioId] ?? 'Servicio'];
      final extrasCita =
          await (db.select(db.extrasCita)..where((e) => e.citaId.equals(cita.id))).get();
      for (final ec in extrasCita) {
        final extra = await (db.select(db.extrasServicio)
              ..where((ex) => ex.id.equals(ec.extraId)))
            .getSingle();
        nombres.add(extra.nombre);
      }
      resultado[cita.id] = nombres;
    }
    return resultado;
  }

  Future<void> cargarCitasDia() async {
    setState(() => cargandoCitas = true);
    final provider = context.read<CitasProvider>();
    final serviciosProvider = context.read<ServiciosProvider>();
    final extrasProvider = context.read<ExtrasServicioProvider>();
    final db = extrasProvider.db;
    final serviciosMap = {for (var s in serviciosProvider.servicios) s.id: s.nombre};

    final fechaDer = fechaSeleccionada.add(const Duration(days: 1));
    final results = await Future.wait([
      provider.obtenerCitasPorDia(fechaSeleccionada),
      provider.obtenerCitasPorDia(fechaDer),
    ]);

    final extrasResults = await Future.wait([
      _cargarExtras(results[0], serviciosMap, db),
      _cargarExtras(results[1], serviciosMap, db),
    ]);

    setState(() {
      _citasIzq = results[0];
      _extrasIzq = extrasResults[0];
      _citasDer = results[1];
      _extrasDer = extrasResults[1];
      cargandoCitas = false;
    });
  }

  void cambiarFecha(DateTime nuevaFecha) {
    setState(() => fechaSeleccionada = nuevaFecha);
    cargarCitasDia();
  }

  Future<void> _abrirDialogoCrear(DateTime inicio, DateTime fin) async {
    final result = await showDialog(
      context: context,
      builder: (_) => NuevaCitaDialog(
        fecha: inicio,
        horaInicial: TimeOfDay(hour: inicio.hour, minute: inicio.minute),
        horaFinal: TimeOfDay(hour: fin.hour, minute: fin.minute),
      ),
    );
    if (result == true) cargarCitasDia();
  }

  Future<void> _moverCita(Cita cita, DateTime nuevoInicio, DateTime nuevoFin) async {
    final citasProv = context.read<CitasProvider>();
    await citasProv.actualizarCita(
      id: cita.id,
      clienteId: cita.clienteId,
      servicioId: cita.servicioId,
      inicio: nuevoInicio,
      fin: nuevoFin,
      metodoPago: cita.metodoPago,
      precio: cita.precio,
      pagada: cita.pagada,
      notas: cita.notas,
    );
    await citasProv.cargarCitasAnio(nuevoInicio.year);
    cargarCitasDia();
  }

  String _formatFecha(DateTime d) =>
      context.read<SettingsProvider>().formatDate(d);

  AgendaVisual _panel(
    DateTime fecha,
    List<Cita> citas,
    Map<String, List<String>> extras,
    ScrollController scroll,
  ) {
    return AgendaVisual(
      fecha: fecha,
      horaInicio: horaInicio,
      horaFin: horaFin,
      citas: citas,
      servicioYExtrasPorCita: extras,
      zoom: _zoom,
      onZoomChanged: (z) => setState(() => _zoom = z),
      scrollController: scroll,
      onEditarCita: (cita) async {
        final result = await showDialog(
          context: context,
          builder: (_) => NuevaCitaDialog(fecha: cita.inicio, cita: cita),
        );
        if (result == true) cargarCitasDia();
      },
      onCrearCita: _abrirDialogoCrear,
      onMoverCita: _moverCita,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final fechaDer = fechaSeleccionada.add(const Duration(days: 1));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).agendaTitle),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => cambiarFecha(fechaSeleccionada.subtract(const Duration(days: 1))),
                  tooltip: 'Día anterior',
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
                InkWell(
                  onTap: () async {
                    final fecha = await showDatePicker(
                      context: context,
                      initialDate: fechaSeleccionada,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (fecha != null) cambiarFecha(fecha);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatFecha(fechaSeleccionada),
                          style: text.labelSmall?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'a ${_formatFecha(fechaDer)}',
                          style: text.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => cambiarFecha(fechaSeleccionada.add(const Duration(days: 1))),
                  tooltip: 'Día siguiente',
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text('${AppLocalizations.of(context).labelTime}:', style: text.labelSmall?.copyWith(color: scheme.onSurface)),
                ),
                TextButton(
                  onPressed: () async {
                    final hora = await showTimePicker(context: context, initialTime: horaInicio);
                    if (hora != null) setState(() => horaInicio = hora);
                  },
                  child: Text(
                    horaInicio.format(context),
                    style: text.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text('–', style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                TextButton(
                  onPressed: () async {
                    final hora = await showTimePicker(context: context, initialTime: horaFin);
                    if (hora != null) setState(() => horaFin = hora);
                  },
                  child: Text(
                    horaFin.format(context),
                    style: text.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: cargandoCitas
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // ── Panel izquierdo ──────────────────────────────────────────
                Expanded(
                  child: Column(
                    children: [
                      _DiaHeader(fecha: fechaSeleccionada),
                      Expanded(
                        child: _panel(fechaSeleccionada, _citasIzq, _extrasIzq, _scrollIzq),
                      ),
                    ],
                  ),
                ),
                VerticalDivider(width: 1, color: scheme.outlineVariant),
                // ── Panel derecho ────────────────────────────────────────────
                Expanded(
                  child: Column(
                    children: [
                      _DiaHeader(fecha: fechaDer),
                      Expanded(
                        child: _panel(fechaDer, _citasDer, _extrasDer, _scrollDer),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => NuevaCitaDialog(fecha: fechaSeleccionada, horaInicial: horaInicio),
          );
          if (result == true) cargarCitasDia();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DiaHeader extends StatelessWidget {
  final DateTime fecha;
  const _DiaHeader({required this.fecha});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final settings = context.watch<SettingsProvider>();
    final esHoy = DateUtils.isSameDay(fecha, DateTime.now());
    final diaSemana = settings.weekdayAbbrev(fecha.weekday);
    final mesNombre = settings.monthName(fecha.month);
    final label = settings.idioma == 'en'
        ? '$diaSemana ${mesNombre[0].toUpperCase()}${mesNombre.substring(1)} ${fecha.day}'
        : '$diaSemana ${fecha.day} de $mesNombre';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: esHoy
            ? scheme.primary.withValues(alpha: 0.08)
            : scheme.surfaceContainerHigh,
        border: Border(
          bottom: BorderSide(
            color: esHoy ? scheme.primary.withValues(alpha: 0.3) : scheme.outlineVariant,
            width: esHoy ? 2 : 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (esHoy)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          Text(
            label,
            style: text.titleSmall?.copyWith(
              color: esHoy ? scheme.primary : scheme.onSurface,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AgendaVisual
// ─────────────────────────────────────────────────────────────────────────────

class AgendaVisual extends StatefulWidget {
  final DateTime fecha;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;
  final List<Cita> citas;
  final Map<String, List<String>> servicioYExtrasPorCita;
  final void Function(Cita cita)? onEditarCita;
  final void Function(DateTime inicio, DateTime fin)? onCrearCita;
  final void Function(Cita cita, DateTime nuevoInicio, DateTime nuevoFin)? onMoverCita;
  final double zoom;
  final ValueChanged<double>? onZoomChanged;
  final ScrollController? scrollController;

  const AgendaVisual({
    super.key,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.citas,
    required this.servicioYExtrasPorCita,
    this.onEditarCita,
    this.onCrearCita,
    this.onMoverCita,
    this.zoom = 1.0,
    this.onZoomChanged,
    this.scrollController,
  });

  @override
  State<AgendaVisual> createState() => _AgendaVisualState();
}

class _AgendaVisualState extends State<AgendaVisual> {
  static const double _labelW = 88.0;
  static const double _padTop = 16.0;
  static const double _padBot = 64.0;
  static const int _hoverDurMin = 60;

  // Hover preview state
  double? _hoverY;
  bool _sobreVacio = false;

  // Drag state
  Cita? _citaDrag;
  double _dragStartOffsetMin = 0;
  double _dragCurrentY = 0;

  // Trackpad pinch: zoom base al inicio del gesto
  double _panZoomStartZoom = 1.0;

  // Written during build, read in gesture callbacks.
  double _alturaPorMin = 1;
  int _minutosTotales = 720;
  int _horaIniMin = 480;

  int _snapMin(double minutos) => (minutos / 30).round() * 30;

  bool _esSobreCita(double y) {
    final minAbsoluto = _horaIniMin + (y - _padTop) / _alturaPorMin;
    for (final cita in widget.citas) {
      if (cita.id == _citaDrag?.id) continue;
      final ini = cita.inicio.hour * 60.0 + cita.inicio.minute;
      final fin = cita.fin.hour * 60.0 + cita.fin.minute;
      if (minAbsoluto > ini && minAbsoluto < fin) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _minutosTotales = (widget.horaFin.hour * 60 + widget.horaFin.minute) -
        (widget.horaInicio.hour * 60 + widget.horaInicio.minute);
    _horaIniMin = widget.horaInicio.hour * 60 + widget.horaInicio.minute;

    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final clientes = context.watch<ClientesProvider>().clientes;
    final hoy = DateTime.now();
    final hoySolo = DateTime(hoy.year, hoy.month, hoy.day);

    return Column(
      children: [
        // ── Área de agenda ─────────────────────────────────────────────────
        Expanded(
          child: Listener(
            // Ctrl + rueda del ratón → zoom
            onPointerSignal: (event) {
              if (event is PointerScrollEvent &&
                  HardwareKeyboard.instance.isControlPressed) {
                GestureBinding.instance.pointerSignalResolver
                    .register(event, (signal) {
                  final e = signal as PointerScrollEvent;
                  widget.onZoomChanged?.call(
                      (widget.zoom - e.scrollDelta.dy * 0.004).clamp(1.0, 4.0));
                });
              }
            },
            // Pellizco trackpad → zoom
            onPointerPanZoomStart: (_) => _panZoomStartZoom = widget.zoom,
            onPointerPanZoomUpdate: (event) {
              widget.onZoomChanged?.call(
                  (_panZoomStartZoom * event.scale).clamp(1.0, 4.0));
            },
            child: LayoutBuilder(
            builder: (context, constraints) {
              final alturaBase = constraints.maxHeight - _padTop - _padBot;
              final alturaContenido = alturaBase * widget.zoom;
              _alturaPorMin = alturaContenido / _minutosTotales;
              final totalH = alturaContenido + _padTop + _padBot;

              final horas = List.generate(
                widget.horaFin.hour - widget.horaInicio.hour + 1,
                (i) => widget.horaInicio.hour + i,
              );

              // ── Calcular previsualización hover ──────────────────────────
              DateTime? hoverInicio;
              DateTime? hoverFin;
              if (_hoverY != null && _sobreVacio) {
                // Restamos la mitad de la duración para que el ratón quede
                // centrado en la previsualización.
                final minRaw = (_hoverY! - _padTop) / _alturaPorMin;
                final minSnap =
                    _snapMin(minRaw - _hoverDurMin / 2).clamp(0, _minutosTotales - _hoverDurMin);
                final minAbs = _horaIniMin + minSnap;
                hoverInicio = DateTime(widget.fecha.year, widget.fecha.month,
                    widget.fecha.day, minAbs ~/ 60, minAbs % 60);
                hoverFin = hoverInicio.add(const Duration(hours: 1));
              }

              // ── Calcular posición del drag ────────────────────────────────
              int? dragMinSnap;
              if (_citaDrag != null) {
                final durMin =
                    _citaDrag!.fin.difference(_citaDrag!.inicio).inMinutes;
                final minRaw =
                    (_dragCurrentY - _padTop) / _alturaPorMin - _dragStartOffsetMin;
                dragMinSnap =
                    _snapMin(minRaw).clamp(0, _minutosTotales - durMin);
              }

              return SingleChildScrollView(
                controller: widget.scrollController,
                child: SizedBox(
                  height: totalH,
                  child: MouseRegion(
                    onHover: (event) {
                      final y = event.localPosition.dy;
                      final x = event.localPosition.dx;
                      final enZona =
                          x > _labelW && y > _padTop && y < totalH - _padBot;
                      setState(() {
                        if (enZona && _citaDrag == null) {
                          _hoverY = y;
                          _sobreVacio = !_esSobreCita(y);
                        } else {
                          _hoverY = null;
                          _sobreVacio = false;
                        }
                      });
                    },
                    onExit: (_) => setState(() {
                      _hoverY = null;
                      _sobreVacio = false;
                    }),
                    child: Stack(
                      children: [
                        // ── Líneas de horas ──────────────────────────────────
                        // Texto y línea como Positioned separados para que la
                        // línea quede en el píxel exacto y las citas cuadren.
                        ...horas.expand((h) {
                          final top = _padTop +
                              (h - widget.horaInicio.hour) * 60 * _alturaPorMin;
                          return [
                            Positioned(
                              top: top,
                              left: _labelW,
                              right: 0,
                              child: Divider(
                                thickness: 1,
                                color: scheme.outlineVariant,
                                height: 0,
                              ),
                            ),
                            Positioned(
                              top: top - 9,
                              left: 0,
                              width: _labelW - 8,
                              child: Text(
                                '${h.toString().padLeft(2, '0')}:00',
                                style: text.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: scheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ];
                        }),

                        // ── Previsualización hover (detrás de citas) ─────────
                        if (hoverInicio != null && hoverFin != null) ...[
                          () {
                            final ini = hoverInicio!;
                            final fin = hoverFin!;
                            final minDesde =
                                (ini.hour * 60 + ini.minute) - _horaIniMin;
                            final top = _padTop + minDesde * _alturaPorMin;
                            final height = _hoverDurMin * _alturaPorMin;
                            return Positioned(
                              left: _labelW,
                              right: 16,
                              top: top,
                              height: height,
                              child: GestureDetector(
                                onTap: () =>
                                    widget.onCrearCita?.call(ini, fin),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: scheme.primary.withValues(alpha: 0.15),
                                    border: Border.all(
                                      color: scheme.primary.withValues(alpha: 0.6),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: scheme.primary,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Nueva cita',
                                        style: text.labelSmall?.copyWith(
                                          color: scheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }(),
                        ],

                        // ── Bloques de citas ─────────────────────────────────
                        ...widget.citas.map((cita) {
                          final minIni = (cita.inicio.hour * 60 +
                                  cita.inicio.minute) -
                              _horaIniMin;
                          final durMin =
                              cita.fin.difference(cita.inicio).inMinutes;
                          final top = _padTop + minIni * _alturaPorMin;
                          final height =
                              (durMin * _alturaPorMin).clamp(28.0, double.infinity);

                          final cliente = clientes
                              .firstWhereOrNull((c) => c.id == cita.clienteId);
                          final nombreCliente = cliente?.nombre ?? 'Cliente';
                          final nombreServicioYExtras =
                              (widget.servicioYExtrasPorCita[cita.id] ?? [])
                                  .join(' + ');

                          final esPasada = cita.inicio.isBefore(hoySolo);
                          final impagada =
                              (cita.metodoPago == null ||
                                  cita.metodoPago!.isEmpty) &&
                              esPasada;

                          final Color bg = impagada
                              ? scheme.tertiaryContainer
                              : scheme.secondaryContainer;
                          final Color fg = impagada
                              ? scheme.onTertiaryContainer
                              : scheme.onSecondaryContainer;

                          final bool esDragActual = _citaDrag?.id == cita.id;
                          final horaFormato = '${cita.inicio.hour.toString().padLeft(2, '0')}:${cita.inicio.minute.toString().padLeft(2, '0')} - ${cita.fin.hour.toString().padLeft(2, '0')}:${cita.fin.minute.toString().padLeft(2, '0')}';

                          return Positioned(
                            left: _labelW,
                            right: 16,
                            top: top,
                            height: height,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: esDragActual
                                  ? null
                                  : () => widget.onEditarCita?.call(cita),
                              onPanStart: (d) {
                                setState(() {
                                  _citaDrag = cita;
                                  _dragStartOffsetMin =
                                      d.localPosition.dy / _alturaPorMin;
                                  _dragCurrentY = top + d.localPosition.dy;
                                  _hoverY = null;
                                  _sobreVacio = false;
                                });
                              },
                              onPanUpdate: (d) => setState(
                                  () => _dragCurrentY += d.delta.dy),
                              onPanEnd: (_) {
                                if (_citaDrag != null && dragMinSnap != null) {
                                  final cita = _citaDrag!;
                                  final snap = dragMinSnap;
                                  final durMin =
                                      cita.fin.difference(cita.inicio).inMinutes;
                                  final minAbs = _horaIniMin + snap;
                                  final nuevoInicio = DateTime(
                                      widget.fecha.year,
                                      widget.fecha.month,
                                      widget.fecha.day,
                                      minAbs ~/ 60,
                                      minAbs % 60);
                                  final nuevoFin = nuevoInicio
                                      .add(Duration(minutes: durMin));
                                  widget.onMoverCita
                                      ?.call(cita, nuevoInicio, nuevoFin);
                                }
                                setState(() => _citaDrag = null);
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.grab,
                                child: Opacity(
                                  opacity: esDragActual ? 0.4 : 1.0,
                                  child: Card(
                                    color: bg,
                                    elevation: esDragActual ? 2 : 1,
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: scheme.outlineVariant.withValues(alpha: 0.5),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            bg,
                                            bg.withValues(alpha: 0.8),
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              nombreCliente,
                                              style: text.labelMedium?.copyWith(
                                                color: fg,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (nombreServicioYExtras.isNotEmpty)
                                              Text(
                                                nombreServicioYExtras,
                                                style: text.labelSmall?.copyWith(
                                                  color: fg.withValues(alpha: 0.85),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            Text(
                                              horaFormato,
                                              style: text.labelSmall?.copyWith(
                                                color: fg.withValues(alpha: 0.7),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        // ── Previsualización flotante del drag ───────────────
                        if (_citaDrag != null && dragMinSnap != null) ...[
                          () {
                            final citaDrag = _citaDrag!;
                            final snap = dragMinSnap!;
                            final durMin =
                                citaDrag.fin.difference(citaDrag.inicio).inMinutes;
                            final dragTop = _padTop + snap * _alturaPorMin;
                            final dragH =
                                (durMin * _alturaPorMin).clamp(28.0, double.infinity);
                            final minAbs = _horaIniMin + snap;
                            final hIni = minAbs ~/ 60;
                            final mIni = minAbs % 60;
                            final hFin = (minAbs + durMin) ~/ 60;
                            final mFin = (minAbs + durMin) % 60;

                            return Positioned(
                              left: _labelW,
                              right: 16,
                              top: dragTop,
                              height: dragH,
                              child: IgnorePointer(
                                child: Card(
                                  color: scheme.primaryContainer,
                                  elevation: 6,
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                        color: scheme.primary, width: 2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      '${hIni.toString().padLeft(2, '0')}:${mIni.toString().padLeft(2, '0')}'
                                      ' - '
                                      '${hFin.toString().padLeft(2, '0')}:${mFin.toString().padLeft(2, '0')}',
                                      style: text.bodySmall?.copyWith(
                                          color: scheme.onPrimaryContainer),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }(),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NuevaCitaDialog
// ─────────────────────────────────────────────────────────────────────────────

class NuevaCitaDialog extends StatefulWidget {
  final DateTime fecha;
  final TimeOfDay? horaInicial;
  final TimeOfDay? horaFinal;
  final Cita? cita;

  const NuevaCitaDialog({
    super.key,
    required this.fecha,
    this.horaInicial,
    this.horaFinal,
    this.cita,
  });

  @override
  State<NuevaCitaDialog> createState() => _NuevaCitaDialogState();
}

class _NuevaCitaDialogState extends State<NuevaCitaDialog> {
  String? clienteId;
  String? servicioId;
  TimeOfDay? horaInicio;
  TimeOfDay? horaFin;
  String? notas;
  List<String> extrasSeleccionados = [];
  bool pagada = false;
  String? metodoPago;

  @override
  void initState() {
    super.initState();
    if (widget.cita != null) {
      clienteId = widget.cita!.clienteId;
      servicioId = widget.cita!.servicioId;
      horaInicio =
          TimeOfDay(hour: widget.cita!.inicio.hour, minute: widget.cita!.inicio.minute);
      horaFin =
          TimeOfDay(hour: widget.cita!.fin.hour, minute: widget.cita!.fin.minute);
      notas = widget.cita!.notas;
    } else {
      horaInicio = widget.horaInicial ?? const TimeOfDay(hour: 9, minute: 0);
      horaFin = widget.horaFinal ?? TimeOfDay(hour: horaInicio!.hour + 1, minute: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    final clientes = context.read<ClientesProvider>().clientes;
    final servicios = context.read<ServiciosProvider>().servicios;
    final extrasProvider = context.read<ExtrasServicioProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Text(
                  widget.cita == null ? AppLocalizations.of(context).agendaNewAppointment : AppLocalizations.of(context).agendaEditAppointment,
                  style: text.headlineSmall?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: clienteId,
                      items: clientes
                          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre)))
                          .toList(),
                      onChanged: (val) => setState(() => clienteId = val),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).agendaClient,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: servicioId,
                      items: servicios
                          .map((s) => DropdownMenuItem(value: s.id, child: Text(s.nombre)))
                          .toList(),
                      onChanged: (val) => setState(() {
                        servicioId = val;
                        extrasSeleccionados.clear();
                      }),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).agendaService,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                  context: context, initialTime: horaInicio!);
                              if (picked != null) setState(() => horaInicio = picked);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Inicio', style: text.labelSmall),
                                const SizedBox(height: 4),
                                Text(
                                  horaInicio?.format(context) ?? '',
                                  style: text.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                  context: context, initialTime: horaFin!);
                              if (picked != null) setState(() => horaFin = picked);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Fin', style: text.labelSmall),
                                const SizedBox(height: 4),
                                Text(
                                  horaFin?.format(context) ?? '',
                                  style: text.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (servicioId != null) ...[
                      const SizedBox(height: 16),
                      FutureBuilder<List<ExtrasServicioData>>(
                        future: extrasProvider.obtenerExtrasPorServicio(servicioId!),
                        builder: (context, snapshot) {
                          final extras = snapshot.data ?? [];
                          if (extras.isEmpty) return const SizedBox();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Extras disponibles', style: text.labelLarge),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: scheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: extras.asMap().entries.map((entry) {
                                    final extra = entry.value;
                                    final isLast = entry.key == extras.length - 1;
                                    return Column(
                                      children: [
                                        CheckboxListTile(
                                          value: extrasSeleccionados.contains(extra.id),
                                          onChanged: (val) {
                                            setState(() {
                                              if (val == true) {
                                                extrasSeleccionados.add(extra.id);
                                              } else {
                                                extrasSeleccionados.remove(extra.id);
                                              }
                                            });
                                          },
                                          title: Text(
                                            extra.nombre,
                                            style: text.bodyMedium,
                                          ),
                                          subtitle: Text(
                                            '+${context.read<SettingsProvider>().formatCurrency(extra.precio)}',
                                            style: text.labelSmall?.copyWith(
                                              color: scheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                        ),
                                        if (!isLast)
                                          Divider(height: 1, indent: 16, endIndent: 16),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextField(
                      controller: TextEditingController(text: notas ?? ''),
                      onChanged: (v) => notas = v,
                      decoration: InputDecoration(
                        labelText: '${AppLocalizations.of(context).labelNotes} (${AppLocalizations.of(context).actionAccept})',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.cita != null) ...[
                      TextButton(
                        onPressed: () async {
                          final bonosProv = context.read<BonosProvider>();
                          final citasProv = context.read<CitasProvider>();

                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(AppLocalizations.of(context).agendaDeleteAppointment),
                              content: Text(AppLocalizations.of(context).agendaConfirmDelete),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: Text(AppLocalizations.of(context).actionCancel)),
                                TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: Text(AppLocalizations.of(context).actionDelete)),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final citaId = widget.cita!.id;
                            final anio = widget.cita!.inicio.year;
                            await citasProv.eliminarCita(citaId, anio: anio);
                            await bonosProv.eliminarConsumoPorCita(citaId);
                            if (context.mounted) Navigator.pop(context, true);
                          }
                        },
                        child: Text('Eliminar', style: TextStyle(color: scheme.error)),
                      ),
                      const Spacer(),
                    ],
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () async {
                        if (clienteId == null ||
                            servicioId == null ||
                            horaInicio == null ||
                            horaFin == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Faltan datos')),
                          );
                          return;
                        }

                        final inicio = DateTime(widget.fecha.year, widget.fecha.month,
                            widget.fecha.day, horaInicio!.hour, horaInicio!.minute);
                        final fin = DateTime(widget.fecha.year, widget.fecha.month,
                            widget.fecha.day, horaFin!.hour, horaFin!.minute);

                        final servicios = context.read<ServiciosProvider>().servicios;
                        final precioBase =
                            servicios.firstWhere((s) => s.id == servicioId).precio;

                        final citasProv = context.read<CitasProvider>();
                        final bonosProv = context.read<BonosProvider>();

                        double precioFinal = precioBase;
                        String? metodoPagoFinal = metodoPago;

                        final bonoActivo = await bonosProv.bonoActivoPara(clienteId!, servicioId!);
                        final hayBonoDisponible = bonoActivo != null &&
                            (await bonosProv.sesionesAsignadasBono(bonoActivo.id)) <
                                bonoActivo.sesionesTotales;

                        if (hayBonoDisponible) {
                          metodoPagoFinal = 'Bono';
                          precioFinal = 0.0;
                        }

                        final editando = widget.cita != null;
                        String citaId;

                        if (editando) {
                          citaId = widget.cita!.id;
                          await citasProv.actualizarCita(
                            id: citaId,
                            clienteId: clienteId!,
                            servicioId: servicioId!,
                            inicio: inicio,
                            fin: fin,
                            metodoPago: metodoPagoFinal,
                            precio: precioFinal,
                            pagada: (metodoPagoFinal != null && metodoPagoFinal.isNotEmpty),
                            notas: notas,
                          );
                        } else {
                          citaId = await citasProv.insertarCita(
                            clienteId: clienteId!,
                            servicioId: servicioId!,
                            inicio: inicio,
                            fin: fin,
                            precio: precioFinal,
                            metodoPago: metodoPagoFinal,
                            notas: notas,
                            pagada: (metodoPagoFinal != null && metodoPagoFinal.isNotEmpty),
                          );

                          if (hayBonoDisponible) {
                            await bonosProv.consumirSesion(bonoActivo.id, citaId, DateTime.now());
                          }
                        }

                        await citasProv.cargarCitasAnio(widget.fecha.year);
                        if (context.mounted) Navigator.pop(context, true);
                      },
                      child: Text(widget.cita == null ? 'Guardar' : 'Guardar cambios'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
