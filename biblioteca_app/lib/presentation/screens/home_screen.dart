import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/tema_controller.dart';
import '../../domain/models/libro.dart';
import '../controllers/libro_controller.dart';
import '../widgets/estado_error.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/libro_tile.dart';
import '../widgets/resumen_header.dart';

/// Lista de libros (GET). Escucha al controller con context.watch.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _buscar = TextEditingController();
  int _filtro = 0; // 0 = todos, 1 = disponibles, 2 = prestados

  @override
  void dispose() {
    _buscar.dispose();
    super.dispose();
  }

  /// Filtra por estado y por titulo o autor (sin importar mayusculas).
  List<Libro> _filtrar(List<Libro> libros) {
    final q = _buscar.text.trim().toLowerCase();
    return libros.where((l) {
      if (_filtro == 1 && !l.disponible) return false;
      if (_filtro == 2 && l.disponible) return false;
      if (q.isEmpty) return true;
      return l.titulo.toLowerCase().contains(q) ||
          l.autor.toLowerCase().contains(q);
    }).toList();
  }

  Widget _filtros() {
    const opciones = ['Todos', 'Disponibles', 'Prestados'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          for (var i = 0; i < opciones.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(opciones[i]),
                selected: _filtro == i,
                onSelected: (_) => setState(() => _filtro = i),
              ),
            ),
        ],
      ),
    );
  }

  Widget _barraBusqueda() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: _buscar,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Buscar por título o autor',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _buscar.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Limpiar',
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(_buscar.clear),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<LibroController>();
    final tema = context.watch<TemaController>();

    Widget cuerpo;
    if (c.loading) {
      cuerpo = const Center(child: CircularProgressIndicator());
    } else if (c.error != null) {
      cuerpo = EstadoError(mensaje: c.error!, onReintentar: c.cargar);
    } else if (c.items.isEmpty) {
      cuerpo = const Center(
        child: EstadoVacio(
          icono: Icons.library_books_outlined,
          titulo: 'Aún no hay libros',
          mensaje: 'Registra el primero con el botón Nuevo libro',
        ),
      );
    } else {
      final visibles = _filtrar(c.items);
      final disponibles = c.items.where((l) => l.disponible).length;
      cuerpo = Column(
        children: [
          _barraBusqueda(),
          _filtros(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: c.cargar,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 96),
                // +1 por el resumen; si no hay resultados, +1 por el aviso
                itemCount: visibles.isEmpty ? 2 : visibles.length + 1,
                itemBuilder: (_, i) {
                  if (i == 0) {
                    return ResumenHeader(
                      total: c.items.length,
                      disponibles: disponibles,
                      prestados: c.items.length - disponibles,
                    );
                  }
                  if (visibles.isEmpty) {
                    return const EstadoVacio(
                      icono: Icons.search_off,
                      titulo: 'Sin resultados',
                      mensaje: 'Prueba con otra búsqueda o cambia el filtro',
                    );
                  }
                  return LibroTile(libro: visibles[i - 1]);
                },
              ),
            ),
          ),
        ],
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
