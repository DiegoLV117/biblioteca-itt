import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/libro.dart';
import '../controllers/libro_controller.dart';

/// Tarjeta de un libro con los botones Editar (PUT) y Eliminar (DELETE).
class LibroTile extends StatelessWidget {
  const LibroTile({super.key, required this.libro});
  final Libro libro;

  Future<void> _confirmarEliminar(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final controller = context.read<LibroController>();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar libro'),
        content: Text('¿Eliminar "${libro.titulo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmar != true) return;

    final error = await controller.eliminar(libro.id!);
    messenger.showSnackBar(SnackBar(content: Text(error ?? 'Libro eliminado')));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final color = libro.disponible ? AppTheme.verde : AppTheme.naranja;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: cs.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: InkWell(
        // Al tocar la tarjeta se abre el detalle (GET /api/libros/{id})
        onTap: () => context.push('/libro/${libro.id}'),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
          child: Row(
            children: [
              // "Portada" del libro con el color segun su estado
              Container(
                width: 48,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withAlpha(35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  libro.disponible ? Icons.menu_book : Icons.lock_clock,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      libro.titulo,
                      style: textos.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      libro.autor,
                      style: textos.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text('${libro.anio}', style: textos.bodySmall),
                        const SizedBox(width: 8),
                        _EstadoChip(disponible: libro.disponible),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Editar (PUT)',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/editar/${libro.id}'),
              ),
              IconButton(
                tooltip: 'Eliminar (DELETE)',
                icon: Icon(Icons.delete_outline, color: cs.error),
                onPressed: () => _confirmarEliminar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Etiqueta de color: verde = Disponible, naranja = Prestado.
class _EstadoChip extends StatelessWidget {
  const _EstadoChip({required this.disponible});
  final bool disponible;

  @override
  Widget build(BuildContext context) {
    final color = disponible ? AppTheme.verde : AppTheme.naranja;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(disponible ? Icons.check_circle : Icons.schedule, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            disponible ? 'Disponible' : 'Prestado',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}