import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path/path.dart' as p;
import '../services/app_database.dart';
import '../services/backup_services.dart';
import '../l10n/app_localizations.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settingsTitle),
        centerTitle: false,
      ),
      body: const _AjustesBody(),
    );
  }
}

class _AjustesBody extends StatelessWidget {
  const _AjustesBody();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        _SectionHeader(icon: Icons.palette_outlined, label: loc.settingsAppearance),
        const _TileApariencia(),
        const SizedBox(height: 8),
        _SectionHeader(icon: Icons.business_outlined, label: loc.settingsCompany),
        const _TileEmpresa(),
        const SizedBox(height: 8),
        _SectionHeader(icon: Icons.notifications_outlined, label: loc.settingsNotifications),
        const _TileNotificaciones(),
        const SizedBox(height: 8),
        _SectionHeader(icon: Icons.tune_outlined, label: loc.settingsRegional),
        const _TileRegional(),
        const SizedBox(height: 8),
        _SectionHeader(icon: Icons.save_outlined, label: loc.settingsDataBackup),
        const _TileDatos(),
        const SizedBox(height: 8),
        _SectionHeader(icon: Icons.settings_backup_restore_outlined, label: loc.settingsSystem),
        const _TileSistema(),
        const SizedBox(height: 24),
      ],
    );
  }
}

/* ─── Header de sección ─────────────────────────────────────────────────── */
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}

/* ─── Card wrapper ──────────────────────────────────────────────────────── */
class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cs.surfaceContainerLow,
      elevation: 0,
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 1,
                indent: 56,
                endIndent: 16,
                color: cs.outlineVariant.withOpacity(0.5),
              ),
          ],
        ],
      ),
    );
  }
}

/* ─── 1. APARIENCIA ─────────────────────────────────────────────────────── */
class _TileApariencia extends StatelessWidget {
  const _TileApariencia();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return _SettingsCard(children: [
      // Tema oscuro
      SwitchListTile(
        secondary: const Icon(Icons.dark_mode_outlined),
        title: Text(loc.settingsDarkTheme),
        value: s.oscuro,
        onChanged: s.setOscuro,
      ),

      // Fuente
      ListTile(
        leading: const Icon(Icons.font_download_outlined),
        title: Text(loc.settingsFont),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(s.fuente,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => _showFuenteDialog(context, s, loc),
      ),

      // Tamaño de fuente
      ListTile(
        leading: const Icon(Icons.format_size_outlined),
        title: Text(loc.settingsTextSize),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s.tamanoFuente == 0.85
                  ? loc.settingsTextSmall
                  : s.tamanoFuente == 1.25
                      ? loc.settingsTextLarge
                      : loc.settingsTextMedium,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => _showTamanoDialog(context, s, loc),
      ),

      // Color de marca
      ListTile(
        leading: const Icon(Icons.color_lens_outlined),
        title: Text(loc.settingsColorBrand),
        subtitle: Text(
          s.usarPaletaAuto ? loc.settingsColorAuto : loc.settingsColorManual,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: cs.onSurfaceVariant),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ColorDot(color: s.colorBase),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => _showColorPanel(context, s, loc),
      ),
    ]);
  }

