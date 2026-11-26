import 'package:flutter/material.dart';

/// Dialogo para confirmar antes de eliminar un libro.
/// Regresa true si el usuario presiona Eliminar.
Future<bool> confirmarEliminar(BuildContext context, String titulo) async {
  final cs = Theme.of(context).colorScheme;
  final respuesta = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Icon(Icons.delete_forever, color: cs.error, size: 40),
      title: const Text('¿Eliminar libro?'),
      content: Text(
        'Se eliminará "$titulo".\nEsta acción no se puede deshacer.',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: cs.error,
            foregroundColor: cs.onError,
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
  return respuesta ?? false;
}