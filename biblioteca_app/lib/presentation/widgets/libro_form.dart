import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/libro.dart';

/// Formulario reutilizable para crear (POST) y editar (PUT).
/// [onGuardar] regresa null si salio bien, o el mensaje de error.
class LibroForm extends StatefulWidget {
  const LibroForm({
    super.key,
    this.inicial,
    required this.textoBoton,
    required this.onGuardar,
  });

  final Libro? inicial;
  final String textoBoton;
  final Future<String?> Function(Libro libro) onGuardar;

  @override
  State<LibroForm> createState() => _LibroFormState();
}

class _LibroFormState extends State<LibroForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _autor;
  late final TextEditingController _anio;
  late bool _disponible;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final l = widget.inicial;
    _titulo = TextEditingController(text: l?.titulo ?? '');
    _autor = TextEditingController(text: l?.autor ?? '');
    _anio = TextEditingController(text: l != null ? '${l.anio}' : '');
    _disponible = l?.disponible ?? true;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _autor.dispose();
    _anio.dispose();
    super.dispose();
  }

  // ---- Validaciones: la API rechaza titulo o autor vacios (400) ----
  String? _validarTitulo(String? v) {
    final texto = v?.trim() ?? '';
    if (texto.isEmpty) return 'Escribe el título';
    if (texto.length < 2) return 'El título es muy corto';
    return null;
  }

  String? _validarAutor(String? v) {
    final texto = v?.trim() ?? '';
    if (texto.isEmpty) return 'Escribe el autor';
    if (texto.length < 3) return 'Escribe el nombre completo del autor';
    return null;
  }

  String? _validarAnio(String? v) {
    final anio = int.tryParse(v?.trim() ?? '');
    if (anio == null) return 'Escribe un año válido';
    final actual = DateTime.now().year;
    if (anio < 1450 || anio > actual) return 'El año debe estar entre 1450 y $actual';
    return null;
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus(); // cierra el teclado
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final base = Libro(
      titulo: _titulo.text.trim(),
      autor: _autor.text.trim(),
      anio: int.parse(_anio.text.trim()),
      disponible: _disponible,
    );
    // Si estamos editando, conservamos el id original.
    final libro = widget.inicial != null
        ? widget.inicial!.copyWith(
            titulo: base.titulo,
            autor: base.autor,
            anio: base.anio,
            disponible: base.disponible,
          )
        : base;

    final messenger = ScaffoldMessenger.of(context);
    final error = await widget.onGuardar(libro);
    if (!mounted) return;
    setState(() => _guardando = false);

    if (error == null) {
      messenger.showSnackBar(const SnackBar(content: Text('Guardado correctamente')));
      context.pop();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  /// Interruptor de disponibilidad dentro de una tarjeta de color.
  Widget _tarjetaDisponible() {
    final color = _disponible ? Colors.green.shade700 : Colors.orange.shade800;
    return Card(
      elevation: 0,
      color: color.withAlpha(25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: color.withAlpha(90)),
      ),
      child: SwitchListTile(
        secondary: Icon(
          _disponible ? Icons.check_circle : Icons.schedule,
          color: color,
        ),
        title: const Text('Disponible para préstamo'),
        subtitle: Text(
          _disponible ? 'Los alumnos pueden pedirlo' : 'Marcado como prestado',
        ),
        value: _disponible,
        onChanged: (v) => setState(() => _disponible = v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Datos del libro', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titulo,
            decoration: const InputDecoration(
              labelText: 'Título',
              hintText: 'Ej. Cien años de soledad',
              prefixIcon: Icon(Icons.title),
            ),
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            validator: _validarTitulo,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _autor,
            decoration: const InputDecoration(
              labelText: 'Autor',
              hintText: 'Ej. Gabriel García Márquez',
              prefixIcon: Icon(Icons.person_outline),
            ),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: _validarAutor,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _anio,
            decoration: const InputDecoration(
              labelText: 'Año de publicación',
              hintText: 'Ej. 1967',
              prefixIcon: Icon(Icons.calendar_today_outlined),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // solo numeros
              LengthLimitingTextInputFormatter(4), // maximo 4 digitos
            ],
            validator: _validarAnio,
          ),
          const SizedBox(height: 12),
          _tarjetaDisponible(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(_guardando ? 'Guardando...' : widget.textoBoton),
            ),
          ),
        ],
      ),
    );
  }
}