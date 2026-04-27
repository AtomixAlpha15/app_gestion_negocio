import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_localizations.dart';
import 'dart:io';

const double _kCollapsedWidth = 72.0;
const double _kExpandedWidth = 240.0;
const double _kIconSize = 22.0;
const double _kIconAreaWidth = 48.0; // ancho fijo reservado para el icono

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

  Color _blend(Color fg, Color bg, double opacity) =>
      Color.alphaBlend(fg.withValues(alpha: opacity), bg);

  Color _onColor(Color bg) =>
      bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    final railBg = _blend(settings.colorBase, scheme.surface, isDark ? 0.22 : 0.50);
    final railFg = _onColor(railBg);
    final hoverBg = _blend(scheme.secondary, railBg, isDark ? 0.28 : 0.14);
    final selectedBg = _blend(scheme.secondary, railBg, isDark ? 0.55 : 0.32);
    final selectedFg = _onColor(selectedBg);

    final destinations = [
      (Icons.dashboard_rounded, l.navDashboard),
      (Icons.people_rounded, l.navClientes),
      (Icons.handyman_rounded, l.navServicios),
      (Icons.calendar_month_rounded, l.navAgenda),
      (Icons.wallet_rounded, l.navContabilidad),
      (Icons.settings_rounded, l.navAjustes),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        width: _extended ? _kExpandedWidth : _kCollapsedWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              railBg.withValues(alpha: 0.95),
              railBg.withValues(alpha: 0.88),
            ],
          ),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // — Header con botón toggle —
            SizedBox(
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Texto "Menú" alineado a la izquierda, sólo visible expandido
                  Positioned(
                    left: _kIconAreaWidth / 2 + (_kCollapsedWidth - _kIconAreaWidth) / 2 + 8,
                    child: AnimatedOpacity(
                      opacity: _extended ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        AppLocalizations.of(context).navMenu,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: railFg.withValues(alpha: 0.7),
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Botón toggle, siempre centrado en la columna de iconos
                  Positioned(
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: scheme.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            _extended ? Icons.menu_open_rounded : Icons.menu_rounded,
                            key: ValueKey(_extended),
                            color: railFg,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _extended = !_extended;
                            _lastManualExtended = _extended;
                          });
                        },
                        tooltip: _extended
                          ? AppLocalizations.of(context).navMenuCollapse
                          : AppLocalizations.of(context).navMenuExpand,
                        constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
                        splashRadius: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // — Logo —
            _LogoSection(
              extended: _extended,
              settings: settings,
              scheme: scheme,
              theme: theme,
              railFg: railFg,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Divider(color: scheme.outlineVariant.withValues(alpha: 0.2), height: 1),
            ),

            // — Items de navegación —
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 6),
                children: [
                  for (var i = 0; i < destinations.length; i++)
                    _NavItem(
                      icon: destinations[i].$1,
                      label: destinations[i].$2,
                      selected: widget.selectedIndex == i,
                      extended: _extended,
                      onTap: () => widget.onDestinationSelected(i),
                      railFg: railFg,
                      selectedBg: selectedBg,
                      hoverBg: hoverBg,
                      selectedFg: selectedFg,
                      scheme: scheme,
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Divider(color: scheme.outlineVariant.withValues(alpha: 0.2), height: 1),
            ),

            // — Usuario —
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
              child: _UserChip(extended: _extended, railFg: railFg, scheme: scheme, theme: theme, settings: settings),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Logo ────────────────────────────────────────────────────────────────────

class _LogoSection extends StatelessWidget {
  final bool extended;
  final SettingsProvider settings;
  final ColorScheme scheme;
  final ThemeData theme;
  final Color railFg;

  const _LogoSection({
    required this.extended,
    required this.settings,
    required this.scheme,
    required this.theme,
    required this.railFg,
  });

  Color _onColor(Color bg) =>
      bg.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    final hasLogo = settings.logoPath.isNotEmpty && File(settings.logoPath).existsSync();
    const double size = 52;

    final logo = SizedBox(
      width: size,
      height: size,
      child: hasLogo
          ? Image.file(File(settings.logoPath), fit: BoxFit.contain)
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [scheme.primary, scheme.primary.withValues(alpha: 0.7)],
                ),
              ),
              child: Icon(Icons.business_rounded, size: 26, color: scheme.onPrimary),
            ),
    );

    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: extended ? 1.0 : 0.68,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: logo,
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            firstCurve: Curves.easeIn,
            secondCurve: Curves.easeOut,
            crossFadeState: extended ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Text(
              settings.nombreEmpresa,
              style: theme.textTheme.labelLarge?.copyWith(
                fontFamily: settings.fuente,
                fontSize: 13 * settings.tamanoFuente,
                fontWeight: FontWeight.w700,
                color: _onColor(settings.colorBase),
                letterSpacing: 0.3,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            secondChild: const SizedBox(height: 18),
          ),
        ],
      ),
    );
  }
}

