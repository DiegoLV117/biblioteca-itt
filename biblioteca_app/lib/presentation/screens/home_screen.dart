import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/tema_controller.dart';
import '../controllers/libro_controller.dart';
import '../widgets/libro_tile.dart';
import '../widgets/resumen_header.dart';

/// Lista de libros (GET). Escucha al controller con context.watch.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<LibroController>();
    final tema = context.watch<TemaController>();

    Widget cuerpo;
    if (c.loading) {
      cuerpo = const Center(child: CircularProgressIndicator());
    } else if (c.error != null) {
      cuerpo = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 48),
              const SizedBox(height: 12),
              Text(c.error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                  onPressed: c.cargar, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    } else if (c.items.isEmpty) {
      cuerpo = const Center(child: Text('No hay libros registrados'));
    } else {
      cuerpo = RefreshIndicator(
        onRefresh: c.cargar,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 96),
          // +1 porque el primer elemento es el resumen
          itemCount: c.items.length + 1,
          itemBuilder: (_, i) {
            if (i == 0) {
              final disponibles = c.items.where((l) => l.disponible).length;
              return ResumenHeader(
                total: c.items.length,
                disponibles: disponibles,
                prestados: c.items.length - disponibles,
              );
            }
            return LibroTile(libro: c.items[i - 1]);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca ITT'),
        actions: [
          IconButton(
            tooltip: tema.oscuro ? 'Modo claro' : 'Modo oscuro',
            icon: Icon(tema.oscuro ? Icons.light_mode : Icons.dark_mode),
            onPressed: tema.alternar,
          ),
          IconButton(
            tooltip: 'Recargar (GET)',
            icon: const Icon(Icons.refresh),
            onPressed: c.cargar,
          ),
        ],
      ),
      body: cuerpo,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/nuevo'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo libro'),
      ),
    );
  }
}
