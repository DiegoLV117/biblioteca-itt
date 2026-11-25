import 'package:flutter/material.dart';

/// Guarda si la app esta en modo claro u oscuro.
/// Cada vez que cambia, notifyListeners() redibuja la app.
class TemaController extends ChangeNotifier {
  ThemeMode modo = ThemeMode.light;

  bool get oscuro => modo == ThemeMode.dark;

  void alternar() {
    modo = oscuro ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