  void _showFuenteDialog(BuildContext context, SettingsProvider s, AppLocalizations loc) {
    const fuentes = [
      'Roboto', 'Arial', 'Montserrat', 'Inter', 'Bitter',
      'DMSerifText', 'Faustina', 'GreatVibes', 'MeowScript',
      'SourGummy', 'Tangerine',
    ];
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(loc.settingsFont),
        children: fuentes
            .map((f) => RadioListTile<String>(
                  value: f,
                  groupValue: s.fuente,
                  title: Text(f),
                  onChanged: (v) {
                    s.setFuente(v!);
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showTamanoDialog(BuildContext context, SettingsProvider s, AppLocalizations loc) {
    final opciones = [
      (label: loc.settingsTextSmall, value: 0.85),
      (label: loc.settingsTextMedium, value: 1.0),
      (label: loc.settingsTextLarge, value: 1.25),
    ];
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(loc.settingsTextSize),
        children: opciones
            .map((o) => RadioListTile<double>(
                  value: o.value,
                  groupValue: s.tamanoFuente,
                  title: Text(o.label),
                  onChanged: (v) {
                    s.setTamanoFuente(v!);
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }

  void _showColorPanel(BuildContext context, SettingsProvider s, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: s,
        child: _ColorPanelSheet(loc: loc),
      ),
    );
  }
}

/* ─── Color panel como bottom sheet ─────────────────────────────────────── */
class _ColorPanelSheet extends StatelessWidget {
  final AppLocalizations loc;
  const _ColorPanelSheet({required this.loc});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(loc.settingsColorBrand, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(loc.settingsColorAuto),
            subtitle: Text(loc.settingsColorAutoDesc),
            value: s.usarPaletaAuto,
            onChanged: s.setUsarPaletaAuto,
          ),
          const SizedBox(height: 8),

          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(loc.settingsColorPrimary),
            trailing: _ColorDot(color: s.colorBase, size: 32),
            onTap: () => _pickColor(context, s.colorBase, s.setColorBase, loc),
          ),

          if (!s.usarPaletaAuto) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(loc.settingsColorSecondary),
              trailing: _ColorDot(color: s.colorSecundarioManual, size: 32),
              onTap: () => _pickColor(
                  context, s.colorSecundarioManual, s.setColorSecundarioManual, loc),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(loc.settingsColorTertiary),
              trailing: _ColorDot(color: s.colorTerciarioManual, size: 32),
              onTap: () => _pickColor(
                  context, s.colorTerciarioManual, s.setColorTerciarioManual, loc),
            ),
          ],

          const SizedBox(height: 12),
          Text(loc.settingsPreviewLabel, style: tt.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PreviewChip(bg: cs.primaryContainer, fg: cs.onPrimaryContainer, label: loc.settingsPrimaryPreview),
              _PreviewChip(bg: cs.secondaryContainer, fg: cs.onSecondaryContainer, label: loc.settingsSecondaryPreview),
              _PreviewChip(bg: cs.tertiaryContainer, fg: cs.onTertiaryContainer, label: loc.settingsTertiaryPreview),
              _PreviewChip(bg: cs.surfaceContainerHighest, fg: cs.onSurface, label: loc.settingsSurfacePreview),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color, this.size = 24});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1.5,
        ),
      ),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({required this.bg, required this.fg, required this.label});
  final Color bg, fg;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: bg,
      label: Text(label, style: TextStyle(color: fg, fontSize: 12)),
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      visualDensity: VisualDensity.compact,
    );
  }
}

/* ─── 2. EMPRESA ────────────────────────────────────────────────────────── */
class _TileEmpresa extends StatelessWidget {
  const _TileEmpresa();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    return _SettingsCard(children: [
      // Logo
      ListTile(
        leading: const Icon(Icons.image_outlined),
        title: Text(loc.settingsCompanyLogo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (s.logoPath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  File(s.logoPath),
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.broken_image, color: cs.onSurfaceVariant),
                ),
              )
            else
              Icon(Icons.business, color: cs.onSurfaceVariant),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => _pickLogo(context, s),
      ),

      // Nombre
      _EditableTile(
        icon: Icons.badge_outlined,
        title: loc.settingsCompanyName,
        value: s.nombreEmpresa,
        onSave: s.setNombreEmpresa,
      ),

      // Dirección
      _EditableTile(
        icon: Icons.location_on_outlined,
        title: loc.settingsAddress,
        value: s.direccion,
        hint: loc.settingsNoAddress,
        onSave: s.setDireccion,
      ),

      // Teléfono
      _EditableTile(
        icon: Icons.phone_outlined,
        title: loc.settingsPhone,
        value: s.telefono,
        hint: loc.settingsNoPhone,
        keyboardType: TextInputType.phone,
        onSave: s.setTelefono,
      ),

      // Email
      _EditableTile(
        icon: Icons.email_outlined,
        title: loc.settingsEmail,
        value: s.email,
        hint: loc.settingsNoEmail,
        keyboardType: TextInputType.emailAddress,
        onSave: s.setEmail,
      ),

      // Nº empleados
      ListTile(
        leading: const Icon(Icons.people_outline),
        title: Text(loc.settingsEmployees),
        subtitle: Text(loc.settingsEmployeesDesc),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${s.numeroEmpleados}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => _editNumeroEmpleados(context, s, loc),
      ),
    ]);
  }

  Future<void> _pickLogo(BuildContext context, SettingsProvider s) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final userDir = await s.getUserDir();
      final ext = p.extension(picked.path).isNotEmpty ? p.extension(picked.path) : '.jpg';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final target = File(p.join(userDir.path, 'logo_empresa_$timestamp$ext'));

      // Borrar logo anterior si existe y es distinto
      if (s.logoPath.isNotEmpty) {
        final old = File(s.logoPath);
        if (await old.exists() && old.path != target.path) {
          await old.delete();
        }
      }

      await File(picked.path).copy(target.path);
      s.setLogoPath(target.path);
    }
  }

  void _editNumeroEmpleados(BuildContext context, SettingsProvider s, AppLocalizations loc) {
    final ctrl = TextEditingController(text: '${s.numeroEmpleados}');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.settingsEditEmployees),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(labelText: loc.settingsEmployeeInput),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.actionCancel)),
          FilledButton(
            onPressed: () {
              final n = int.tryParse(ctrl.text) ?? 1;
              s.setNumeroEmpleados(n < 1 ? 1 : n);
              Navigator.pop(context);
            },
            child: Text(loc.actionSave),
          ),
        ],
      ),
    );
  }
}

