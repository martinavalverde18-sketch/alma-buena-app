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
