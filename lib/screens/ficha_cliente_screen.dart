import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';

class FichaClienteScreen extends StatefulWidget {
  final dynamic cliente; // Cambia el tipo si tienes modelo fuerte

  const FichaClienteScreen({super.key, this.cliente});

  @override
  State<FichaClienteScreen> createState() => _FichaClienteScreenState();
}

class _FichaClienteScreenState extends State<FichaClienteScreen> {
  late TextEditingController nombreController;
  late TextEditingController telefonoController;
  late TextEditingController emailController;
  late TextEditingController notasController;
  String? imagenPath;
  String? imagenOriginal; // para comparar si ha cambiado
  String? _validarEmail(String email) {
    if (email.isEmpty) return null;
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email) ? null : 'Email inválido';
  }

  @override
  void initState() {
    super.initState();
    final c = widget.cliente;
    nombreController = TextEditingController(text: c?.nombre ?? '');
    telefonoController = TextEditingController(text: c?.telefono ?? '');
    emailController = TextEditingController(text: c?.email ?? '');
    notasController = TextEditingController(text: c?.notas ?? '');
    imagenPath = c?.imagenPath;
    imagenOriginal = c?.imagenPath;
    
  }

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    notasController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (imagen != null) {
      setState(() {
        imagenPath = imagen.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final esNuevo = widget.cliente == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(esNuevo ? 'Nuevo Cliente' : 'Ficha de Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundImage: imagenPath != null
                        ? Image.file(File(imagenPath!)).image
                        : null,
                    child: imagenPath == null
                        ? const Icon(Icons.person, size: 56)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: _seleccionarImagen,
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        radius: 20,
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notasController,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Notas'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final nombre = nombreController.text.trim();
                final telefono = telefonoController.text.trim();
                final email = emailController.text.trim();
                final notas = notasController.text.trim();
                final imagenSeleccionada = (imagenPath != imagenOriginal) ? imagenPath : null;

                // Validación
                if (nombre.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El nombre es obligatorio')),
                  );
                  return;
                }
                final emailError = _validarEmail(email);
                if (emailError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(emailError)),
                  );
                  return;
                }

                if (esNuevo) {
                  await context.read<ClientesProvider>().insertarCliente(
                    nombre: nombre,
                    telefono: telefono.isEmpty ? null : telefono,
                    email: email.isEmpty ? null : email,
                    notas: notas.isEmpty ? null : notas,
                    imagenSeleccionada: imagenSeleccionada,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cliente creado')),
                  );
                } else {
                  await context.read<ClientesProvider>().actualizarCliente(
                    id: widget.cliente.id,
                    nombre: nombre,
                    telefono: telefono.isEmpty ? null : telefono,
                    email: email.isEmpty ? null : email,
                    notas: notas.isEmpty ? null : notas,
                    nuevaImagenSeleccionada: imagenSeleccionada,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cambios guardados')),
                  );
                }
                if (mounted) Navigator.pop(context);
              },
              child: Text(esNuevo ? 'Crear cliente' : 'Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
