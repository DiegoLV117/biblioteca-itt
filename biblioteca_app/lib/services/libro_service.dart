import 'package:dio/dio.dart';

import '../core/constants/api_config.dart';

/// El service SOLO sabe las rutas. No transforma nada:
/// devuelve el JSON tal cual (List o Map).
class LibroService {
  LibroService(this.dio);
  final Dio dio;

  // ✅ GET /api/libros  -> 200 + lista en JSON
  Future<List<dynamic>> getLibros() async {
    final res = await dio.get(ApiConfig.libros);
    return res.data as List<dynamic>;
  }

  // ✅ POST /api/libros  -> 201 + libro creado en JSON
  Future<Map<String, dynamic>> crear(Map<String, dynamic> body) async {
    final res = await dio.post(ApiConfig.libros, data: body);
    return res.data as Map<String, dynamic>;
  }

  // ---------------------------------------------------------------------------
  // TODO 1a (PUT): completen este metodo.
  //   - Ruta: '${ApiConfig.libros}/$id'   (el id es el @PathVariable de Spring)
  //   - Usen dio.put(ruta, data: body)
  //   - Spring Boot responde 200 con el libro actualizado: regresen res.data
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> actualizar(
      int id, Map<String, dynamic> body) async {
    final res = await dio.put('${ApiConfig.libros}/$id', data: body);
    return res.data as Map<String, dynamic>;
  }

  // ---------------------------------------------------------------------------
  // TODO 1b (DELETE): completen este metodo.
  //   - Ruta: '${ApiConfig.libros}/$id'
  //   - Usen dio.delete(ruta)
  //   - Spring Boot responde 204 (sin JSON): no hay nada que regresar
  // ---------------------------------------------------------------------------
  Future<void> eliminar(int id) async {
    await dio.delete('${ApiConfig.libros}/$id');
  }
}
