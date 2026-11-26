import 'package:flutter/material.dart';

/// SnackBars de la app: verde para exito y rojo para error.
/// Reciben el ScaffoldMessenger (se obtiene antes de cualquier await).
class Mensajes {
  static void exito(ScaffoldMessengerState messenger, String texto) =>
      _mostrar(messenger, texto, Icons.check_circle, Colors.green.shade700);

  static void error(ScaffoldMessengerState messenger, String texto) =>
      _mostrar(messenger, texto, Icons.error_outline, Colors.red.shade700);

  static void _mostrar(
    ScaffoldMessengerState messenger,
    String texto,
    IconData icono,
    Color color,
  ) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: color,
          content: Row(
            children: [
              Icon(icono, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(texto, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
  }
}