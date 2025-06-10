import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carga los clientes al iniciar
    Future.microtask(() =>
        context.read<ClientesProvider>().cargarClientes());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClientesProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre cliente',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nombreController.text.trim().isNotEmpty) {
                      provider.insertarCliente(
                        nombre: nombreController.text.trim(),
                      );
                      nombreController.clear();
                    }
                  },
                  child: const Text('Añadir'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: provider.clientes.isEmpty
                ? const Center(child: Text('Sin clientes aún'))
                : ListView.builder(
                    itemCount: provider.clientes.length,
                    itemBuilder: (context, idx) {
                      final c = provider.clientes[idx];
                      return ListTile(
                        title: Text(c.nombre),
                        subtitle: Text(c.email ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => provider.eliminarCliente(c.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
