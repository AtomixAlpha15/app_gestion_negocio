import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_database.dart';
import '../providers/servicios_provider.dart';
import '../providers/extras_servicio_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/entity_card.dart';

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


    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Buscador ---
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
                hintText: 'Buscar servicio...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpiar',
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

          const SizedBox(height: 24),

          // --- Grid ---
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
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

                final ancho = constraints.maxWidth;
                final columnas = (ancho / 220).floor().clamp(1, 6);
                final filtered = filtrados;
                final gridKey = ValueKey(filtered.map((e) => e.id).join('|'));

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  transitionBuilder: (child, anim) {
                    final fade = CurvedAnimation(parent: anim, curve: Curves.easeOut);
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 0.03),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));

                    return FadeTransition(
                      opacity: fade,
                      child: SlideTransition(position: slide, child: child),
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
                        newLabel: 'Añadir servicio',
                        onTap: () => _mostrarDialogoServicio(),
                      ),

                      ...filtered.map(
                        (s) => _AnimatedServicioItem(
                          key: ValueKey(s.id),
                          child: EntityCard(
                            onTap: () => _mostrarDialogoServicio(servicio: s),
                            title: s.nombre,
                            subtitle: '${s.precio.toStringAsFixed(2)} € · ${s.duracionMinutos} min',
                            imagePath: s.imagenPath, // String? en tu modelo
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
    

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es obligatorio')),
      );
      return;
    }
    final precio = double.tryParse(precioStr);
    if (precio == null || precio <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Precio inválido')),
      );
      return;
    }
    final duracion = int.tryParse(duracionStr);
    if (duracion == null || duracion <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duración inválida')),
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
          const SnackBar(content: Text('Servicio creado')),
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
          const SnackBar(content: Text('Cambios guardados')),
        );
      }
    }
    if (mounted) Navigator.pop(context, true);
  }

  Widget _extrasSection(String servicioId) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

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
                  'Extras para este servicio:',
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
                      '+${extra.precio.toStringAsFixed(2)} €',
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
                  label: const Text('Añadir extra'),
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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(extra == null ? 'Nuevo Extra' : 'Editar Extra'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del extra'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio (€)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final nombre = nombreController.text.trim();
              final precio = double.tryParse(precioController.text.trim().replaceAll(',', '.')) ?? 0.0;
              if (nombre.isEmpty || precio <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Datos inválidos')),
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
            child: Text(extra == null ? 'Crear' : 'Guardar', style: text.labelLarge),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.servicio;
    final esNuevo = s == null;

    return AlertDialog(
      title: Text(esNuevo ? 'Nuevo Servicio' : 'Editar Servicio'),
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
                        ? 'Añadir imagen'
                        : 'Cambiar imagen',
                  ),
                ),
                if (imagenPath != null && imagenPath!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Quitar imagen',
                    onPressed: () => setState(() => imagenPath = null),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio (€)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: duracionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duración (minutos)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 2,
            ),
            if (!esNuevo) _extrasSection(s.id),
          ],
        ),
      ),
      actions: [

        if (!esNuevo)
          IconButton(
            tooltip: 'Eliminar servicio',
            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('¿Eliminar servicio?'),
                  content: const Text('Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
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
          child: const Text('Cancelar'),
        ),


        FilledButton(
          onPressed: _guardar,
          child: Text(esNuevo ? 'Crear' : 'Guardar'),
        ),

      ],
    );
  }
}
