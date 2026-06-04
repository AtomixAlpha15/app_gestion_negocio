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
import '../utils/responsive.dart';
import '../widgets/custom_nav.dart';

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
  late SettingsProvider _settingsRef;

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
    _settingsRef = context.read<SettingsProvider>();
    cargarCitasDia();
    context.read<ServiciosProvider>().cargarServicios();
    context.read<ClientesProvider>().cargarClientes();
    // Recargar citas al cambiar de local activo
    _settingsRef.addListener(_onSettingsChanged);
  }

  void _onSettingsChanged() => cargarCitasDia();

  @override
  void dispose() {
    _settingsRef.removeListener(_onSettingsChanged);
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
    final settings = context.read<SettingsProvider>();
    final db = extrasProvider.db;
    final serviciosMap = {for (var s in serviciosProvider.servicios) s.id: s.nombre};
    final estId = settings.establecimientoActualId.isNotEmpty
        ? settings.establecimientoActualId
        : null;

    final fechaDer = fechaSeleccionada.add(const Duration(days: 1));
    final results = await Future.wait([
      provider.obtenerCitasPorDia(fechaSeleccionada, establecimientoId: estId),
      provider.obtenerCitasPorDia(fechaDer, establecimientoId: estId),
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

  Future<void> _abrirDialogoCrear(DateTime inicio, DateTime fin, int trabajador) async {
    final settings = context.read<SettingsProvider>();
    final estId = settings.establecimientoActualId.isNotEmpty
        ? settings.establecimientoActualId
        : null;
    final result = await showDialog(
      context: context,
      builder: (_) => NuevaCitaDialog(
        fecha: inicio,
        horaInicial: TimeOfDay(hour: inicio.hour, minute: inicio.minute),
        horaFinal: TimeOfDay(hour: fin.hour, minute: fin.minute),
        trabajador: trabajador,
        numTrabajadores: settings.numeroEmpleados,
        establecimientoId: estId,
        nombresEmpleados: settings.nombresEmpleados,
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
      trabajador: cita.trabajador,
      establecimientoId: cita.establecimientoId,
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
    final settings = context.read<SettingsProvider>();
    final numT = settings.numeroEmpleados;
    return AgendaVisual(
      fecha: fecha,
      horaInicio: horaInicio,
      horaFin: horaFin,
      citas: citas,
      servicioYExtrasPorCita: extras,
      zoom: _zoom,
      onZoomChanged: (z) => setState(() => _zoom = z),
      scrollController: scroll,
      numTrabajadores: numT,
      nombresEmpleados: settings.nombresEmpleados,
      onEditarCita: (cita) async {
        final result = await showDialog(
          context: context,
          builder: (_) => NuevaCitaDialog(
            fecha: cita.inicio,
            cita: cita,
            numTrabajadores: numT,
            nombresEmpleados: settings.nombresEmpleados,
          ),
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
    final mobile = isMobile(context);

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
                        if (!mobile)
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
          if (!mobile) ...[
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
          ],
          const SizedBox(width: 16),
          const UserAvatarAction(),
        ],
      ),
      body: cargandoCitas
          ? const Center(child: CircularProgressIndicator())
          : mobile
              ? Column(
                  children: [
                    _DiaHeader(fecha: fechaSeleccionada),
                    Expanded(
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (_zoom == 1.0 && details.primaryVelocity != null) {
                            if (details.primaryVelocity! < -500) {
                              cambiarFecha(fechaSeleccionada.add(const Duration(days: 1)));
                            } else if (details.primaryVelocity! > 500) {
                              cambiarFecha(fechaSeleccionada.subtract(const Duration(days: 1)));
                            }
                          }
                        },
                        child: _panel(fechaSeleccionada, _citasIzq, _extrasIzq, _scrollIzq),
                      ),
                    ),
                  ],
                )
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
          final settings = context.read<SettingsProvider>();
          final estId = settings.establecimientoActualId;
          final result = await showDialog(
            context: context,
            builder: (_) => NuevaCitaDialog(
              fecha: fechaSeleccionada,
              horaInicial: horaInicio,
              establecimientoId: estId.isNotEmpty ? estId : null,
              nombresEmpleados: settings.nombresEmpleados,
            ),
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
    final esFinDeSemana = fecha.weekday == DateTime.saturday || fecha.weekday == DateTime.sunday;
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
            : esFinDeSemana
                ? scheme.tertiaryContainer.withValues(alpha: 0.35)
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
  final void Function(DateTime inicio, DateTime fin, int trabajador)? onCrearCita;
  final void Function(Cita cita, DateTime nuevoInicio, DateTime nuevoFin)? onMoverCita;
  final double zoom;
  final ValueChanged<double>? onZoomChanged;
  final ScrollController? scrollController;
  final int numTrabajadores;
  final List<String> nombresEmpleados;

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
    this.numTrabajadores = 1,
    this.nombresEmpleados = const [],
  });

  @override
  State<AgendaVisual> createState() => _AgendaVisualState();
}

class _AgendaVisualState extends State<AgendaVisual> {
  static const double _labelWDesktop = 88.0;
  static const double _labelWMobile = 52.0;
  static const double _padTopDesktop = 16.0;
  static const double _padTopMultiDesktop = 36.0;
  static const double _padTopMobile = 48.0;
  static const double _padBot = 64.0;

  // Actualizado en build() según plataforma; leído en callbacks de gestos
  double _padTop = _padTopDesktop;
  static const int _hoverDurMin = 60;

  // Hover preview state (desktop)
  double? _hoverY;
  int _hoverColumna = 1;
  bool _sobreVacio = false;

  // Tap preview state (mobile)
  double? _tapPreviewY;
  DateTime? _tapPreviewInicio;
  DateTime? _tapPreviewFin;
  int _tapPreviewTrabajador = 1;

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
  double _colW = 0; // ancho de cada columna de trabajador; 0 = modo single

  int _snapMin(double minutos) => (minutos / 30).round() * 30;

  int _columnaDesdeX(double x, double labelW) {
    if (_colW <= 0 || widget.numTrabajadores <= 1) return 1;
    final col = ((x - labelW) / _colW).floor() + 1;
    return col.clamp(1, widget.numTrabajadores);
  }

  bool _esSobreCitaEnColumna(double y, int columna) {
    final minAbsoluto = _horaIniMin + (y - _padTop) / _alturaPorMin;
    for (final cita in widget.citas) {
      if (cita.id == _citaDrag?.id) continue;
      if (widget.numTrabajadores > 1 && cita.trabajador != columna) continue;
      final ini = cita.inicio.hour * 60.0 + cita.inicio.minute;
      final fin = cita.fin.hour * 60.0 + cita.fin.minute;
      if (minAbsoluto > ini && minAbsoluto < fin) return true;
    }
    return false;
  }

  bool _esSobreCita(double y) => _esSobreCitaEnColumna(y, 1);

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
    final mobile = isMobile(context);
    final labelW = mobile ? _labelWMobile : _labelWDesktop;
    final multiAgenda = widget.numTrabajadores > 1;
    _padTop = mobile ? _padTopMobile : (multiAgenda ? _padTopMultiDesktop : _padTopDesktop);

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
              _colW = multiAgenda
                  ? (constraints.maxWidth - labelW) / widget.numTrabajadores
                  : 0;

              final horas = List.generate(
                widget.horaFin.hour - widget.horaInicio.hour + 1,
                (i) => widget.horaInicio.hour + i,
              );

              // ── Calcular previsualización hover (desktop) ─────────────────
              DateTime? hoverInicio;
              DateTime? hoverFin;
              if (!mobile && _hoverY != null && _sobreVacio) {
                final minRaw = (_hoverY! - _padTop) / _alturaPorMin;
                final minSnap =
                    _snapMin(minRaw - _hoverDurMin / 2).clamp(0, _minutosTotales - _hoverDurMin);
                final minAbs = _horaIniMin + minSnap;
                hoverInicio = DateTime(widget.fecha.year, widget.fecha.month,
                    widget.fecha.day, minAbs ~/ 60, minAbs % 60);
                hoverFin = hoverInicio.add(const Duration(hours: 1));
              }

              // ── Previsualización tap (móvil) ──────────────────────────────
              // _tapPreviewInicio/_tapPreviewFin ya calculados en el handler

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

              Widget stack = Stack(
                children: [
                  // ── Cabeceras de trabajadores (multi-agenda desktop) ───────
                  if (multiAgenda) ...[
                    for (int w = 1; w <= widget.numTrabajadores; w++)
                      Positioned(
                        left: labelW + (w - 1) * _colW,
                        width: _colW,
                        top: 0,
                        height: _padTop,
                        child: Center(
                          child: Text(
                            widget.nombresEmpleados.isNotEmpty && w <= widget.nombresEmpleados.length
                                ? widget.nombresEmpleados[w - 1]
                                : 'T$w',
                            style: text.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ),
                    for (int w = 1; w < widget.numTrabajadores; w++)
                      Positioned(
                        left: labelW + w * _colW,
                        top: 0,
                        bottom: 0,
                        width: 1,
                        child: Container(color: scheme.outlineVariant),
                      ),
                  ],

                  // ── Líneas de horas ────────────────────────────────────────
                  ...horas.expand((h) {
                    final top = _padTop +
                        (h - widget.horaInicio.hour) * 60 * _alturaPorMin;
                    return [
                      Positioned(
                        top: top,
                        left: labelW,
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
                        width: labelW - 4,
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

                  // ── Previsualización hover desktop ─────────────────────────
                  if (!mobile && hoverInicio != null && hoverFin != null) ...[
                    () {
                      final ini = hoverInicio!;
                      final fin = hoverFin!;
                      final minDesde = (ini.hour * 60 + ini.minute) - _horaIniMin;
                      final top = _padTop + minDesde * _alturaPorMin;
                      final height = _hoverDurMin * _alturaPorMin;
                      final hLeft = multiAgenda
                          ? labelW + (_hoverColumna - 1) * _colW + 2
                          : labelW;
                      final hWidth = multiAgenda ? _colW - 4 : null;
                      final hRight = multiAgenda ? null : 8.0;
                      return Positioned(
                        left: hLeft,
                        width: hWidth,
                        right: hRight,
                        top: top,
                        height: height,
                        child: GestureDetector(
                          onTap: () => widget.onCrearCita?.call(ini, fin, _hoverColumna),
                          child: Container(
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.15),
                              border: Border.all(
                                color: scheme.primary.withValues(alpha: 0.6),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: LayoutBuilder(
                              builder: (_, c) => c.maxHeight < 40
                                  ? Center(
                                      child: Icon(Icons.add_circle_outline,
                                          color: scheme.primary, size: 18),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_circle_outline,
                                            color: scheme.primary, size: 28),
                                        if (c.maxHeight >= 60) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            'Nueva cita',
                                            style: text.labelSmall?.copyWith(
                                              color: scheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      );
                    }(),
                  ],

                  // ── Previsualización tap móvil ─────────────────────────────
                  if (mobile && _tapPreviewInicio != null && _tapPreviewFin != null) ...[
                    () {
                      final ini = _tapPreviewInicio!;
                      final fin = _tapPreviewFin!;
                      final minDesde = (ini.hour * 60 + ini.minute) - _horaIniMin;
                      final top = _padTop + minDesde * _alturaPorMin;
                      final height = _hoverDurMin * _alturaPorMin;
                      return Positioned(
                        left: labelW,
                        right: 8,
                        top: top,
                        height: height,
                        child: GestureDetector(
                          onTap: () {
                            widget.onCrearCita?.call(ini, fin, _tapPreviewTrabajador);
                            setState(() {
                              _tapPreviewY = null;
                              _tapPreviewInicio = null;
                              _tapPreviewFin = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.18),
                              border: Border.all(
                                color: scheme.primary.withValues(alpha: 0.7),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: scheme.primary, size: 22),
                                const SizedBox(width: 6),
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

                  // ── Bloques de citas ───────────────────────────────────────
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
                        ? scheme.tertiaryContainer.withValues(alpha: 0.60)
                        : scheme.secondaryContainer.withValues(alpha: 0.60);
                    final Color fg = impagada
                        ? scheme.onTertiaryContainer
                        : scheme.onSecondaryContainer;

                    final bool esDragActual = _citaDrag?.id == cita.id;
                    final horaFormato =
                        '${cita.inicio.hour.toString().padLeft(2, '0')}:${cita.inicio.minute.toString().padLeft(2, '0')}'
                        ' - '
                        '${cita.fin.hour.toString().padLeft(2, '0')}:${cita.fin.minute.toString().padLeft(2, '0')}';

                    final int w = cita.trabajador.clamp(1, widget.numTrabajadores);
                    final cLeft = multiAgenda ? labelW + (w - 1) * _colW + 2 : labelW;
                    final cWidth = multiAgenda ? _colW - 4 : null;
                    final cRight = multiAgenda ? null : 8.0;

                    return Positioned(
                      left: cLeft,
                      width: cWidth,
                      right: cRight,
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
                            _tapPreviewY = null;
                            _tapPreviewInicio = null;
                            _tapPreviewFin = null;
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
                              color: Colors.transparent,
                              elevation: esDragActual ? 2 : 1,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: scheme.outlineVariant,
                                  width: 1.5,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [bg, bg.withValues(alpha: 0.45)],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  child: Builder(
                                    builder: (ctx) {
                                      final narrowWidth = cWidth ?? 80;
                                      final hora = horaFormato.split(' - ')[0];

                                      // Tres niveles de layout según espacio disponible
                                      if (narrowWidth < 60) {
                                        // Muy estrecho: solo hora
                                        return Center(
                                          child: Text(
                                            hora,
                                            style: text.labelSmall?.copyWith(
                                              color: fg,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      } else if (narrowWidth < 100) {
                                        // Estrecho: cliente sobre hora
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                nombreCliente,
                                                style: text.labelSmall?.copyWith(
                                                  color: fg,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              hora,
                                              style: text.labelSmall?.copyWith(
                                                color: fg.withValues(alpha: 0.7),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 8,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        );
                                      } else if (narrowWidth < 160) {
                                        // Medio: cliente / servicio+hora
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                nombreCliente,
                                                style: text.labelSmall?.copyWith(
                                                  color: fg,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                nombreServicioYExtras.isNotEmpty
                                                    ? '$nombreServicioYExtras • $hora'
                                                    : hora,
                                                style: text.labelSmall?.copyWith(
                                                  color: fg.withValues(alpha: 0.75),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 8,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      // Ancho: todo en línea
                                      return Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              nombreCliente,
                                              style: text.labelSmall?.copyWith(
                                                color: fg,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (nombreServicioYExtras.isNotEmpty) ...[
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                nombreServicioYExtras,
                                                style: text.labelSmall?.copyWith(
                                                  color: fg.withValues(alpha: 0.85),
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(width: 6),
                                          Text(
                                            hora,
                                            style: text.labelSmall?.copyWith(
                                              color: fg.withValues(alpha: 0.7),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

                  // ── Previsualización flotante del drag ─────────────────────
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

                      final int dw = citaDrag.trabajador.clamp(1, widget.numTrabajadores);
                      final dLeft = multiAgenda ? labelW + (dw - 1) * _colW + 2 : labelW;
                      final dWidth = multiAgenda ? _colW - 4 : null;
                      final dRight = multiAgenda ? null : 8.0;

                      return Positioned(
                        left: dLeft,
                        width: dWidth,
                        right: dRight,
                        top: dragTop,
                        height: dragH,
                        child: IgnorePointer(
                          child: Card(
                            color: scheme.primaryContainer,
                            elevation: 6,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: scheme.primary, width: 2),
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
              );

              // En móvil envolvemos el Stack con GestureDetector para el tap
              if (mobile) {
                stack = GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapUp: (details) {
                    final y = details.localPosition.dy;
                    final x = details.localPosition.dx;
                    if (x <= labelW || y <= _padTop || y >= totalH - _padBot) {
                      setState(() {
                        _tapPreviewY = null;
                        _tapPreviewInicio = null;
                        _tapPreviewFin = null;
                      });
                      return;
                    }
                    if (_esSobreCita(y)) return;

                    // Si ya hay preview y se toca dentro de él → abrir diálogo
                    if (_tapPreviewInicio != null) {
                      final previewMinDesde =
                          (_tapPreviewInicio!.hour * 60 + _tapPreviewInicio!.minute) -
                              _horaIniMin;
                      final previewTop = _padTop + previewMinDesde * _alturaPorMin;
                      final previewBot = previewTop + _hoverDurMin * _alturaPorMin;
                      if (y >= previewTop && y <= previewBot) {
                        widget.onCrearCita?.call(_tapPreviewInicio!, _tapPreviewFin!, _tapPreviewTrabajador);
                        setState(() {
                          _tapPreviewY = null;
                          _tapPreviewInicio = null;
                          _tapPreviewFin = null;
                        });
                        return;
                      }
                    }

                    // Primer toque (o toque fuera del preview anterior): mostrar preview
                    final minRaw = (y - _padTop) / _alturaPorMin;
                    final minSnap = _snapMin(minRaw - _hoverDurMin / 2)
                        .clamp(0, _minutosTotales - _hoverDurMin);
                    final minAbs = _horaIniMin + minSnap;
                    final ini = DateTime(widget.fecha.year, widget.fecha.month,
                        widget.fecha.day, minAbs ~/ 60, minAbs % 60);
                    setState(() {
                      _tapPreviewY = y;
                      _tapPreviewInicio = ini;
                      _tapPreviewFin = ini.add(const Duration(hours: 1));
                    });
                  },
                  child: stack,
                );
              }

              return SingleChildScrollView(
                controller: widget.scrollController,
                child: SizedBox(
                  height: totalH,
                  child: mobile
                      ? stack
                      : MouseRegion(
                          onHover: (event) {
                            final y = event.localPosition.dy;
                            final x = event.localPosition.dx;
                            final enZona = x > labelW &&
                                y > _padTop &&
                                y < totalH - _padBot;
                            setState(() {
                              if (enZona && _citaDrag == null) {
                                _hoverY = y;
                                _hoverColumna = _columnaDesdeX(x, labelW);
                                _sobreVacio = !_esSobreCitaEnColumna(y, _hoverColumna);
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
                          child: stack,
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
  final int trabajador;
  final int numTrabajadores;
  final String? establecimientoId;
  final List<String> nombresEmpleados;

  const NuevaCitaDialog({
    super.key,
    required this.fecha,
    this.horaInicial,
    this.horaFinal,
    this.cita,
    this.trabajador = 1,
    this.numTrabajadores = 1,
    this.establecimientoId,
    this.nombresEmpleados = const [],
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
  int _trabajador = 1;

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
      metodoPago = widget.cita!.metodoPago;
      pagada = widget.cita!.pagada;
      _trabajador = widget.cita!.trabajador;
    } else {
      horaInicio = widget.horaInicial ?? const TimeOfDay(hour: 9, minute: 0);
      horaFin = widget.horaFinal ?? TimeOfDay(hour: horaInicio!.hour + 1, minute: 0);
      _trabajador = widget.trabajador;
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
                    if (widget.numTrabajadores > 1) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text('Trabajador:', style: text.labelMedium),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(widget.numTrabajadores, (i) {
                                  final w = i + 1;
                                  final sel = _trabajador == w;
                                  final label = widget.nombresEmpleados.isNotEmpty && w <= widget.nombresEmpleados.length
                                      ? widget.nombresEmpleados[w - 1]
                                      : 'T$w';
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      label: Text(label),
                                      selected: sel,
                                      onSelected: (_) => setState(() => _trabajador = w),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
                            trabajador: _trabajador,
                            establecimientoId: widget.cita!.establecimientoId ?? widget.establecimientoId,
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
                            trabajador: _trabajador,
                            establecimientoId: widget.establecimientoId,
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
