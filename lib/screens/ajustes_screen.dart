import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path/path.dart' as p; // <- rutas seguras multiplataforma
import '../services/app_database.dart';
import '../services/backup_services.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Visual / Empresa / Avanzado / Datos
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ajustes"),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.format_paint), text: "Visual"),
              Tab(icon: Icon(Icons.business), text: "Empresa"),
              Tab(icon: Icon(Icons.build), text: "Avanzado"),
              Tab(icon: Icon(Icons.security), text: "Datos"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TabVisual(),
            _TabEmpresa(),
            _TabAvanzado(),
            _TabDatos(),
          ],
        ),
      ),
    );
  }
}

/* =========================
 *   1) Pestaña: VISUAL
 * ========================= */
class _TabVisual extends StatelessWidget {
  const _TabVisual();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título principal
          Text("Personalización visual",
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // ---- Subtítulo: Fuente ----
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text("Fuente",
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),

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
          const SizedBox(height: 12),

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
          const SizedBox(height: 20),

          // ---- Subtítulo: Colores ----
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text("Colores",
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 12),

          // Panel de colores con el orden solicitado
          const _PanelColoresOrdenCorrecto(),
        ],
      ),
    );
  }
}

/* =========================
 *   2) Pestaña: EMPRESA
 * ========================= */
class _TabEmpresa extends StatelessWidget {
  const _TabEmpresa();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Datos de empresa",
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // ---- Subtítulo: Logo de empresa ----
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 8),
            child: Text("Logo de empresa",
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),

          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: settings.logoPath.isEmpty
                    ? const Icon(Icons.business, size: 40)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(
                          File(settings.logoPath),
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 40),
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text("Seleccionar logo"),
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    final appDir = await getApplicationDocumentsDirectory();
                    final ext = p.extension(picked.path);         // .png / .jpg
                    final fileName = 'logo_empresa$ext';
                    final target = File(p.join(appDir.path, fileName));
                    await File(picked.path).copy(target.path);
                    settings.setLogoPath(target.path);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Nombre de la empresa
          TextFormField(
            initialValue: settings.nombreEmpresa,
            decoration: const InputDecoration(labelText: "Nombre de la empresa"),
            onChanged: settings.setNombreEmpresa,
          ),
          const SizedBox(height: 12),

          // Dirección
          TextFormField(
            initialValue: settings.direccion,
            decoration: const InputDecoration(labelText: "Dirección"),
            onChanged: settings.setDireccion,
          ),
          const SizedBox(height: 12),

          // Teléfono
          TextFormField(
            initialValue: settings.telefono,
            decoration: const InputDecoration(labelText: "Teléfono"),
            onChanged: settings.setTelefono,
          ),
          const SizedBox(height: 12),

          // Email
          TextFormField(
            initialValue: settings.email,
            decoration: const InputDecoration(labelText: "Email"),
            onChanged: settings.setEmail,
          ),
          const SizedBox(height: 12),

          // Número de empleados (mínimo 1)
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: '${settings.numeroEmpleados}',
                  decoration: const InputDecoration(labelText: "Número de empleados"),
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    final n = int.tryParse(v) ?? 1;
                    settings.setNumeroEmpleados(n < 1 ? 1 : n);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Tooltip(
                message: 'Se usará para crear agendas por empleado más adelante',
                child: const Icon(Icons.info_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* =========================
 *   3) Pestaña: AVANZADO
 * ========================= */
class _TabAvanzado extends StatelessWidget {
  const _TabAvanzado();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final text = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ajustes avanzados",
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Idioma
          DropdownButtonFormField<String>(
            value: settings.idioma,
            items: const [
              DropdownMenuItem(value: "Español", child: Text("Español")),
              DropdownMenuItem(value: "Inglés", child: Text("Inglés")),
            ],
            onChanged: (_) {/* futura i18n */},
            decoration: const InputDecoration(labelText: "Idioma"),
          ),
          const SizedBox(height: 12),

          // Formato fecha
          DropdownButtonFormField<String>(
            value: settings.formatoFecha,
            items: const [
              DropdownMenuItem(value: "DD/MM/YYYY", child: Text("DD/MM/YYYY")),
              DropdownMenuItem(value: "MM/DD/YYYY", child: Text("MM/DD/YYYY")),
            ],
            onChanged: (_) {/* futura i18n */},
            decoration: const InputDecoration(labelText: "Formato de fecha"),
          ),
          const SizedBox(height: 12),

          // Símbolo de moneda
          DropdownButtonFormField<String>(
            value: settings.simboloMoneda,
            items: const [
              DropdownMenuItem(value: "€", child: Text("Euro (€)")),
              DropdownMenuItem(value: "\$", child: Text("Dólar (\$)")),
              DropdownMenuItem(value: "£", child: Text("Libra (£)")),
            ],
            onChanged: (_) {/* futura i18n */},
            decoration: const InputDecoration(labelText: "Símbolo de moneda"),
          ),
          const SizedBox(height: 12),

          // Selector de tamaño del menú lateral
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ancho del menú lateral",
                  style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              Slider(
                value: settings.anchoMenu,
                min: 180,
                max: 380,
                divisions: 10,
                label: "${settings.anchoMenu.toInt()} px",
                onChanged: (v) => settings.setAnchoMenu(v),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Personalización de iconos (placeholder)
          ListTile(
            title: const Text("Personalización de iconos del menú"),
            trailing: const Icon(Icons.edit),
            onTap: () {/* futuro */},
          ),
          const SizedBox(height: 12),

          // Campos extra personalizables (placeholder)
          ListTile(
            title: const Text("Campos extra personalizables"),
            trailing: const Icon(Icons.add_box),
            onTap: () {/* futuro */},
          ),
          const SizedBox(height: 12),

          // Notificaciones/alertas
          SwitchListTile(
            value: settings.alertasImpagos,
            onChanged: (v) => settings.setAlertasImpagos(v),
            title: const Text("Mostrar alertas de impagos"),
          ),

          const SizedBox(height: 24),

          // Botón de restablecer a valores por defecto (aquí)
          Center(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.restore),
              label: const Text("Volver a valores por defecto"),
              onPressed: () {
                settings.restablecerAjustes();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ajustes restablecidos')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================
 *   4) Pestaña: DATOS
 * ========================= */
class _TabDatos extends StatelessWidget {
  const _TabDatos();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final settings = context.watch<SettingsProvider>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Datos, backup y usuarios",
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.file_upload),
            label: const Text("Importar datos de empresa"),
            onPressed: () async {
              final db = context.read<AppDatabase>();
              final settings = context.read<SettingsProvider>();
              final backup = BackupService(db: db, settings: settings);

              final ok = await backup.importFullBackup();
              if (!context.mounted) return;

              if (ok) {
                // confirmación
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Copia restaurada'),
                    content: const Text(
                      'Se ha restaurado la copia de seguridad.\n'
                      'Para aplicar todos los cambios, reinicia la aplicación.'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      )
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No se pudo importar el backup')),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.file_download),
            label: const Text("Exportar datos de empresa"),
            onPressed: () async {
              final db = context.read<AppDatabase>();
              final settings = context.read<SettingsProvider>();
              final backup = BackupService(db: db, settings: settings);

              final savedPath = await backup.exportFullBackup();
              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(savedPath == null
                      ? 'Exportación cancelada'
                      : 'Copia guardada en:\n$savedPath'),
                  duration: const Duration(seconds: 4),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.backup),
            label: const Text("Respaldo automático en la nube"),
            onPressed: () {/* Lógica futura */},
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.person),
            label: const Text("Gestión de usuarios y permisos"),
            onPressed: () {/* Lógica futura */},
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.business),
            label: const Text("Gestionar varias empresas"),
            onPressed: () {/* Lógica futura */},
          ),
          // Intervalo
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: settings.intervaloBackupDias.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: '${settings.intervaloBackupDias} días',
                  onChanged: (v) => settings.setIntervaloBackupDias(v.round()),
                ),
              ),
              SizedBox(width: 12),
              Text('${settings.intervaloBackupDias} días'),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Último backup: ${settings.ultimaFechaBackup == null ? '—' : settings.ultimaFechaBackup!.toLocal().toString().split(".").first}',
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Crear backup ahora'),
            onPressed: () async {
              final db = context.read<AppDatabase>();
              final s  = context.read<SettingsProvider>();
              final backup = BackupService(db: db, settings: s);
              await backup.autoBackupIfDue(); // fuerza uno (está preparado para crear igualmente)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup local creado (carpeta Backups).')),
              );
            },
          ),

        ],
      ),
    );
  }
}

