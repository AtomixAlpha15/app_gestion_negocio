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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateResponsiveMenu());

    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: _extended ? 220 : 72,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
          // Botón hamburguesa
          Padding(
            padding: const EdgeInsets.only(top: 18, left: 10, right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(_extended ? Icons.menu_open : Icons.menu),
                color: theme.colorScheme.primary,
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
                style: theme.textTheme.titleLarge?.copyWith(
                  fontFamily: settings.fuente,
                  fontSize: 22 * settings.tamanoFuente,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
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
            child: settings.logoPath.isEmpty
                ? Icon(Icons.business, size: _extended ? 80 : 36, color: theme.colorScheme.primary)
                : Image.file(
                    File(settings.logoPath),
                    width: _extended ? 200 : 36,
                    height: _extended ? 200 : 36,
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
                  settings: settings,
                ),
                _NavButton(
                  icon: Icons.home_repair_service,
                  label: 'Servicios',
                  selected: widget.selectedIndex == 1,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(1),
                  settings: settings,
                ),
                _NavButton(
                  icon: Icons.calendar_today,
                  label: 'Agenda',
                  selected: widget.selectedIndex == 2,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(2),
                  settings: settings,
                ),
                _NavButton(
                  icon: Icons.account_balance_wallet,
                  label: 'Contabilidad',
                  selected: widget.selectedIndex == 3,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(3),
                  settings: settings,
                ),
                _NavButton(
                  icon: Icons.settings,
                  label: 'Ajustes',
                  selected: widget.selectedIndex == 4,
                  extended: _extended,
                  onTap: () => widget.onDestinationSelected(4),
                  settings: settings,
                ),
              ],
            ),
          ),
          // Botón inferior (usuario - para futuro)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _extended
                ? ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person, color: theme.colorScheme.onPrimary),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    title: Text(
                      "Usuario",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontFamily: settings.fuente,
                        fontSize: 16 * settings.tamanoFuente,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    onTap: () {},
                  )
                : Tooltip(
                    message: "Cuenta de usuario",
                    child: IconButton(
                      icon: Icon(Icons.person, color: theme.colorScheme.primary),
                      onPressed: () {},
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
  final SettingsProvider settings;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.extended,
    required this.onTap,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : theme.iconTheme.color;

    return ListTile(
      leading: Icon(icon, color: color),
      title: extended
          ? Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontFamily: settings.fuente,
                fontSize: 17 * settings.tamanoFuente,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            )
          : null,
      selected: selected,
      selectedTileColor: theme.colorScheme.primary.withOpacity(0.10),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minLeadingWidth: 0,
      dense: true,
    );
  }
}