/* ─── Tile editable inline ───────────────────────────────────────────────── */
class _EditableTile extends StatelessWidget {
  const _EditableTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onSave,
    this.hint = '',
    this.keyboardType = TextInputType.text,
  });

  final IconData icon;
  final String title;
  final String value;
  final String hint;
  final TextInputType keyboardType;
  final ValueChanged<String> onSave;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        value.isEmpty ? hint : value,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: value.isEmpty
                  ? cs.onSurfaceVariant.withOpacity(0.5)
                  : cs.onSurfaceVariant,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.edit_outlined, size: 18),
      onTap: () {
        final ctrl = TextEditingController(text: value);
        final loc = AppLocalizations.of(context);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: TextField(
              controller: ctrl,
              keyboardType: keyboardType,
              autofocus: true,
              decoration: InputDecoration(labelText: title),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(loc.actionCancel)),
              FilledButton(
                onPressed: () {
                  onSave(ctrl.text.trim());
                  Navigator.pop(context);
                },
                child: Text(loc.actionSave),
              ),
            ],
          ),
        );
      },
    );
  }
}

/* ─── 3. NOTIFICACIONES ─────────────────────────────────────────────────── */
class _TileNotificaciones extends StatelessWidget {
  const _TileNotificaciones();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();
    final loc = AppLocalizations.of(context);

    return _SettingsCard(children: [
      SwitchListTile(
        secondary: const Icon(Icons.warning_amber_outlined),
        title: Text(loc.settingsAlertUnpaid),
        subtitle: Text(loc.settingsAlertUnpaidDesc),
        value: s.alertasImpagos,
        onChanged: s.setAlertasImpagos,
      ),
      SwitchListTile(
        secondary: const Icon(Icons.event_outlined),
        title: Text(loc.settingsAlertAppointments),
        subtitle: Text(loc.settingsAlertAppointmentsDesc),
        value: s.notifCitas,
        onChanged: s.setNotifCitas,
      ),
      SwitchListTile(
        secondary: const Icon(Icons.person_off_outlined),
        title: Text(loc.settingsAlertInactiveClients),
        subtitle: Text(
            'Avisar si un cliente no visita en más de ${s.diasInactividad} días'),
        value: s.notifClientesInactivos,
        onChanged: s.setNotifClientesInactivos,
      ),
      if (s.notifClientesInactivos)
        ListTile(
          leading: const SizedBox(width: 24),
          title: Text(loc.settingsDaysWithoutVisit),
          trailing: SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Slider(
                    value: s.diasInactividad.toDouble(),
                    min: 7,
                    max: 90,
                    divisions: 83,
                    label: '${s.diasInactividad} ${loc.settingsDaysSliderLabel}',
                    onChanged: (v) => s.setDiasInactividad(v.round()),
                  ),
                ),
                Text('${s.diasInactividad}d'),
              ],
            ),
          ),
        ),
    ]);
  }
}

