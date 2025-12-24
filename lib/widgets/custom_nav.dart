import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'dart:io';

class CustomNavigationRail extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const CustomNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  bool _extended = false;
  bool _lastManualExtended = false;
  bool _autoCollapsed = false;
  bool _showLabels = false;

  void _updateResponsiveMenu() {
    final width = MediaQuery.of(context).size.width;
    if (width < 900 && !_autoCollapsed) {
      setState(() {
        _autoCollapsed = true;
        _lastManualExtended = _extended;
        _extended = false;
      });
    } else if (width >= 900 && _autoCollapsed) {
      setState(() {
        _autoCollapsed = false;
        _extended = _lastManualExtended;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateResponsiveMenu());
  }

  // Utils de color
  Color _blend(Color fg, Color bg, double opacity) {
    return Color.alphaBlend(fg.withOpacity(opacity), bg);
  }

  Color _onColor(Color bg) {
    // Contraste simple: luminancia
    return bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    //WidgetsBinding.instance.addPostFrameCallback((_) => _updateResponsiveMenu());

    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Fondo del rail: mezclar colorBase con surface para que armonice con el tema
    // (más opacidad en dark para que se note)
    final railBg = _blend(settings.colorBase, scheme.surface, isDark ? 0.22 : 0.50);
    final railFg = _onColor(railBg);

    // Estado seleccionado: fondo derivado del secundario para contraste sobre el rail
    final hoverBg = _blend(
      scheme.secondary,
      railBg,
      isDark ? 0.28 : 0.14,
    );

    final selectedBg = _blend(
      scheme.secondary,
      railBg,
      isDark ? 0.55 : 0.32,
    );
    final selectedFg = _onColor(selectedBg);

return Padding(
  padding: const EdgeInsets.all(12), // separa del borde de pantalla
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    width: _extended ? 220 : 80,
    onEnd: () {
      setState(() {
        _showLabels = _extended; // ✅ al terminar, si está expandido, mostramos
      });
    },
    child: Material(
      color: railBg,
      elevation: 10, // dejamos la sombra a BoxShadow (más control)
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.35 : 0.10),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Botón hamburguesa
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 18, right: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(_extended ? Icons.menu_open : Icons.menu),
                color: railFg,
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return scheme.secondary.withOpacity(0.10); // 👈 sin hover permanente
                    }
                    if (states.contains(WidgetState.focused)) {
                      return Colors.transparent; // 👈 quita el focus persistente
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return scheme.secondary.withOpacity(0.12); // click sutil (opcional)
                    }
                    return Colors.transparent;
                  }),
                ),
                onPressed: () {
                  setState(() {
                    _extended = !_extended;
                    _lastManualExtended = _extended;
                    if (!_extended) _showLabels = false;
                  });
                },
                tooltip: _extended ? "Contraer menú" : "Expandir menú",
              ),

            ),
          ),

          const SizedBox(height: 10),

          // Logo de empresa (suave: scale + fade, sin saltos de tamaño)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: () {
              final hasLogo =
                  settings.logoPath.isNotEmpty && File(settings.logoPath).existsSync();

              const double boxSize = 96; // 👈 tamaño afinado para rail flotante

              final Widget content = hasLogo
                  ? Image.file(
                      File(settings.logoPath),
                      width: boxSize,
                      height: boxSize,
                      fit: BoxFit.contain,
                    )
                  : Icon(
                      Icons.business,
                      size: 42,
                      color: railFg,
                    );

              return SizedBox(
                width: boxSize,
                height: boxSize,
                child: Center(
                  child: AnimatedScale(
                    scale: _extended ? 1.2 : 0.60,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    child: AnimatedOpacity(
                      opacity: _extended ? 1.0 : 0.85,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      child: content,
                    ),
                  ),
                ),
              );
            }(),
          ),

          // Nombre de empresa (sin empujar el layout)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              height: 44, // 👈 reserva altura fija (ajusta 40–52 según tu fuente)
              child: Center(
                child: AnimatedOpacity(
                  opacity: _showLabels ? 1 : 0,
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  child: AnimatedScale(
                    scale: _showLabels ? 1.0 : 0.98,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    child: Text(
                      settings.nombreEmpresa,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: settings.fuente,
                        fontSize: 22 * settings.tamanoFuente,
                        fontWeight: FontWeight.bold,
                        color: railFg,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Botones de navegación
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 8,right: 8),
              children: [
                _NavButton(
                  icon: Icons.people,
                  label: 'Clientes',
                  selected: widget.selectedIndex == 0,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(0),
                  showLabels: _showLabels,
                  railFg: railFg,
                  selectedBg: selectedBg,
                  hoverBg: hoverBg,
                  selectedFg: selectedFg,
                ),
                _NavButton(
                  icon: Icons.home_repair_service,
                  label: 'Servicios',
                  selected: widget.selectedIndex == 1,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(1),
                  showLabels: _showLabels,
                  railFg: railFg,
                  selectedBg: selectedBg,
                  hoverBg: hoverBg,
                  selectedFg: selectedFg,
                ),
                _NavButton(
                  icon: Icons.calendar_today,
                  label: 'Agenda',
                  selected: widget.selectedIndex == 2,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(2),
                  showLabels: _showLabels,
                  railFg: railFg,
                  selectedBg: selectedBg,
                  hoverBg: hoverBg,
                  selectedFg: selectedFg,
                ),
                _NavButton(
                  icon: Icons.account_balance_wallet,
                  label: 'Contabilidad',
                  selected: widget.selectedIndex == 3,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(3),
                  showLabels: _showLabels,
                  railFg: railFg,
                  selectedBg: selectedBg,
                  hoverBg: hoverBg,
                  selectedFg: selectedFg,
                ),
                _NavButton(
                  icon: Icons.settings,
                  label: 'Ajustes',
                  selected: widget.selectedIndex == 4,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(4),
                  showLabels: _showLabels,
                  railFg: railFg,
                  selectedBg: selectedBg,
                  hoverBg: hoverBg,
                  selectedFg: selectedFg,
                ),
              ],
            ),
          ),

          // Botón inferior (usuario - futuro)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    // Icono/Avatar siempre visible
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: railFg,
                      child: Icon(Icons.person, color: _onColor(railFg), size: 18),
                    ),
                    const SizedBox(width: 12),

                    // Texto solo cuando _showLabels == true (no cuando _extended empieza)
                    Expanded(
                      child: ClipRect(
                        child: AnimatedAlign(
                          alignment: Alignment.centerLeft,
                          duration: const Duration(milliseconds: 160),
                          curve: Curves.easeOut,
                          widthFactor: _showLabels ? 1 : 0,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 120),
                            opacity: _showLabels ? 1 : 0,
                            child: Text(
                              "Usuario",
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 16 * (settings.tamanoFuente),
                                color: railFg,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tooltip solo cuando está colapsado
                    if (!_showLabels)
                      Tooltip(
                        message: "Cuenta de usuario",
                        child: Icon(Icons.info_outline, color: railFg.withOpacity(0.7), size: 18),
                      ),
                  ],
                ),
              ),
            ),
          ),

          ),
        ],
      ),
        ),
      ),
    ),
  );

  }
}

