import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'clientes_screen.dart';
import 'servicios_screen.dart';
import 'agenda_screen.dart';
import '../widgets/custom_nav.dart';
import 'ajustes_screen.dart';
import 'contabilidad_screen.dart';

enum AppSection { dashboard, clientes, servicios, agenda, contabilidad, ajustes }

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
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
    return Scaffold(
      body: Row(
        children: [
          CustomNavigationRail(
            selectedIndex: _selectedSection.index,
            onDestinationSelected: (idx) {
              setState(() => _selectedSection = AppSection.values[idx]);
            },
          ),
          // Zona de contenido principal
          Expanded(
            child: _getSectionWidget(_selectedSection),
          ),
        ],
      ),
    );
  }
}
