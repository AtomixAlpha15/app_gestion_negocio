import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
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
    Future.microtask(() =>
        context.read<ClientesProvider>().cargarClientes());
  }

  @override
  void dispose() {
    busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClientesProvider>();
    final clientes = provider.clientes;

    // Filtra clientes por el texto del buscador
    final clientesFiltrados = filtro.isEmpty
        ? clientes
        : clientes
            .where((c) => c.nombre.toLowerCase().contains(filtro))
            .toList();

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
      ...clientesFiltrados.map((c) => _ClienteCard(
        cliente: c,
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
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
              ],
            ),
          );
          if (confirm == true) {
            await provider.eliminarCliente(c.id, imagenPath: c.imagenPath);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cliente eliminado')),
            );
          }
        },
      )),
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
          const Divider(),
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

  const _ClienteCard({
    this.cliente,
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
                Icon(Icons.person_add, size: 48, color: Colors.blueGrey),
                SizedBox(height: 12),
                Text('Añadir cliente', style: TextStyle(fontSize: 16)),
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
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