/* =========================
 *   Panel de Colores (orden solicitado)
 * ========================= */
class _PanelColoresOrdenCorrecto extends StatelessWidget {
  const _PanelColoresOrdenCorrecto();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final scheme   = Theme.of(context).colorScheme;
    final text     = Theme.of(context).textTheme;

    Widget chipColor(Color bg, String label, Color fg) => Chip(
      backgroundColor: bg,
      label: Text(label, style: text.labelLarge?.copyWith(color: fg)),
      side: BorderSide(color: scheme.outlineVariant),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Paleta automática
            SwitchListTile(
              title: const Text('Paleta automática (recomendado)'),
              subtitle: const Text('Generar secundarios/terciario a partir del color de marca'),
              value: settings.usarPaletaAuto,
              onChanged: (v) => settings.setUsarPaletaAuto(v),
            ),
            const SizedBox(height: 8),

            // 2) Tema oscuro
            SwitchListTile(
              value: settings.oscuro,
              onChanged: (val) => settings.setOscuro(val),
              title: const Text("Tema oscuro"),
            ),
            const SizedBox(height: 8),

            // 3) Color de marca (base)
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

            // 4) Avanzado (secundario/terciario) si NO es paleta auto
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
            // 5) Vista previa
            Text('Vista previa',
                style: text.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                chipColor(scheme.primaryContainer,  'Primario',   scheme.onPrimaryContainer),
                chipColor(scheme.secondaryContainer,'Secundario', scheme.onSecondaryContainer),
                chipColor(scheme.tertiaryContainer, 'Terciario',  scheme.onTertiaryContainer),
                chipColor(scheme.surfaceVariant,    'Surface',    scheme.onSurfaceVariant),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
 *   Utilidad: Color picker
 * ========================= */
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