/* ─── 4. REGIONAL ───────────────────────────────────────────────────────── */
class _TileRegional extends StatelessWidget {
  const _TileRegional();

  // Opciones de idioma: (languageCode, etiqueta nativa)
  static const _idiomas = [
    ('es', 'Español'),
    ('en', 'English'),
  ];

  // Opciones de formato de fecha
  static const _formatos = [
    ('DD/MM/YYYY', 'DD/MM/YYYY  (31/12/2025)'),
    ('MM/DD/YYYY', 'MM/DD/YYYY  (12/31/2025)'),
    ('YYYY-MM-DD', 'YYYY-MM-DD  (2025-12-31)'),
  ];

  // Opciones de moneda: (símbolo, etiqueta)
  static const _monedas = [
    ('€',    'Euro (€)'),
    ('\$',   'Dólar EE.UU. (\$)'),
    ('£',    'Libra esterlina (£)'),
    ('¥',    'Yen japonés (¥)'),
    ('CHF',  'Franco suizo (CHF)'),
    ('MX\$', 'Peso mexicano (MX\$)'),
    ('C\$',  'Dólar canadiense (C\$)'),
    ('R\$',  'Real brasileño (R\$)'),
    ('₹',    'Rupia india (₹)'),
    ('₩',    'Won surcoreano (₩)'),
  ];

  String _labelIdioma(String code) =>
      _idiomas.firstWhere((e) => e.$1 == code, orElse: () => (code, code)).$2;

  String _labelMoneda(String sym) =>
      _monedas.firstWhere((e) => e.$1 == sym, orElse: () => (sym, sym)).$2;

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();
    final cs = Theme.of(context).colorScheme;

    Widget trailingValue(String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        );

    final loc = AppLocalizations.of(context);
    return _SettingsCard(children: [
      // ── Idioma ──────────────────────────────────────────────────────────
      ListTile(
        leading: const Icon(Icons.language_outlined),
        title: Text(loc.settingsLanguage),
        trailing: trailingValue(_labelIdioma(s.idioma)),
        onTap: () => _showOpcionesDialog<String>(
          context: context,
          title: loc.settingsLanguage,
          opciones: _idiomas,
          valorActual: s.idioma,
          onSelected: s.setIdioma,
        ),
      ),
      // ── Formato de fecha ─────────────────────────────────────────────────
      ListTile(
        leading: const Icon(Icons.calendar_today_outlined),
        title: Text(loc.settingsDateFormat),
        trailing: trailingValue(s.formatoFecha),
        onTap: () => _showOpcionesDialog<String>(
          context: context,
          title: loc.settingsDateFormat,
          opciones: _formatos,
          valorActual: s.formatoFecha,
          onSelected: s.setFormatoFecha,
        ),
      ),
      // ── Moneda ───────────────────────────────────────────────────────────
      ListTile(
        leading: const Icon(Icons.attach_money_outlined),
        title: Text(loc.settingsCurrency),
        trailing: trailingValue(_labelMoneda(s.simboloMoneda)),
        onTap: () => _showOpcionesDialog<String>(
          context: context,
          title: loc.settingsCurrency,
          opciones: _monedas,
          valorActual: s.simboloMoneda,
          onSelected: s.setSimboloMoneda,
        ),
      ),
    ]);
  }

  void _showOpcionesDialog<T>({
    required BuildContext context,
    required String title,
    required List<(T, String)> opciones,
    required T valorActual,
    required void Function(T) onSelected,
  }) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text(title),
        children: opciones
            .map((o) => RadioListTile<T>(
                  value: o.$1,
                  groupValue: valorActual,
                  title: Text(o.$2),
                  onChanged: (v) {
                    onSelected(v as T);
                    Navigator.pop(context);
                  },
                ))
            .toList(),
      ),
    );
  }
}

