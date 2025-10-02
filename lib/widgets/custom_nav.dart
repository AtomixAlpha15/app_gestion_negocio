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
    final selectedBg = _blend(scheme.secondary, railBg, isDark ? 0.35 : 0.18);
    final selectedFg = _onColor(selectedBg);

    return SizedBox(                   // 👈 asegura altura finita
    height: double.infinity,
    child:  AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: _extended ? 220 : 80,
      onEnd: () => setState(() {}), // fuerza un repintado al terminar la animación
      child: Material(
        color: railBg,
        elevation: 3,
        surfaceTintColor: Colors.transparent, // evita tinte M3
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Botón hamburguesa
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 15, right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(_extended ? Icons.menu_open : Icons.menu),
                color: railFg,
                onPressed: () {
                  setState(() {
                    _extended = !_extended;
                    _lastManualExtended = _extended;
                  });
                },
                tooltip: _extended ? "Contraer menú" : "Expandir menú",
              ),
            ),
          ),

          // Nombre de empresa (solo extendido)
          if (_extended) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
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
              ),
            ),
          ],

          // Logo de empresa
          Padding(
            padding: EdgeInsets.only(
              top: _extended ? 0 : 12,
              bottom: 16,
            ),
            child: (() {
              final hasLogo = settings.logoPath.isNotEmpty && File(settings.logoPath).existsSync();
              if (!hasLogo) {
                return Icon(Icons.business, size: _extended ? 80 : 36, color: railFg);
              }
              return Image.file(
                File(settings.logoPath),
                width: _extended ? 200 : 48,
                height: _extended ? 200 : 48,
                fit: BoxFit.contain,
              );
            })(),
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
                  railFg: railFg,
                  selectedBg: selectedBg,
                  selectedFg: selectedFg,
                ),
                _NavButton(
                  icon: Icons.home_repair_service,
                  label: 'Servicios',
                  selected: widget.selectedIndex == 1,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(1),
                  railFg: railFg,
                  selectedBg: selectedBg,
                  selectedFg: selectedFg,
                ),
                _NavButton(
                  icon: Icons.calendar_today,
                  label: 'Agenda',
                  selected: widget.selectedIndex == 2,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(2),
                  railFg: railFg,
                  selectedBg: selectedBg,
                  selectedFg: selectedFg,
                ),
                _NavButton(
                  icon: Icons.account_balance_wallet,
                  label: 'Contabilidad',
                  selected: widget.selectedIndex == 3,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(3),
                  railFg: railFg,
                  selectedBg: selectedBg,
                  selectedFg: selectedFg,
                ),
                _NavButton(
                  icon: Icons.settings,
                  label: 'Ajustes',
                  selected: widget.selectedIndex == 4,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(4),
                  railFg: railFg,
                  selectedBg: selectedBg,
                  selectedFg: selectedFg,
                ),
              ],
            ),
          ),

          // Botón inferior (usuario - futuro)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _extended
                ? ListTile(
                    leading: CircleAvatar(
                      backgroundColor: railFg,
                      child: Icon(Icons.person, color: _onColor(railFg)),
                    ),
                    title: Text(
                      "Usuario",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16 * (settings.tamanoFuente),
                        color: railFg,
                      ),
                    ),
                    onTap: () {},
                  )
                : Tooltip(
                    message: "Cuenta de usuario",
                    child: IconButton(
                      icon: Icon(Icons.person, color: railFg),
                      onPressed: () {},
                    ),
                  ),
          ),
        ],
      ),
    )));
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;

  // Colores inyectados para garantizar contraste con el rail
  final Color railFg;     // Texto/ícono normal sobre rail
  final Color selectedBg; // Fondo del tile seleccionado
  final Color selectedFg; // Texto/ícono del tile seleccionado

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.extended,
    required this.onTap,
    required this.railFg,
    required this.selectedBg,
    required this.selectedFg,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: selected ? selectedFg : railFg.withOpacity(0.90)),
      title: extended
          ? Text(
              label,
              style: TextStyle(
                color: selected ? selectedFg : railFg.withOpacity(0.95),
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            )
          : null,
      selected: selected,
      selectedTileColor: selectedBg,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minLeadingWidth: 0,
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
