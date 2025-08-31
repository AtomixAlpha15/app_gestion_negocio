import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../services/app_database.dart';

class FichaClienteScreen extends StatefulWidget {
  final dynamic cliente; // ClienteData o null (crear)
  const FichaClienteScreen({super.key, this.cliente});

  @override
  State<FichaClienteScreen> createState() => _FichaClienteScreenState();
}

class _FichaClienteScreenState extends State<FichaClienteScreen> {
  late TextEditingController nombreCtrl;
  late TextEditingController telefonoCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController notasCtrl;
  String? imagenPath;

  bool get esNuevo => widget.cliente == null;

  @override
  void initState() {
    super.initState();
    final c = widget.cliente;
    nombreCtrl   = TextEditingController(text: c?.nombre ?? '');
    telefonoCtrl = TextEditingController(text: c?.telefono ?? '');
    emailCtrl    = TextEditingController(text: c?.email ?? '');
    notasCtrl    = TextEditingController(text: c?.notas ?? '');
    imagenPath   = c?.imagenPath;
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    telefonoCtrl.dispose();
    emailCtrl.dispose();
    notasCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final nombre = nombreCtrl.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El nombre es obligatorio', style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer)),
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer),
      );
      return;
    }

    final provider = context.read<ClientesProvider>();
    if (esNuevo) {
      await provider.insertarCliente(
        nombre: nombre,
        telefono: telefonoCtrl.text.trim().isEmpty ? null : telefonoCtrl.text.trim(),
        email:    emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
        notas:    notasCtrl.text.trim().isEmpty ? null : notasCtrl.text.trim(),
        imagenSeleccionada: imagenPath,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente creado', style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer)),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
        );
        Navigator.pop(context, true);
      }
    } else {
      await provider.actualizarCliente(
        id: widget.cliente.id,
        nombre: nombre,
        telefono: telefonoCtrl.text.trim().isEmpty ? null : telefonoCtrl.text.trim(),
        email:    emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
        notas:    notasCtrl.text.trim().isEmpty ? null : notasCtrl.text.trim(),
        nuevaImagenSeleccionada: imagenPath,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cambios guardados', style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer)),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
        );
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _eliminar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar cliente?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      final provider = context.read<ClientesProvider>();
      await provider.eliminarCliente(widget.cliente.id, imagenPath: widget.cliente.imagenPath);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente eliminado', style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
            backgroundColor: Theme.of(context).colorScheme.errorContainer),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text   = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? 'Nuevo cliente' : 'Ficha de cliente'),
        actions: [
          if (!esNuevo)
            IconButton(
              tooltip: 'Eliminar',
              icon: Icon(Icons.delete, color: scheme.error),
              onPressed: _eliminar,
            ),
          const SizedBox(width: 4),
          FilledButton(
            onPressed: _guardar,
            child: const Text('Guardar'),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda: avatar + acciones
                SizedBox(
                  width: 280,
                  child: Card(
                    color: scheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Avatar / Logo cliente
                          CircleAvatar(
                            radius: 64,
                            backgroundImage: (imagenPath != null && imagenPath!.isNotEmpty)
                                ? Image.file(File(imagenPath!)).image
                                : null,
                            child: (imagenPath == null || imagenPath!.isEmpty)
                                ? Icon(Icons.person, size: 64, color: scheme.onSecondaryContainer.withOpacity(0.6))
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () async {
                                  // Aquí puedes abrir file picker y copiar a carpeta app.
                                  // Por ahora dejamos un TODO para no romper tu flujo.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Selector de imagen pendiente', style: TextStyle(color: scheme.onSecondaryContainer)),
                                      backgroundColor: scheme.secondaryContainer,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.image),
                                label: const Text('Cambiar imagen'),
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
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Columna derecha: datos
                Expanded(
                  child: Card(
                    color: scheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Datos del cliente', style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: nombreCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: telefonoCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Teléfono',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: emailCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: notasCtrl,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Notas',
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Placeholder de alertas (impagos, histórico, etc. se añadirá en fases posteriores)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: scheme.tertiaryContainer.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: scheme.outlineVariant),
                            ),
                            child: Text(
                              'Historial, totales gastados y avisos de impagos llegarán aquí más adelante.',
                              style: text.bodyMedium?.copyWith(color: scheme.onSurface),
                            ),
                          ),
                        ],
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
