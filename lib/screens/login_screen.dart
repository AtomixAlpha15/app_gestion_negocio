import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/servicios_provider.dart';
import '../providers/citas_provider.dart';
import '../providers/gastos_provider.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginOk;
  const LoginScreen({super.key, required this.onLoginOk});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  bool _cargando = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    final usuario = _usuarioController.text.trim();
    final contrasena = _contrasenaController.text.trim();

    // Hardcoded login
    if (usuario == 'user' && contrasena == '1234') {
      try {
        final anioActual = DateTime.now().year;
        await Future.wait([
          context.read<ClientesProvider>().cargarClientes(),
          context.read<ServiciosProvider>().cargarServicios(),
          context.read<GastosProvider>().cargarGastosAnio(anioActual),
          context.read<CitasProvider>().cargarCitasAnio(anioActual),
        ]);
        widget.onLoginOk();
      } catch (e) {
        setState(() {
          _error = 'Error cargando datos: $e';
        });
      }
    } else {
      setState(() {
        _error = 'Usuario o contraseña incorrectos';
      });
    }

    setState(() {
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SizedBox(
              width: 340,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Iniciar sesión', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _usuarioController,
                    decoration: const InputDecoration(labelText: 'Usuario'),
                    enabled: !_cargando,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _contrasenaController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    enabled: !_cargando,
                  ),
                  const SizedBox(height: 20),
                  if (_error != null) ...[
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _login,
                      child: _cargando
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Entrar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
