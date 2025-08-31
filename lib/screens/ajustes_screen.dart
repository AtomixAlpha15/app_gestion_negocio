import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

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
                      DropdownMenuItem(value: "Bitter", child: Text("Bitter")),
                      DropdownMenuItem(value: "DMSerifText", child: Text("DMSerifText")),
                      DropdownMenuItem(value: "Faustina", child: Text("Faustina")),
                      DropdownMenuItem(value: "GreatVibes", child: Text("GreatVibes")),
                      DropdownMenuItem(value: "MeowScript", child: Text("MeowScript")),
                      DropdownMenuItem(value: "SourGummy", child: Text("SourGummy")),
                      DropdownMenuItem(value: "Tangerine", child: Text("Tangerine")),
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
                    onChanged: (val) => settings.setTamanoFuente(val ?? 1.0),
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

                  _panelColores(context),
                  
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
                        onPressed: () async {        
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(source: ImageSource.gallery);
                          if (picked != null) {
                            // Opcional: copia la imagen a la carpeta de la app para evitar problemas de permisos futuros
                            final appDir = await getApplicationDocumentsDirectory();
                            final newPath = '${appDir.path}/logo_empresa${picked.path.split('.').last}';
                            final newLogo = await File(picked.path).copy(newPath);

                            settings.setLogoPath(newLogo.path);
                          }
                        }
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nombre de la empresa
                  TextFormField(
                    initialValue: settings.nombreEmpresa,
                    decoration: const InputDecoration(labelText: "Nombre de la empresa"),
                    onChanged: (v) => settings.setNombreEmpresa(v),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: settings.direccion,
                    decoration: const InputDecoration(labelText: "Dirección"),
                    onChanged: (v) => settings.setDireccion(v),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: settings.telefono,
                    decoration: const InputDecoration(labelText: "Teléfono"),
                    onChanged: (v) => settings.setTelefono(v),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: settings.email,
                    decoration: const InputDecoration(labelText: "Email"),
                    onChanged: (v) => settings.setEmail(v),
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
  Widget _panelColores(BuildContext context) {
  final settings = context.watch<SettingsProvider>();
  final scheme   = Theme.of(context).colorScheme;
  final text     = Theme.of(context).textTheme;

  // Previsualización rápida de la paleta actual
  Widget chipColor(Color bg, String label, Color fg) => Chip(
    backgroundColor: bg,
    label: Text(label, style: text.labelLarge?.copyWith(color: fg)),
    side: BorderSide(color: scheme.outlineVariant),
  );

  return Card(
    margin: const EdgeInsets.symmetric(vertical: 12),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Colores', style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Switch: Paleta automática
          SwitchListTile(
            title: const Text('Paleta automática (recomendado)'),
            subtitle: const Text('Generar colores secundarios/terciarios a partir del color de marca'),
            value: settings.usarPaletaAuto,
            onChanged: (v) => settings.setUsarPaletaAuto(v),
          ),

          const SizedBox(height: 8),

          // Color base (siempre visible)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Color de marca'),
            subtitle: const Text('Base para todo el esquema de color'),
            trailing: CircleAvatar(backgroundColor: settings.colorBase),
            onTap: () => _pickColor(
              context,
              settings.colorBase,
              (c) => settings.setColorBase(c),
            ),
          ),

          // Avanzado (solo si desactivas paleta automática)
          if (!settings.usarPaletaAuto) ...[
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Color secundario (avanzado)'),
              trailing: CircleAvatar(backgroundColor: settings.colorSecundarioManual),
              onTap: () => _pickColor(
                context,
                settings.colorSecundarioManual,
                (c) => settings.setColorSecundarioManual(c),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Color terciario (avanzado)'),
              trailing: CircleAvatar(backgroundColor: settings.colorTerciarioManual),
              onTap: () => _pickColor(
                context,
                settings.colorTerciarioManual,
                (c) => settings.setColorTerciarioManual(c),
              ),
            ),
          ],

          const SizedBox(height: 12),
          Text('Vista previa', style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          // Chips de preview usando el esquema actual (ya derivado en app.dart)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              chipColor(Theme.of(context).colorScheme.primaryContainer,     'Primario',
                        Theme.of(context).colorScheme.onPrimaryContainer),
              chipColor(Theme.of(context).colorScheme.secondaryContainer,   'Secundario',
                        Theme.of(context).colorScheme.onSecondaryContainer),
              chipColor(Theme.of(context).colorScheme.tertiaryContainer,    'Terciario',
                        Theme.of(context).colorScheme.onTertiaryContainer),
              chipColor(Theme.of(context).colorScheme.surfaceVariant,       'Surface',
                        Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ],
      ),
    ),
  );
}

  Future<void> _pickColor(
    BuildContext context,
    Color current,
    ValueChanged<Color> onPicked,
  ) async {
    Color temp = current;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Seleccionar color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: temp,
            onColorChanged: (c) => temp = c,
            enableAlpha: false,
            hexInputBar: true,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              onPicked(temp);
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

}
