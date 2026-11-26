import '../../services/libro_service.dart';
import '../models/libro.dart';

/// El repository convierte el JSON del service en objetos Libro.
/// El controller solo conoce al repository: no sabe que existe Dio.
class LibroRepository {
  LibroRepository(this.service);
  final LibroService service;

  // ✅ GET
  Future<List<Libro>> getLibros() async {
    final data = await service.getLibros();
    return data
        .map((e) => Libro.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // GET por id (pantalla de detalle)
  Future<Libro> getLibro(int id) async {
    final data = await service.getLibro(id);
    return Libro.fromJson(data);
  }

  // ✅ POST
  Future<Libro> crear(Libro libro) async {
    final data = await service.crear(libro.toJson());
    return Libro.fromJson(data);
  }

  // ---------------------------------------------------------------------------
  // TODO 2a (PUT): llamen a service.actualizar(libro.id!, libro.toJson())
  // y conviertan la respuesta con Libro.fromJson(...).
  // ---------------------------------------------------------------------------
  Future<Libro> actualizar(Libro libro) async {
    final data = await service.actualizar(libro.id!, libro.toJson());
    return Libro.fromJson(data);
  }

  // ---------------------------------------------------------------------------
  // TODO 2b (DELETE): llamen a service.eliminar(id).
  // ---------------------------------------------------------------------------
  Future<void> eliminar(int id) async {
    await service.eliminar(id);
  }
}