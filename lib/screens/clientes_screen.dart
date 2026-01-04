import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/citas_provider.dart';
import 'ficha_cliente_screen.dart';
import '../widgets/entity_card.dart';


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

  String _norm(String s) {
  const from = 'áéíóúüñÁÉÍÓÚÜÑ';
  const to   = 'aeiouunAEIOUUN';
  for (var i = 0; i < from.length; i++) {
    s = s.replaceAll(from[i], to[i]);
  }
  return s.toLowerCase();
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
    final q = _norm(filtro);
    final clientesFiltrados = q.isEmpty
        ? clientes
        : clientes.where((s) {
        final nombre = _norm(s.nombre);
        return nombre.contains(q);
      }).toList();

    // El primer elemento es siempre el botón "añadir"
  


    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                // --- Buscador ---
          SizedBox(
            height: 44,
            child: TextField(
              controller: busquedaController,
              onChanged: (v) => setState(() => filtro = v.trim()),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Buscar cliente...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: filtro.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpiar',
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            filtro = '';
                            busquedaController.clear();
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

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final ancho = constraints.maxWidth;
                final columnas = (ancho / 220).floor().clamp(1, 6);

                // clave única por estado del filtro (imprescindible)
                final gridKey = ValueKey(clientesFiltrados.map((e) => e.id).join('|'));

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
                      // ---- AÑADIR CLIENTE ----
                      EntityCard(
                        isNew: true,
                        newIcon: Icons.person_add,
                        newLabel: 'Añadir cliente',
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FichaClienteScreen()),
                          );
                          provider.cargarClientes();
                        },
                      ),

                      // ---- CLIENTES ----
                      ...clientesFiltrados.map(
                        (c) => _AnimatedClienteItem(
                          key: ValueKey(c.id),
                          child: FutureBuilder(
                            future: context.read<CitasProvider>().impagosCliente(c.id),
                            builder: (context, snapshot) {
                              final hayImpagos = (snapshot.data?.isNotEmpty ?? false);

                              return EntityCard(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FichaClienteScreen(cliente: c),
                                    ),
                                  );
                                  provider.cargarClientes();
                                },
                                title: c.nombre,
                                imagePath: c.imagenPath,
                                cornerBadge: hayImpagos
                                    ? const Icon(
                                        Icons.warning,
                                        size: 28,
                                        color: Colors.orange,
                                      )
                                    : null,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );


              },
            ),
          ),
        ]
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

class _AnimatedClienteItem extends StatelessWidget {
  final Widget child;
  const _AnimatedClienteItem({super.key, required this.child});

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
