import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'dashboard_screen.dart';
import 'clientes_screen.dart';
import 'servicios_screen.dart';
import 'agenda_screen.dart';
import '../widgets/custom_nav.dart';
import 'ajustes_screen.dart';
import 'contabilidad_screen.dart';
import '../providers/sync_provider.dart';
import '../services/app_database.dart';
import '../services/sync_service.dart';
import '../utils/responsive.dart';

enum AppSection { dashboard, clientes, servicios, agenda, contabilidad, ajustes }

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  AppSection _selectedSection = AppSection.dashboard;

  Widget _getSectionWidget(AppSection section) {
    switch (section) {
      case AppSection.dashboard:
        return const DashboardScreen();
      case AppSection.clientes:
        return const ClientesScreen();
      case AppSection.servicios:
        return const ServiciosScreen();
      case AppSection.agenda:
        return const AgendaScreen();
      case AppSection.contabilidad:
        return const ContabilidadScreen();
      case AppSection.ajustes:
        return const AjustesScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = provider.Provider.of<AppDatabase>(context, listen: false);
    final syncState = ref.watch(syncStatusProvider(db));
    final mobile = isMobile(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
          // Barra de sync — solo visible cuando no está idle
          _SyncStatusBar(syncState: syncState),
          Expanded(
            child: mobile
                ? _getSectionWidget(_selectedSection)
                : Row(
                    children: [
                      CustomNavigationRail(
                        selectedIndex: _selectedSection.index,
                        onDestinationSelected: (idx) {
                          setState(() => _selectedSection = AppSection.values[idx]);
                        },
                      ),
                      Expanded(
                        child: _getSectionWidget(_selectedSection),
                      ),
                    ],
                  ),
          ),
        ],
        ),
      ),
      bottomNavigationBar: mobile
          ? NavigationBar(
              selectedIndex: _selectedSection.index,
              onDestinationSelected: (idx) {
                setState(() => _selectedSection = AppSection.values[idx]);
              },
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Inicio',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Clientes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.spa_outlined),
                  selectedIcon: Icon(Icons.spa),
                  label: 'Servicios',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined),
                  selectedIcon: Icon(Icons.calendar_today),
                  label: 'Agenda',
                ),
                NavigationDestination(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  selectedIcon: Icon(Icons.account_balance_wallet),
                  label: 'Contable',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Ajustes',
                ),
              ],
            )
          : null,
    );
  }
}

class _SyncStatusBar extends StatelessWidget {
  final SyncStatusState syncState;
  const _SyncStatusBar({required this.syncState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return switch (syncState.status) {
      SyncStatus.idle => const SizedBox.shrink(),
      SyncStatus.syncing => _Bar(
          color: theme.colorScheme.primaryContainer,
          textColor: theme.colorScheme.onPrimaryContainer,
          icon: const SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
          label: 'Sincronizando…',
        ),
      SyncStatus.offline => _Bar(
          color: theme.colorScheme.surfaceContainerHighest,
          textColor: theme.colorScheme.onSurfaceVariant,
          icon: const Icon(Icons.cloud_off_outlined, size: 14),
          label: 'Sin conexión — los cambios se guardan localmente',
        ),
      SyncStatus.error => _Bar(
          color: theme.colorScheme.errorContainer,
          textColor: theme.colorScheme.onErrorContainer,
          icon: const Icon(Icons.sync_problem_outlined, size: 14),
          label: syncState.error ?? 'Error de sincronización',
        ),
    };
  }
}

class _Bar extends StatelessWidget {
  final Color color;
  final Color textColor;
  final Widget icon;
  final String label;

  const _Bar({
    required this.color,
    required this.textColor,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(color: textColor, size: 14),
            child: icon,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: textColor),
          ),
        ],
      ),
    );
  }
}