// ─── Nav Item ────────────────────────────────────────────────────────────────

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;
  final Color railFg;
  final Color selectedBg;
  final Color hoverBg;
  final Color selectedFg;
  final ColorScheme scheme;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.extended,
    required this.onTap,
    required this.railFg,
    required this.selectedBg,
    required this.hoverBg,
    required this.selectedFg,
    required this.scheme,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hover = false;

  bool get _isDesktop {
    final p = Theme.of(context).platform;
    return p == TargetPlatform.windows || p == TargetPlatform.macOS || p == TargetPlatform.linux;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = widget.selected ? widget.selectedFg : widget.railFg.withValues(alpha: 0.8);
    final bg = widget.selected ? widget.selectedBg : (_hover ? widget.hoverBg : Colors.transparent);

    // El item usa Stack: el icono siempre está en posición fija a la izquierda,
    // el texto aparece a su derecha con animación de opacidad y slide.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: _isDesktop ? (_) => setState(() => _hover = true) : null,
        onExit: _isDesktop ? (_) => setState(() => _hover = false) : null,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: 44,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: widget.selected
                  ? Border.all(color: widget.scheme.primary.withValues(alpha: 0.3), width: 1.5)
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(12),
                splashColor: widget.scheme.primary.withValues(alpha: 0.1),
                hoverColor: Colors.transparent,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Icono: siempre centrado en los primeros _kCollapsedWidth px
                    Positioned(
                      left: 0,
                      width: _kCollapsedWidth - 16, // 56px
                      child: Center(
                        child: AnimatedScale(
                          scale: _hover ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOutCubic,
                          child: Icon(widget.icon, color: fg, size: _kIconSize),
                        ),
                      ),
                    ),
                    // Texto: aparece a la derecha del área del icono
                    Positioned(
                      left: _kCollapsedWidth - 16,
                      right: 8,
                      child: AnimatedOpacity(
                        opacity: widget.extended ? 1.0 : 0.0,
                        duration: Duration(milliseconds: widget.extended ? 220 : 120),
                        child: Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: fg,
                            fontWeight: widget.selected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── User Chip ───────────────────────────────────────────────────────────────

class _UserChip extends StatelessWidget {
  final bool extended;
  final Color railFg;
  final ColorScheme scheme;
  final ThemeData theme;
  final SettingsProvider settings;

  const _UserChip({
    required this.extended,
    required this.railFg,
    required this.scheme,
    required this.theme,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          splashColor: scheme.primary.withValues(alpha: 0.1),
          child: SizedBox(
            height: 44,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                // Avatar, siempre centrado en la columna de iconos
                Positioned(
                  left: 0,
                  width: _kCollapsedWidth - 16,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [scheme.secondary, scheme.secondary.withValues(alpha: 0.7)],
                        ),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Icon(Icons.person_rounded, color: scheme.onSecondary, size: 16),
                    ),
                  ),
                ),
                // Nombre, sólo visible expandido
                Positioned(
                  left: _kCollapsedWidth - 16,
                  right: 8,
                  child: AnimatedOpacity(
                    opacity: extended ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      AppLocalizations.of(context).navUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13 * settings.tamanoFuente,
                        color: railFg,
                        fontWeight: FontWeight.w500,
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
