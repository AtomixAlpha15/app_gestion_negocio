import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ajustes"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.format_paint), text: "Visual"),
              Tab(icon: Icon(Icons.build), text: "Avanzado"),
              Tab(icon: Icon(Icons.security), text: "Datos"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ------- 1. AJUSTES VISUALES --------
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Personalización visual", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  // Tipo de letra
                  DropdownButtonFormField<String>(
                    value: settings.fuente,
                    items: const [
                      DropdownMenuItem(value: "Roboto", child: Text("Roboto")),
                      DropdownMenuItem(value: "Arial", child: Text("Arial")),
                      DropdownMenuItem(value: "Montserrat", child: Text("Montserrat")),
                      DropdownMenuItem(value: "Inter", child: Text("Inter")),
                    ],
                    onChanged: (val) => settings.setFuente(val ?? "Roboto"),
                    decoration: const InputDecoration(labelText: "Tipo de letra"),
                  ),
                  const SizedBox(height: 16),

                  // Tamaño de fuente
                  DropdownButtonFormField<double>(
                    value: settings.tamanoFuente,
                    items: const [
                      DropdownMenuItem(value: 0.85, child: Text("Pequeño")),
                      DropdownMenuItem(value: 1.0, child: Text("Mediano")),
                      DropdownMenuItem(value: 1.25, child: Text("Grande")),
                    ],
                    onChanged: (val) {/* Lógica futura */},
                    decoration: const InputDecoration(labelText: "Tamaño de fuente"),
                  ),
                  const SizedBox(height: 16),

                  // Tema claro/oscuro
                  SwitchListTile(
                    value: settings.oscuro,
                    onChanged: (val) => settings.setOscuro(val),
                    title: const Text("Tema oscuro"),
                  ),
                  const SizedBox(height: 16),

                  // Color principal
                  ListTile(
                    title: const Text("Color principal"),
                    trailing: CircleAvatar(backgroundColor: settings.colorPrimario),
                    onTap: () {/* Color picker futuro */},
                  ),
                  // Color secundario
                  ListTile(
                    title: const Text("Color secundario"),
                    trailing: CircleAvatar(backgroundColor: settings.colorSecundario),
                    onTap: () {/* Color picker futuro */},
                  ),
                  // Color terciario
                  ListTile(
                    title: const Text("Color terciario"),
                    trailing: CircleAvatar(backgroundColor: settings.colorTerciario),
                    onTap: () {/* Color picker futuro */},
                  ),
                  const SizedBox(height: 16),

                  // Logo de empresa
                  Row(
                    children: [
                      settings.logoPath.isEmpty
                          ? const Icon(Icons.business, size: 48)
                          : Image.asset(settings.logoPath, width: 48, height: 48),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.upload),
                        label: const Text("Seleccionar logo"),
                        onPressed: () {/* Lógica para seleccionar imagen */},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nombre de la empresa
                  TextFormField(
                    initialValue: settings.nombreEmpresa,
                    decoration: const InputDecoration(labelText: "Nombre de la empresa"),
                    onChanged: (v) {/* Guardar futuro */},
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: settings.direccion,
                    decoration: const InputDecoration(labelText: "Dirección"),
                    onChanged: (v) {/* Guardar futuro */},
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: settings.telefono,
                    decoration: const InputDecoration(labelText: "Teléfono"),
                    onChanged: (v) {/* Guardar futuro */},
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: settings.email,
                    decoration: const InputDecoration(labelText: "Email"),
                    onChanged: (v) {/* Guardar futuro */},
                  ),
                  const SizedBox(height: 24),

                  // Botón de restablecer a valores por defecto
                  Center(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.restore),
                      label: const Text("Volver a valores por defecto"),
                      onPressed: () {/* Lógica futura */},
                    ),
                  ),
                ],
              ),
            ),

            // ------- 2. AJUSTES AVANZADOS --------
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Ajustes avanzados", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),

                  // Idioma
                  DropdownButtonFormField<String>(
                    value: settings.idioma,
                    items: const [
                      DropdownMenuItem(value: "Español", child: Text("Español")),
                      DropdownMenuItem(value: "Inglés", child: Text("Inglés")),
                    ],
                    onChanged: (val) {/* Lógica futura */},
                    decoration: const InputDecoration(labelText: "Idioma"),
                  ),
                  const SizedBox(height: 16),

                  // Formato fecha
                  DropdownButtonFormField<String>(
                    value: settings.formatoFecha,
                    items: const [
                      DropdownMenuItem(value: "DD/MM/YYYY", child: Text("DD/MM/YYYY")),
                      DropdownMenuItem(value: "MM/DD/YYYY", child: Text("MM/DD/YYYY")),
                    ],
                    onChanged: (val) {/* Lógica futura */},
                    decoration: const InputDecoration(labelText: "Formato de fecha"),
                  ),
                  const SizedBox(height: 16),

                  // Símbolo de moneda
                  DropdownButtonFormField<String>(
                    value: settings.simboloMoneda,
                    items: const [
                      DropdownMenuItem(value: "€", child: Text("Euro (€)")),
                      DropdownMenuItem(value: "\$", child: Text("Dólar (\$)")),
                      DropdownMenuItem(value: "£", child: Text("Libra (£)")),
                    ],
                    onChanged: (val) {/* Lógica futura */},
                    decoration: const InputDecoration(labelText: "Símbolo de moneda"),
                  ),
                  const SizedBox(height: 16),

                  // Selector de tamaño del menú lateral
                  Slider(
                    value: settings.anchoMenu,
                    min: 180,
                    max: 380,
                    divisions: 10,
                    label: "${settings.anchoMenu.toInt()} px",
                    onChanged: (v) {/* Lógica futura */},
                  ),
                  const SizedBox(height: 16),

                  // Personalización de iconos (placeholder)
                  ListTile(
                    title: const Text("Personalización de iconos del menú"),
                    trailing: const Icon(Icons.edit),
                    onTap: () {/* Lógica futura */},
                  ),
                  const SizedBox(height: 16),

                  // Campos extra personalizables (placeholder)
                  ListTile(
                    title: const Text("Campos extra personalizables"),
                    trailing: const Icon(Icons.add_box),
                    onTap: () {/* Lógica futura */},
                  ),
                  const SizedBox(height: 16),

                  // Notificaciones/alertas (placeholder)
                  SwitchListTile(
                    value: true,
                    onChanged: (val) {/* Lógica futura */},
                    title: const Text("Mostrar alertas de impagos"),
                  ),
                ],
              ),
            ),

            // ------- 3. DATOS Y BACKUP --------
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Datos, backup y usuarios", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.file_upload),
                    label: const Text("Importar datos (Excel/CSV)"),
                    onPressed: () {/* Lógica futura */},
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.file_download),
                    label: const Text("Exportar datos (Excel/CSV)"),
                    onPressed: () {/* Lógica futura */},
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.backup),
                    label: const Text("Respaldo automático en la nube"),
                    onPressed: () {/* Lógica futura */},
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text("Gestión de usuarios y permisos"),
                    onPressed: () {/* Lógica futura */},
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.business),
                    label: const Text("Gestionar varias empresas"),
                    onPressed: () {/* Lógica futura */},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
