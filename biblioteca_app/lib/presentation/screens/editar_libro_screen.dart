import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/libro_controller.dart';
import '../widgets/encabezado_form.dart';
import '../widgets/libro_form.dart';

/// Formulario que hace el PUT. Recibe el id desde la ruta /editar/:id
/// y toma el libro de la lista que ya tiene el controller.
class EditarLibroScreen extends StatelessWidget {
  const EditarLibroScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final c = context.read<LibroController>();
    final libro = c.buscarPorId(id);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar libro')),
      body: libro == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_off, size: 64),
                    const SizedBox(height: 12),
                    Text(
                      'Libro no encontrado',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver'),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                EncabezadoForm(
                  icono: Icons.edit_note,
                  titulo: 'Editar libro #$id',
                  subtitulo: libro.titulo,
                ),
                Expanded(
                  child: LibroForm(
                    inicial: libro,
                    textoBoton: 'Guardar cambios',
                    onGuardar: c.actualizar,
                  ),
                ),
              ],
            ),
    );
  }
}