class _NavButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool extended; // lo puedes mantener aunque ya no lo uses
  final VoidCallback onTap;
  final bool showLabels;

  final Color railFg;
  final Color selectedBg;
  final Color hoverBg;
  final Color selectedFg;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.extended,
    required this.onTap,
    required this.showLabels,
    required this.railFg,
    required this.selectedBg,
    required this.hoverBg,
    required this.selectedFg,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hover = false;

  bool get _enableHover {
    final p = Theme.of(context).platform;
    return p == TargetPlatform.windows ||
        p == TargetPlatform.macOS ||
        p == TargetPlatform.linux;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fg = widget.selected
        ? widget.selectedFg
        : widget.railFg.withOpacity(0.8);

    // Fondo:
    // - seleccionado: tu selectedBg
    // - hover (no seleccionado): un toque del selectedBg
    final Color bg = widget.selected
        ? widget.selectedBg
        : (_hover ? widget.hoverBg : Colors.transparent);


    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _enableHover ? (_) => setState(() => _hover = true) : null,
      onExit: _enableHover ? (_) => setState(() => _hover = false) : null,
      child: Material(
        color: bg, // 👈 el fondo va aquí
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias, // 👈 AQUÍ es donde va
        child: ListTile(
          leading: AnimatedScale(
            scale: _hover ? 1.2 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: Icon(widget.icon, color: fg),
          ),

          title: ClipRect(
            child: AnimatedAlign(
              alignment: Alignment.centerLeft,
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              widthFactor: widget.showLabels ? 1 : 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 120),
                opacity: widget.showLabels ? 1 : 0,
                child: Text(
                  widget.label,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: fg,
                    fontWeight: widget.selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),

          onTap: widget.onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          minLeadingWidth: 0,
          dense: true,

          // ya no usamos estos
          selected: false,
          selectedTileColor: Colors.transparent,
        ),
      ),
    );


  }
}

