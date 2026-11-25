import 'package:flutter/material.dart';

/// Un solo lugar para colores y tipografia.
/// Paleta institucional TecNM: azul marino + dorado.
class AppTheme {
  static const Color azul = Color(0xFF1B396A);
  static const Color azulOscuro = Color(0xFF0D1F3C);
  static const Color dorado = Color(0xFFC9A227);
  static const Color verde = Color(0xFF2E7D32);
  static const Color naranja = Color(0xFFEF6C00);

  static final ColorScheme _claro = ColorScheme.fromSeed(
    seedColor: azul,
    brightness: Brightness.light,
  ).copyWith(
    primary: azul,
    secondary: dorado,
    onSecondary: Colors.black,
  );

  static final ColorScheme _oscuro = ColorScheme.fromSeed(
    seedColor: azul,
    brightness: Brightness.dark,
  ).copyWith(
    secondary: dorado,
    onSecondary: Colors.black,
  );

  static final ThemeData light = _construir(_claro);

  static final ThemeData dark = _construir(_oscuro);

  /// Arma el tema a partir de la paleta y ajusta la tipografia.
  static ThemeData _construir(ColorScheme cs) {
    final base = ThemeData(useMaterial3: true, colorScheme: cs);
    final t = base.textTheme;
    final radio = BorderRadius.circular(14);
    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: t.titleLarge?.copyWith(
          color: cs.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerHighest.withAlpha(110),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: radio),
        enabledBorder: OutlineInputBorder(
          borderRadius: radio,
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radio,
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radio,
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radio,
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: radio),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          shape: RoundedRectangleBorder(borderRadius: radio),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.secondary,
        foregroundColor: cs.onSecondary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: t.copyWith(
        headlineMedium: t.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineSmall: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        titleLarge: t.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        titleMedium: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        bodySmall: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        labelLarge: t.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
