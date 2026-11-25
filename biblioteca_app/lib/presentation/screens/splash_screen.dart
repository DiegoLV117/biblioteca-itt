import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../networking/dio_client.dart';

/// Entra primero (initialLocation). Prueba la conexion con GET /
/// y despues navega a Home con go (para no poder regresar al splash).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String _estado = 'Conectando con la API...';
  bool? _ok; // null = todavia probando la conexion

  // Animacion de entrada: aparece (fade) y crece un poco (scale).
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _fade =
      CurvedAnimation(parent: _anim, curve: Curves.easeOut);
  late final Animation<double> _escala = Tween<double>(begin: 0.8, end: 1)
      .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutBack));

  @override
  void initState() {
    super.initState();
    _anim.forward();
    _iniciar();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _iniciar() async {
    final ok = await context.read<DioClient>().probarConexion();
    if (!mounted) return;
    setState(() {
      _ok = ok;
      _estado = ok ? 'Conexión OK' : 'Sin conexión con la API';
    });
    // Si fallo, damos mas tiempo para leer el mensaje.
    await Future.delayed(Duration(milliseconds: ok ? 1200 : 3000));
    if (mounted) context.go('/home');
  }

  /// Muestra un spinner mientras prueba, y despues palomita o error.
  Widget _indicador(TextTheme textos) {
    final Widget icono;
    if (_ok == null) {
      icono = const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
      );
    } else if (_ok!) {
      icono = const Icon(Icons.check_circle, color: Colors.lightGreenAccent);
    } else {
      icono = const Icon(Icons.error_outline, color: Colors.redAccent);
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icono,
            const SizedBox(width: 10),
            Text(_estado,
                style: textos.bodyLarge?.copyWith(color: Colors.white)),
          ],
        ),
        if (_ok == false) ...[
          const SizedBox(height: 8),
          Text(
            'Verifica que Spring Boot esté corriendo en el puerto 8080',
            textAlign: TextAlign.center,
            style: textos.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.azul, AppTheme.azulOscuro],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _escala,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.dorado, width: 3),
                      ),
                      child: const Icon(
                        Icons.local_library,
                        size: 72,
                        color: AppTheme.dorado,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Biblioteca ITT',
                      style:
                          textos.headlineMedium?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Instituto Tecnológico de Tlaxiaco',
                      style: textos.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 32),
                    _indicador(textos),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
