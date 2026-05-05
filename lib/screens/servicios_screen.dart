import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_database.dart';
import '../providers/servicios_provider.dart';
import '../providers/extras_servicio_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../providers/settings_provider.dart';
import '../widgets/entity_card.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ServiciosProvider>().cargarServicios());
  }

  String _norm(String s) {
  const from = 'áéíóúüñÁÉÍÓÚÜÑ';
  const to   = 'aeiouunAEIOUUN';
  for (var i = 0; i < from.length; i++) {
    s = s.replaceAll(from[i], to[i]);
  }
  return s.toLowerCase();
}


void _mostrarDialogoServicio({dynamic servicio}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Servicio',
    barrierColor: Colors.black.withOpacity(0.35),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) {
      return Center(
        child: _ServicioDialogo(servicio: servicio),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      final curved = Curves.easeOutCubic.transform(anim.value);
      return Transform.scale(
        scale: 0.96 + (0.04 * curved),
        child: Opacity(
          opacity: anim.value,
          child: child,
        ),
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mobile = isMobile(context);

    final provider = context.watch<ServiciosProvider>();
    final servicios = provider.servicios;
    final q = _norm(_query);
    final filtrados = q.isEmpty
        ? servicios
        : servicios.where((s) {
            final nombre = _norm(s.nombre);
            final desc = _norm(s.descripcion ?? '');
            return nombre.contains(q) || desc.contains(q);
          }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).servicesTitle)),
      floatingActionButton: mobile
          ? FloatingActionButton(
              onPressed: () => _mostrarDialogoServicio(),
              child: const Icon(Icons.add),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 44,
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 120), () {
                    if (!mounted) return;
                    setState(() => _query = v.trim());
                  });
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).servicesSearch,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: AppLocalizations.of(context).actionClose,
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _query = '';
                              _searchCtrl.clear();
                            });
                            FocusScope.of(context).unfocus();
                          },
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: scheme.outlineVariant),
            SizedBox(height: mobile ? 0 : 24),
            Expanded(
              child: mobile
                  ? _buildMobileList(context, filtrados)
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final ancho = constraints.maxWidth;
                        final columnas = (ancho / 220).floor().clamp(1, 6);
                        final gridKey =
                            ValueKey(filtrados.map((e) => e.id).join('|'));

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeOutCubic,
                          transitionBuilder: (child, anim) {
                            final fade = CurvedAnimation(
                                parent: anim, curve: Curves.easeOut);
                            final slide = Tween<Offset>(
                              begin: const Offset(0, 0.03),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeOutCubic));
                            return FadeTransition(
                              opacity: fade,
                              child: SlideTransition(
                                  position: slide, child: child),
                            );
                          },
                          child: GridView.count(
                            key: gridKey,
                            crossAxisCount: columnas,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            children: [
                              EntityCard(
                                isNew: true,
                                newIcon: Icons.add_box,
                                newLabel:
                                    AppLocalizations.of(context).servicesNew,
                                onTap: () => _mostrarDialogoServicio(),
                              ),
                              ...filtrados.map(
                                (s) => _AnimatedServicioItem(
                                  key: ValueKey(s.id),
                                  child: EntityCard(
                                    onTap: () =>
                                        _mostrarDialogoServicio(servicio: s),
                                    title: s.nombre,
                                    subtitle:
                                        '${context.read<SettingsProvider>().formatCurrency(s.precio)} · ${s.duracionMinutos} min',
                                    imagePath: s.imagenPath,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, List filtrados) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final settings = context.read<SettingsProvider>();

    if (filtrados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa_outlined, size: 56, color: scheme.outline),
            const SizedBox(height: 12),
            Text(
              _query.isEmpty ? 'Aún no hay servicios' : 'Sin resultados',
              style: text.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: filtrados.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 72, endIndent: 0),
      itemBuilder: (context, index) {
        final s = filtrados[index];
        return _ServicioListTile(
          nombre: s.nombre,
          imagePath: s.imagenPath,
          subtitulo:
              '${settings.formatCurrency(s.precio)} · ${s.duracionMinutos} min',
          onTap: () => _mostrarDialogoServicio(servicio: s),
        );
      },
    );
  }
}

class _ServicioListTile extends StatelessWidget {
  final String nombre;
  final String? imagePath;
  final String subtitulo;
  final VoidCallback onTap;

  const _ServicioListTile({
    required this.nombre,
    required this.imagePath,
    required this.subtitulo,
    required this.onTap,
  });

  Color _avatarColor(String name) {
    const palette = [
      Color(0xFF4CAF50),
      Color(0xFF2196F3),
      Color(0xFF9C27B0),
      Color(0xFFFF9800),
      Color(0xFF00BCD4),
      Color(0xFFE91E63),
      Color(0xFF607D8B),
      Color(0xFF795548),
    ];
    if (name.isEmpty) return palette[0];
    return palette[name.codeUnitAt(0) % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final hasImg = (imagePath ?? '').trim().isNotEmpty;
    final inicial = nombre.trim().isEmpty ? '?' : nombre.trim()[0].toUpperCase();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: hasImg ? FileImage(File(imagePath!)) : null,
              backgroundColor: hasImg ? null : _avatarColor(nombre),
              child: hasImg
                  ? null
                  : Text(
                      inicial,
                      style: text.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

class _AnimatedServicioItem extends StatelessWidget {
  final Widget child;
  const _AnimatedServicioItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      builder: (_, t, __) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 6),
            child: Transform.scale(
              scale: 0.98 + (t * 0.02),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _ServicioDialogo extends StatefulWidget {
  final dynamic servicio;
  const _ServicioDialogo({this.servicio});

  @override
  State<_ServicioDialogo> createState() => _ServicioDialogoState();
}

class _ServicioDialogoState extends State<_ServicioDialogo> {
  late TextEditingController nombreController;
  late TextEditingController precioController;
  late TextEditingController duracionController;
  late TextEditingController descripcionController;
  String? imagenPath;

  @override
  void initState() {
    super.initState();
    final s = widget.servicio;
    nombreController = TextEditingController(text: s?.nombre ?? '');
    precioController = TextEditingController(text: s?.precio?.toString() ?? '');
    duracionController = TextEditingController(text: s?.duracionMinutos?.toString() ?? '');
    descripcionController = TextEditingController(text: s?.descripcion ?? '');
    imagenPath = s?.imagenPath;
  }

  @override
  void dispose() {
    nombreController.dispose();
    precioController.dispose();
    duracionController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  void _guardar() async {
    final nombre = nombreController.text.trim();
    final precioStr = precioController.text.trim().replaceAll(',', '.');
    final duracionStr = duracionController.text.trim();
    final descripcion = descripcionController.text.trim();
    final localized = AppLocalizations.of(context);

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localized.validationRequired)),
      );
      return;
    }
    final precio = double.tryParse(precioStr);
    if (precio == null || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localized.servicesInvalidPrice)),
      );
      return;
    }
    final duracion = int.tryParse(duracionStr);
    if (duracion == null || duracion <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localized.servicesInvalidDuration)),
      );
      return;
    }

    final provider = context.read<ServiciosProvider>();
    if (widget.servicio == null) {
      await provider.insertarServicio(
        nombre: nombre,
        precio: precio,
        duracionMinutos: duracion,
        descripcion: descripcion.isEmpty ? null : descripcion,
        imagenPath: imagenPath,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localized.servicesCreated)),
        );
      }
    } else {
      await provider.actualizarServicio(
        id: widget.servicio.id,
        nombre: nombre,
        precio: precio,
        duracionMinutos: duracion,
        descripcion: descripcion.isEmpty ? null : descripcion,
        nuevaImagenSeleccionada: imagenPath,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localized.servicesUpdated)),
        );
      }
    }
    if (mounted) Navigator.pop(context, true);
  }

  Widget _extrasSection(String servicioId) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final localized = AppLocalizations.of(context);

    return Consumer<ExtrasServicioProvider>(
      builder: (context, extrasProvider, child) {
        return FutureBuilder<List<ExtrasServicioData>>(
          future: extrasProvider.obtenerExtrasPorServicio(servicioId),
          builder: (context, snapshot) {
            final extras = snapshot.data ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  localized.servicesExtrasSection,
                  style: text.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                ...extras.map(
                  (extra) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      extra.nombre,
                      style: text.bodyMedium,
                    ),
                    subtitle: Text(
                      '+${context.read<SettingsProvider>().formatCurrency(extra.precio)}',
                      style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: scheme.primary),
                          onPressed: () {
                            _mostrarDialogoExtra(context, servicioId, extra: extra);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: scheme.error),
                          onPressed: () async {
                            await extrasProvider.eliminarExtra(extra.id);
                            if (mounted) setState(() {}); // refresca el futurebuilder
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () {
                    _mostrarDialogoExtra(context, servicioId);
                  },
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).servicesAddExtra),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _mostrarDialogoExtra(BuildContext context, String servicioId, {ExtrasServicioData? extra}) {
    final nombreController = TextEditingController(text: extra?.nombre ?? '');
    final precioController = TextEditingController(text: extra?.precio.toString() ?? '');
    final text = Theme.of(context).textTheme;
    final localized = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(extra == null ? localized.servicesAddExtra : localized.servicesEditExtra),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: localized.servicesExtraName),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: localized.servicesExtraPrice),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localized.actionCancel),
          ),
          FilledButton(
            onPressed: () async {
              final nombre = nombreController.text.trim();
              final precio = double.tryParse(precioController.text.trim().replaceAll(',', '.')) ?? 0.0;
              if (nombre.isEmpty || precio <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localized.servicesInvalidData)),
                );
                return;
              }
              final provider = context.read<ExtrasServicioProvider>();
              if (extra == null) {
                await provider.insertarExtra(
                  servicioId: servicioId,
                  nombre: nombre,
                  precio: precio,
                );
              } else {
                await provider.actualizarExtra(
                  id: extra.id,
                  nombre: nombre,
                  precio: precio,
                );
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(extra == null ? localized.actionAdd : localized.actionSave, style: text.labelLarge),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.servicio;
    final esNuevo = s == null;
    final localized = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(esNuevo ? localized.servicesNew : localized.servicesEdit),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagen del servicio
            Center(
              child: CircleAvatar(
                radius: 52,
                backgroundImage: (imagenPath != null && imagenPath!.isNotEmpty)
                    ? FileImage(File(imagenPath!))
                    : null,
                child: (imagenPath == null || imagenPath!.isEmpty)
                    ? Icon(Icons.image, size: 44, color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6))
                    : null,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      setState(() => imagenPath = picked.path);
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: Text(
                    imagenPath == null || imagenPath!.isEmpty
                        ? localized.servicesAddImage
                        : localized.servicesChangeImage,
                  ),
                ),
                if (imagenPath != null && imagenPath!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: localized.servicesRemoveImage,
                    onPressed: () => setState(() => imagenPath = null),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: localized.labelName),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: localized.servicesPrice),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: duracionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: localized.servicesDuration),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descripcionController,
              decoration: InputDecoration(labelText: localized.servicesDescription),
              maxLines: 2,
            ),
            if (!esNuevo) _extrasSection(s.id),
          ],
        ),
      ),
      actions: [

        if (!esNuevo)
          IconButton(
            tooltip: localized.servicesDelete,
            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(localized.servicesDelete),
                  content: Text(localized.servicesConfirmDelete),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text(localized.actionCancel)),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(localized.actionDelete)),
                  ],
                ),
              );
              if (ok == true) {
                await context.read<ServiciosProvider>().eliminarServicio(widget.servicio.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),

        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(localized.actionCancel),
        ),


        FilledButton(
          onPressed: _guardar,
          child: Text(esNuevo ? localized.actionAdd : localized.actionSave),
        ),

      ],
    );
  }
}
