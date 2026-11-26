import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/utils/mensajes.dart';
import '../../domain/models/libro.dart';
import '../controllers/libro_controller.dart';
import '../widgets/dialogo_confirmar.dart';

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

  /// Abre el formulario de edicion y al regresar recarga el detalle.
  Future<void> _editar(Libro libro) async {
    await context.push('/editar/${libro.id}');
    if (mounted) setState(_cargar);
  }

  /// Pide confirmacion, hace el DELETE y regresa a la lista.
  Future<void> _eliminar(Libro libro) async {
    final messenger = ScaffoldMessenger.of(context);
    final controller = context.read<LibroController>();
    final confirmar = await confirmarEliminar(context, libro.titulo);
    if (!confirmar) return;

    final error = await controller.eliminar(libro.id!);
    if (!mounted) return;
    if (error == null) {
      Mensajes.exito(messenger, 'Libro eliminado');
      context.pop();
    } else {
      Mensajes.error(messenger, error);
    }
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
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _editar(libro),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: cs.error,
                  foregroundColor: cs.onError,
                ),
                onPressed: () => _eliminar(libro),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Eliminar'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}