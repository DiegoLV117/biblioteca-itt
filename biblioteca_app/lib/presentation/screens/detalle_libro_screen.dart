import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/libro.dart';
import '../controllers/libro_controller.dart';

/// Detalle de un libro. Consume GET /api/libros/{id} (Reto de la practica).
class DetalleLibroScreen extends StatefulWidget {
  const DetalleLibroScreen({super.key, required this.id});
  final int id;

  @override
  State<DetalleLibroScreen> createState() => _DetalleLibroScreenState();
}

class _DetalleLibroScreenState extends State<DetalleLibroScreen> {
  late Future<Libro> _futuro;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _futuro = context.read<LibroController>().repo.getLibro(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del libro')),
      body: FutureBuilder<Libro>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _error(snapshot.error);
          }
          return _detalle(snapshot.data!);
        },
      ),
    );
  }

  /// Si la API responde 404 el libro no existe; otro error = sin conexion.
  Widget _error(Object? e) {
    final es404 = e is DioException && e.response?.statusCode == 404;
    final textos = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(es404 ? Icons.search_off : Icons.wifi_off, size: 64),
            const SizedBox(height: 12),
            Text(
              es404 ? 'El libro no existe' : 'No se pudo conectar con la API',
              style: textos.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              es404
                  ? 'Puede que ya haya sido eliminado (404).'
                  : '¿Está corriendo Spring Boot en el puerto 8080?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => setState(_cargar),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detalle(Libro libro) {
    final cs = Theme.of(context).colorScheme;
    final textos = Theme.of(context).textTheme;
    final color = libro.disponible ? Colors.green.shade700 : Colors.orange.shade800;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // "Portada" grande
        Container(
          height: 170,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(Icons.menu_book, size: 88, color: cs.primary),
        ),
        const SizedBox(height: 20),
        Text(libro.titulo, style: textos.headlineSmall),
        const SizedBox(height: 4),
        Text(
          libro.autor,
          style: textos.titleMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 0,
          color: cs.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: cs.outlineVariant),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Año de publicación'),
                trailing: Text('${libro.anio}', style: textos.titleMedium),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.tag),
                title: const Text('Identificador'),
                trailing: Text('#${libro.id}', style: textos.titleMedium),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  libro.disponible ? Icons.check_circle : Icons.schedule,
                  color: color,
                ),
                title: const Text('Estado'),
                trailing: Text(
                  libro.disponible ? 'Disponible' : 'Prestado',
                  style: textos.titleMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}