import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'alma_buena_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Trae precios y prendas visibles desde Firebase mientras se ve el splash.
  cargarCatalogoDesdeFirebase();
  runApp(const AlmaBuena());
}

/// Cada ruta muestra una pantalla del Figma "Alma Buena — App móvil".
/// Los nombres de ruta son los que usa la navegación dentro de
/// [AlmaBuenaApp] (context.goNamed / context.pushNamed).
GoRoute _ruta(String path, String name, String pantalla) => GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: _Pantalla(pantalla),
      ),
    );

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    _ruta('/splash', 'Splash', 'splash'),
    _ruta('/ruleta', 'Ruleta', 'ruleta'),
    _ruta('/ruleta-resultado', 'RuletaResultado', 'ruletaResultado'),
    _ruta('/', 'HomePage', 'inicio'),
    _ruta('/productos', 'Productos', 'productos'),
    _ruta('/detalle', 'Detalle', 'detalle'),
    _ruta('/nosotras', 'Nosotras', 'nosotras'),
    _ruta('/pagos', 'Pagos', 'pagos'),
    _ruta('/contacto', 'Contacto', 'contacto'),
    _ruta('/comunidad', 'Comunidad', 'comunidad'),
    _ruta('/comunidad-ok', 'ComunidadOK', 'comunidadOK'),
  ],
);

class AlmaBuena extends StatelessWidget {
  const AlmaBuena({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Alma Buena',
      debugShowCheckedModeBanner: false,
      // Material 2, igual que FlutterFlow: sin el interlineado extra de
      // Material 3, así los textos miden lo mismo que en el Figma.
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5F1725),
          primary: const Color(0xFF5F1725),
        ),
      ),
      routerConfig: _router,
      builder: (context, child) => _MarcoCelular(child: child!),
    );
  }
}

/// En pantallas anchas (computadora o tablet) muestra la app con el tamaño
/// del frame del Figma (390 × 844), centrada como un celular. En el
/// celular no cambia nada: la app ocupa toda la pantalla.
class _MarcoCelular extends StatelessWidget {
  const _MarcoCelular({required this.child});

  final Widget child;

  static const double _ancho = 390;
  static const double _alto = 844;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    if (mq.size.width < 600) return child;

    final alto = (mq.size.height - 48).clamp(560.0, _alto);
    return ColoredBox(
      color: const Color(0xFF1A0A0D),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5F1725), Color(0xFF1A0A0D)],
          ),
        ),
        child: Center(
          child: Container(
            width: _ancho,
            height: alto,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x66000000), blurRadius: 40, offset: Offset(0, 16)),
              ],
            ),
            child: MediaQuery(
              data: mq.copyWith(
                size: Size(_ancho, alto),
                padding: EdgeInsets.zero,
                viewPadding: EdgeInsets.zero,
                viewInsets: EdgeInsets.zero,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _Pantalla extends StatelessWidget {
  const _Pantalla(this.pantalla);

  final String pantalla;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AlmaBuenaApp(pantalla: pantalla),
    );
  }
}
