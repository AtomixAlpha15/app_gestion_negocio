import 'dart:io';
import 'package:app_gestion_negocio/models/cita.dart';
import 'package:app_gestion_negocio/services/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/citas_provider.dart';
import 'ficha_cliente_screen.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final TextEditingController busquedaController = TextEditingController();
  String filtro = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ClientesProvider>().cargarClientes());
  }

  @override
  void dispose() {
    busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final provider = context.watch<ClientesProvider>();
    final clientes = provider.clientes;

    // Filtra clientes por el texto del buscador
    final clientesFiltrados = filtro.isEmpty
        ? clientes
        : clientes.where((c) => c.nombre.toLowerCase().contains(filtro)).toList();

    // El primer elemento es siempre el botón "añadir"
    final items = [
      _ClienteCard(
        esNuevo: true,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FichaClienteScreen(),
            ),
          );
          provider.cargarClientes(); // Recarga al volver
        },
      ),
      ...clientesFiltrados.map(
        (c) => FutureBuilder(
          future: context.read<CitasProvider>().impagosCliente(c.id),
          builder: (context, snapshot) {
            final hayImpagos = (snapshot.data?.isNotEmpty ?? false);

            return _ClienteCard(
              cliente: c,
              tieneImpagos: hayImpagos, // <— ¡clave!
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FichaClienteScreen(cliente: c),
                  ),
                );
                provider.cargarClientes(); // Recarga al volver
              },
              onDelete: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('¿Eliminar cliente?'),
                    content: const Text('Esta acción no se puede deshacer.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await provider.eliminarCliente(c.id, imagenPath: c.imagenPath);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cliente eliminado')),
                    );
                  }
                }
              },
            );
          },
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: busquedaController,
              decoration: const InputDecoration(
                labelText: 'Buscar cliente...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  filtro = value.toLowerCase();
                });
              },
            ),
          ),
          Divider(color: scheme.outlineVariant),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final ancho = constraints.maxWidth;
                  final columnas = (ancho / 220).floor().clamp(1, 6);
                  return GridView.count(
                    crossAxisCount: columnas,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: items,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClienteCard extends StatelessWidget {
  final dynamic cliente;
  final bool esNuevo;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool tieneImpagos; // NEW

  const _ClienteCard({
    this.cliente,
    this.esNuevo = false,
    required this.onTap,
    this.onDelete,
    this.tieneImpagos = false, // NEW
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (esNuevo) {
      return Card(
        clipBehavior: Clip.antiAlias, // importante para overlays
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.person_add, size: 48),
                SizedBox(height: 12),
                Text('Añadir cliente'),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      color: scheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias, // para que el triángulo no se salga
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Contenido
            Center(
              child:Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: cliente.imagenPath != null
                        ? Image.file(File(cliente.imagenPath!)).image
                        : null,
                      child: cliente.imagenPath == null
                        ? const Icon(Icons.person, size: 36)
                        : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      cliente.nombre,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Theme.of(context).colorScheme.error,
                        tooltip: 'Eliminar',
                        onPressed: onDelete,
                      ),
                  ],
                ),
              ),
            ),
            // Badge triangular SOLO si hay impagos, sin texto
            if (tieneImpagos)
              Positioned(
                top: 6,
                right: 6,
                child: ImpagoWarning(),
              ),
          ],
        ),
      ),
    );
  }
}

/// Pequeño triángulo para la esquina superior derecha
class ImpagoWarning extends StatelessWidget {
  const ImpagoWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Icon(
      Icons.warning,
      color: scheme.tertiary,
      size: 28,
    );
  }
}
