import 'dart:io';
import 'package:flutter/material.dart';

class EntityCard extends StatefulWidget {
  /// “Nuevo” (Añadir)
  final bool isNew;

  /// Tap general de la tarjeta
  final VoidCallback onTap;

  /// Contenido
  final String? title;
  final String? subtitle;
  final String? imagePath;

  /// Personalización del “nuevo”
  final IconData newIcon;
  final String newLabel;

  /// Badge esquina (impagos en clientes, etc.)
  final Widget? cornerBadge;

  const EntityCard({
    super.key,
    required this.onTap,
    this.isNew = false,
    this.title,
    this.subtitle,
    this.imagePath,
    this.newIcon = Icons.add_box,
    this.newLabel = 'Añadir',
    this.cornerBadge,
  });

  @override
  State<EntityCard> createState() => _EntityCardState();
}

class _EntityCardState extends State<EntityCard> {
  bool _hover = false;

  bool get _enableHover {
    final p = Theme.of(context).platform;
    return p == TargetPlatform.windows ||
        p == TargetPlatform.macOS ||
        p == TargetPlatform.linux;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: _enableHover ? (_) => setState(() => _hover = true) : null,
      onExit: _enableHover ? (_) => setState(() => _hover = false) : null,
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        transform: _hover
            ? (Matrix4.identity()..translate(0.0, -4.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hover ? 0.18 : 0.08),
              blurRadius: _hover ? 20 : 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: _buildCard(context, scheme, text),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    ColorScheme scheme,
    TextTheme text,
  ) {
    // --- Tarjeta "Añadir" ---
    if (widget.isNew) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.newIcon,
                  size: 48,
                  color: scheme.onSecondaryContainer,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.newLabel,
                  style: text.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // --- Tarjeta normal ---
    final img = (widget.imagePath ?? '').trim();
    final hasImg = img.isNotEmpty;

    final card = Card(
      color: scheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: scheme.primary.withOpacity(0.08),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 96,
                width: 96,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: hasImg
                        ? Image.file(
                            File(img),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: scheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: scheme.outlineVariant.withOpacity(0.6),
                              ),
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              size: 36,
                              color: scheme.onSurfaceVariant.withOpacity(0.6),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // --- Título ---
              Text(
                widget.title ?? '',
                style: text.titleMedium?.copyWith(
                  color: scheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 6),

              // --- Subtítulo (si hay) ---
              if ((widget.subtitle ?? '').trim().isNotEmpty)
                Text(
                  widget.subtitle!,
                  style: text.bodyMedium?.copyWith(
                    color: scheme.onSecondaryContainer.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );

    // Si hay badge, lo añadimos igual que en clientes
    if (widget.cornerBadge == null) return card;

    return Stack(
      fit: StackFit.expand, // ✅ fuerza a ocupar toda la celda
      children: [
        Positioned.fill(child: card), // ✅ fuerza a que el card llene el stack

        Positioned(
          top: 6,
          right: 6,
          child: IgnorePointer( // opcional, para que no interfiera con hover/tap
            child: widget.cornerBadge!,
          ),
        ),
      ],
    );

  }
}
