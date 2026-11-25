import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Tarjeta superior de Home con el conteo de libros.
class ResumenHeader extends StatelessWidget {
  const ResumenHeader({
    super.key,
    required this.total,
    required this.disponibles,
    required this.prestados,
  });

  final int total;
  final int disponibles;
  final int prestados;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.azul, AppTheme.azulOscuro],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _Dato(valor: total, etiqueta: 'Libros', icono: Icons.menu_book),
          _Dato(
              valor: disponibles,
              etiqueta: 'Disponibles',
              icono: Icons.check_circle),
          _Dato(valor: prestados, etiqueta: 'Prestados', icono: Icons.schedule),
        ],
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  const _Dato(
      {required this.valor, required this.etiqueta, required this.icono});
  final int valor;
  final String etiqueta;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        children: [
          Icon(icono, color: AppTheme.dorado, size: 22),
          const SizedBox(height: 6),
          Text(
            '$valor',
            style: textos.headlineSmall?.copyWith(color: Colors.white),
          ),
          Text(
            etiqueta,
            style: textos.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
