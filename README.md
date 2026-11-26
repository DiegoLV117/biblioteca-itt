# Biblioteca ITT

Aplicación móvil en **Flutter** que consume una **API REST en Spring Boot** para administrar los libros de la biblioteca del Instituto Tecnológico de Tlaxiaco. Tiene el CRUD completo: listar (GET), ver detalle (GET por id), registrar (POST), editar (PUT) y eliminar (DELETE).

**Materia:** Desarrollo de Aplicaciones Móviles · Ingeniería en Sistemas Computacionales · TecNM

## Integrantes

| Nombre | No. de control |
|---|---|
| Diego Ernesto López Vásquez | 23620060 |
| Mario Sánchez López | 23620210 |

## Rediseño

- Paleta institucional TecNM (azul marino y dorado) con modo claro y oscuro.
- Splash animado que indica si hay conexión con la API.
- Lista en tarjetas con etiqueta de estado, resumen de libros, búsqueda y filtros.
- Formularios con íconos, validaciones y botón con indicador de carga.
- Pantalla de detalle del libro con manejo del error 404.
- Mensajes de éxito y error con color e ícono.

## Estructura

```
backend/          API Spring Boot (puerto 8080)
biblioteca_app/   App Flutter
  lib/
    core/          tema, colores y utilidades
    networking/    cliente Dio
    services/      rutas de la API
    domain/        modelo Libro y repository
    presentation/  controller, pantallas y widgets
    routes/        navegación con go_router
```

## Cómo ejecutarlo

1. Levantar la API: abrir `backend/.../BibliotecaApiApplication.java` en VS Code y presionar **Run**. Debe aparecer `Tomcat started on port 8080`.
2. Ejecutar la app:

```
cd biblioteca_app
flutter pub get
flutter run
```

En el emulador Android la app se conecta a la PC por `10.0.2.2:8080`; en Chrome, por `localhost:8080`.

## Reporte

[Reporte del rediseño (PDF)](docs/Reporte_Rediseno_Biblioteca_ITT_Diego_Ernesto_Lopez_Vasquez_Y_Mario_Sanchez_Lopez.pdf)