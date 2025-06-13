import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_database.dart';
import '../providers/servicios_provider.dart';
import '../providers/extras_servicio_provider.dart';

class ServiciosScreen extends StatefulWidget {
  const ServiciosScreen({super.key});

  @override
  State<ServiciosScreen> createState() => _ServiciosScreenState();
}

class _ServiciosScreenState extends State<ServiciosScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ServiciosProvider>().cargarServicios());
  }

  void _mostrarDialogoServicio({dynamic servicio}) {
    showDialog(
      context: context,
      builder: (_) => _ServicioDialogo(servicio: servicio),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiciosProvider>();
    final servicios = provider.servicios;

    final items = [
      _ServicioCard(
        esNuevo: true,
        onTap: () => _mostrarDialogoServicio(),
      ),
      ...servicios.map((s) => _ServicioCard(
        servicio: s,
        onTap: () => _mostrarDialogoServicio(servicio: s),
        onDelete: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('¿Eliminar servicio?'),
              content: const Text('Esta acción no se puede deshacer.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
              ],
            ),
          );
          if (confirm == true) {
            await provider.eliminarServicio(s.id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Servicio eliminado')),
            );
          }
        },
      )),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final ancho = constraints.maxWidth;
            final columnas = (ancho / 280).floor().clamp(1, 6);
            return GridView.count(
              crossAxisCount: columnas,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: items,
            );
          },
        ),
      ),
    );
  }
}

class _ServicioCard extends StatelessWidget {
  final dynamic servicio;
  final bool esNuevo;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _ServicioCard({
    this.servicio,
    this.esNuevo = false,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (esNuevo) {
      return Card(
        color: Colors.blueGrey.shade50,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add_box, size: 48, color: Colors.blueGrey),
                SizedBox(height: 12),
                Text('Añadir servicio', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      );
    }
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                servicio.nombre,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                'Precio: ${servicio.precio.toStringAsFixed(2)} €',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                'Duración: ${servicio.duracionMinutos} min',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Eliminar',
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServicioDialogo extends StatefulWidget {
  final dynamic servicio;
  const _ServicioDialogo({ this.servicio});

  @override
  State<_ServicioDialogo> createState() => _ServicioDialogoState();
}

class _ServicioDialogoState extends State<_ServicioDialogo> {
  late TextEditingController nombreController;
  late TextEditingController precioController;
  late TextEditingController duracionController;
  late TextEditingController descripcionController;

  @override
  void initState() {
    super.initState();
    final s = widget.servicio;
    nombreController = TextEditingController(text: s?.nombre ?? '');
    precioController = TextEditingController(text: s?.precio?.toString() ?? '');
    duracionController = TextEditingController(text: s?.duracionMinutos?.toString() ?? '');
    descripcionController = TextEditingController(text: s?.descripcion ?? '');
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
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Servicio creado')),
      );
    } else {
      await provider.actualizarServicio(
        id: widget.servicio.id,
        nombre: nombre,
        precio: precio,
        duracionMinutos: duracion,
        descripcion: descripcion.isEmpty ? null : descripcion,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cambios guardados')),
      );
    }
    if (mounted) Navigator.pop(context);
  }

  Widget _extrasSection(String servicioId) {
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
              const Text('Extras para este servicio:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...extras.map((extra) => ListTile(
                    title: Text('${extra.nombre}'),
                    subtitle: Text('+${extra.precio.toStringAsFixed(2)} €'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () {
                            _mostrarDialogoExtra(context, servicioId, extra: extra);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await extrasProvider.eliminarExtra(extra.id);
                            setState(() {}); // refresca el futurebuilder
                          },
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 8),
              ElevatedButton.icon(
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
  final precioController = TextEditingController(text: extra?.precio?.toString() ?? '');

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
        ElevatedButton(
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
          child: Text(extra == null ? 'Crear' : 'Guardar'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final esNuevo = widget.servicio == null;
    return AlertDialog(
      title: Text(esNuevo ? 'Nuevo Servicio' : 'Editar Servicio'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            if (!esNuevo)
              _extrasSection(widget.servicio.id),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardar,
          child: Text(esNuevo ? 'Crear' : 'Guardar'),
        ),
      ],
    );
  }
}
