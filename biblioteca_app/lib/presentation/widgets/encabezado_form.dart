import 'package:flutter/material.dart';

/// Banda superior de los formularios: icono + titulo + subtitulo.
class EncabezadoForm extends StatelessWidget {
  const EncabezadoForm({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: cs.primary,
            child: Icon(icono, color: cs.onPrimary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: textos.titleLarge?.copyWith(color: cs.onPrimaryContainer),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textos.bodyMedium?.copyWith(color: cs.onPrimaryContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}