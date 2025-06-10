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
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ClientesProvider>().cargarClientes());
  }

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _anadirCliente() {
    if (nombreController.text.trim().isEmpty) return;
    context.read<ClientesProvider>().insertarCliente(
          nombre: nombreController.text.trim(),
          telefono: telefonoController.text.trim().isEmpty ? null : telefonoController.text.trim(),
          email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        );
    nombreController.clear();
    telefonoController.clear();
    emailController.clear();
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: telefonoController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _anadirCliente,
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
                        subtitle: Text(
                          '${c.telefono ?? ''}${(c.telefono != null && c.email != null) ? ' · ' : ''}${c.email ?? ''}',
                        ),
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
