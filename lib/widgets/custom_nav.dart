import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'dart:io';

// Custom Navigation Rail (responsive, animado, logo y nombre de empresa)
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
  bool _extended = false;           // Estado actual del menú (expandido)
  bool _lastManualExtended = false; // Último estado manual recordado
  bool _autoCollapsed = false;      // Si está colapsado por ventana pequeña

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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateResponsiveMenu());

    final settings = context.watch<SettingsProvider>();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: _extended ? 220 : 72,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Botón hamburguesa para expandir/colapsar
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 10, right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(_extended ? Icons.menu_open : Icons.menu),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                settings.nombreEmpresa,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              left: 0,
              right: 0,
            ),
            child: settings.logoPath.isEmpty
                ? Icon(Icons.business, size: _extended ? 64 : 36)
                : Image.file(
                    File(settings.logoPath),
                    width: _extended ? 64 : 36,
                    height: _extended ? 64 : 36,
                    fit: BoxFit.contain,
                  ),
          ),

          // Botones de navegación
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _NavButton(
                  icon: Icons.people,
                  label: 'Clientes',
                  selected: widget.selectedIndex == 0,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(0),
                ),
                _NavButton(
                  icon: Icons.home_repair_service,
                  label: 'Servicios',
                  selected: widget.selectedIndex == 1,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(1),
                ),
                _NavButton(
                  icon: Icons.calendar_today,
                  label: 'Agenda',
                  selected: widget.selectedIndex == 2,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(2),
                ),
                _NavButton(
                  icon: Icons.account_balance_wallet,
                  label: 'Contabilidad',
                  selected: widget.selectedIndex == 3,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(3),
                ),
                _NavButton(
                  icon: Icons.settings,
                  label: 'Ajustes',
                  selected: widget.selectedIndex == 4,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(4),
                ),
              ],
            ),
          ),

          // Botón inferior (usuario - para futuro)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _extended
                ? ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: const Text("Usuario"),
                    onTap: () {
                      // Lógica futura de ajustes de usuario
                    },
                  )
                : Tooltip(
                    message: "Cuenta de usuario",
                    child: IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {
                        // Lógica futura
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// Botón personalizado de navegación lateral
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.extended,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).iconTheme.color;

    return ListTile(
      leading: Icon(icon, color: color),
      title: extended ? Text(label, style: TextStyle(color: color)) : null,
      selected: selected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.10),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minLeadingWidth: 0,
      dense: true,
    );
  }
}
