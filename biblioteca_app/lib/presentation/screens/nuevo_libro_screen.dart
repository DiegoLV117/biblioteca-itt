import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/libro_controller.dart';
import '../widgets/encabezado_form.dart';
import '../widgets/libro_form.dart';

/// Formulario que hace el POST.
class NuevoLibroScreen extends StatelessWidget {
  const NuevoLibroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.read<LibroController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo libro')),
      body: Column(
        children: [
          const EncabezadoForm(
            icono: Icons.library_add,
            titulo: 'Registrar libro',
            subtitulo: 'Llena los datos y presiona Guardar',
          ),
          Expanded(
            child: LibroForm(
              textoBoton: 'Guardar libro',
              onGuardar: c.crear,
            ),
          ),
        ],
      ),
    );
  }
}