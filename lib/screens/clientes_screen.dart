import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clientes_provider.dart';
import '../providers/citas_provider.dart';
import 'ficha_cliente_screen.dart';
import '../widgets/entity_card.dart';
import '../l10n/app_localizations.dart';
import '../utils/responsive.dart';
import '../widgets/custom_nav.dart';


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
    final mobile = isMobile(context);

    final provider = context.watch<ClientesProvider>();
    final clientes = provider.clientes;

    final q = _norm(filtro);
    final clientesFiltrados = q.isEmpty
        ? clientes
        : clientes.where((s) {
            final nombre = _norm(s.nombre);
            return nombre.contains(q);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).clientsTitle),
        actions: const [UserAvatarAction()],
      ),
      floatingActionButton: mobile
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FichaClienteScreen()),
                );
                if (mounted) provider.cargarClientes();
              },
              child: const Icon(Icons.person_add),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 44,
              child: TextField(
                controller: busquedaController,
                onChanged: (v) => setState(() => filtro = v.trim()),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).clientsSearch,
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
            SizedBox(height: mobile ? 0 : 24),
            Expanded(
              child: mobile
                  ? _buildMobileList(context, clientesFiltrados, provider)
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final ancho = constraints.maxWidth;
                        final columnas = (ancho / 220).floor().clamp(1, 6);
                        final gridKey = ValueKey(
                            clientesFiltrados.map((e) => e.id).join('|'));

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeOutCubic,
                          transitionBuilder: (child, anim) {
                            final fade = CurvedAnimation(
                                parent: anim, curve: Curves.easeOut);
                            final slide = Tween<Offset>(
                              begin: const Offset(0, 0.03),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                                parent: anim,
                                curve: Curves.easeOutCubic));
                            return FadeTransition(
                              opacity: fade,
                              child: SlideTransition(
                                  position: slide, child: child),
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
                                newIcon: Icons.person_add,
                                newLabel:
                                    AppLocalizations.of(context).clientsNew,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const FichaClienteScreen()),
                                  );
                                  provider.cargarClientes();
                                },
                              ),
                              ...clientesFiltrados.map(
                                (c) => _AnimatedClienteItem(
                                  key: ValueKey(c.id),
                                  child: FutureBuilder(
                                    future: context
                                        .read<CitasProvider>()
                                        .impagosCliente(c.id),
                                    builder: (context, snapshot) {
                                      final hayImpagos =
                                          snapshot.data?.isNotEmpty ?? false;
                                      return EntityCard(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  FichaClienteScreen(
                                                      cliente: c),
                                            ),
                                          );
                                          provider.cargarClientes();
                                        },
                                        title: c.nombre,
                                        imagePath: c.imagenPath,
                                        cornerBadge: hayImpagos
                                            ? const Icon(Icons.warning,
                                                size: 28,
                                                color: Colors.orange)
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
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context, List clientesFiltrados,
      ClientesProvider provider) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (clientesFiltrados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 56, color: scheme.outline),
            const SizedBox(height: 12),
            Text(
              filtro.isEmpty ? 'Aún no hay clientes' : 'Sin resultados',
              style: text.bodyLarge
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: clientesFiltrados.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 72, endIndent: 0),
      itemBuilder: (context, index) {
        final c = clientesFiltrados[index];
        return FutureBuilder(
          future: context.read<CitasProvider>().impagosCliente(c.id),
          builder: (context, snapshot) {
            final hayImpagos = snapshot.data?.isNotEmpty ?? false;
            return _ClienteListTile(
              nombre: c.nombre,
              imagePath: c.imagenPath,
              hayImpagos: hayImpagos,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => FichaClienteScreen(cliente: c)),
                );
                if (mounted) provider.cargarClientes();
              },
            );
          },
        );
      },
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

class _ClienteListTile extends StatelessWidget {
  final String nombre;
  final String? imagePath;
  final bool hayImpagos;
  final VoidCallback onTap;

  const _ClienteListTile({
    required this.nombre,
    required this.imagePath,
    required this.hayImpagos,
    required this.onTap,
  });

  Color _avatarBg(String name, ColorScheme scheme) {
    final options = [
      scheme.primaryContainer,
      scheme.secondaryContainer,
      scheme.tertiaryContainer,
      scheme.primary.withValues(alpha: 0.75),
      scheme.secondary.withValues(alpha: 0.75),
      scheme.tertiary.withValues(alpha: 0.75),
    ];
    if (name.isEmpty) return options[0];
    return options[name.codeUnitAt(0) % options.length];
  }

  Color _avatarFg(Color bg) =>
      bg.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final hasImg = (imagePath ?? '').trim().isNotEmpty;
    final inicial = nombre.trim().isEmpty ? '?' : nombre.trim()[0].toUpperCase();
    final bgColor = _avatarBg(nombre, scheme);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: hasImg ? FileImage(File(imagePath!)) : null,
              backgroundColor: hasImg ? null : bgColor,
              child: hasImg
                  ? null
                  : Text(
                      inicial,
                      style: text.titleMedium?.copyWith(
                        color: _avatarFg(bgColor),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                nombre,
                style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hayImpagos) ...[
              Icon(Icons.warning_amber_rounded,
                  color: Colors.orange.shade700, size: 18),
              const SizedBox(width: 8),
            ],
            Icon(Icons.chevron_right, color: scheme.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}