/* ─── 5. DATOS Y BACKUP ─────────────────────────────────────────────────── */
class _TileDatos extends StatelessWidget {
  const _TileDatos();

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context);

    final ultimoBackup = s.ultimaFechaBackup == null
        ? loc.labelNever
        : _formatDate(s.ultimaFechaBackup!.toLocal(), context);

    return _SettingsCard(children: [
      // Exportar
      ListTile(
        leading: const Icon(Icons.file_download_outlined),
        title: Text(loc.settingsExportBackup),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _exportar(context),
      ),

      // Importar
      ListTile(
        leading: const Icon(Icons.file_upload_outlined),
        title: Text(loc.settingsImportBackup),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _importar(context),
      ),

      // Último backup (informativo)
      ListTile(
        leading: const Icon(Icons.history_outlined),
        title: Text(loc.settingsLastBackup),
        trailing: Text(ultimoBackup,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: cs.onSurfaceVariant)),
      ),

      // Intervalo backup
      ListTile(
        leading: const Icon(Icons.schedule_outlined),
        title: Text(loc.settingsBackupFrequency),
        subtitle: Text(loc.settingsBackupFrequencyLabel(s.intervaloBackupDias)),
        trailing: SizedBox(
          width: 160,
          child: Slider(
            value: s.intervaloBackupDias.toDouble(),
            min: 1,
            max: 30,
            divisions: 29,
            label: '${s.intervaloBackupDias} ${loc.settingsDaysSliderLabel}',
            onChanged: (v) => s.setIntervaloBackupDias(v.round()),
          ),
        ),
      ),

      // Backup ahora
      ListTile(
        leading: const Icon(Icons.save_outlined),
        title: Text(loc.settingsBackupNow),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _backupAhora(context),
      ),
    ]);
  }

  String _formatDate(DateTime dt, BuildContext context) =>
      context.read<SettingsProvider>().formatDateTime(dt);

  Future<void> _exportar(BuildContext context) async {
    final db = context.read<AppDatabase>();
    final s = context.read<SettingsProvider>();
    final loc = AppLocalizations.of(context);
    final backup = BackupService(db: db, settings: s);
    final path = await backup.exportFullBackup();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(path == null ? loc.settingsBackupCancelled : '${loc.settingsSavedAt}\n$path'),
      duration: const Duration(seconds: 4),
    ));
  }

  Future<void> _importar(BuildContext context) async {
    final db = context.read<AppDatabase>();
    final s = context.read<SettingsProvider>();
    final loc = AppLocalizations.of(context);
    final backup = BackupService(db: db, settings: s);
    final ok = await backup.importFullBackup();
    if (!context.mounted) return;
    if (ok) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(loc.settingsImportSuccess),
          content: Text(loc.settingsImportSuccessMessage),
          actions: [
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK')),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.settingsImportError)));
    }
  }

  Future<void> _backupAhora(BuildContext context) async {
    final db = context.read<AppDatabase>();
    final s = context.read<SettingsProvider>();
    final loc = AppLocalizations.of(context);
    final backup = BackupService(db: db, settings: s);
    await backup.autoBackupIfDue();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.settingsBackupSuccess)));
  }
}

/* ─── 6. SISTEMA ────────────────────────────────────────────────────────── */
class _TileSistema extends StatelessWidget {
  const _TileSistema();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return _SettingsCard(children: [
      ListTile(
        leading: Icon(Icons.restore, color: Theme.of(context).colorScheme.error),
        title: Text(loc.settingsRestoreDefaults,
            style: TextStyle(color: Theme.of(context).colorScheme.error)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _confirmarReset(context),
      ),
    ]);
  }

  void _confirmarReset(BuildContext context) {
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.settingsResetTitle),
        content: Text(loc.settingsRestoreDefaultsWarning),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.actionCancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              context.read<SettingsProvider>().restablecerAjustes();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.settingsRestoreDefaultsSuccess)));
            },
            child: Text(loc.settingsResetConfirm),
          ),
        ],
      ),
    );
  }
}

/* ─── Utilidad: color picker ─────────────────────────────────────────────── */
Future<void> _pickColor(
  BuildContext context,
  Color current,
  ValueChanged<Color> onPicked,
  AppLocalizations loc,
) async {
  Color temp = current;
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(loc.settingsPickColor),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: temp,
          onColorChanged: (c) => temp = c,
          enableAlpha: false,
          hexInputBar: true,
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.actionCancel)),
        FilledButton(
          onPressed: () {
            onPicked(temp);
            Navigator.pop(context);
          },
          child: Text(loc.actionAccept),
        ),
      ],
    ),
  );
}
