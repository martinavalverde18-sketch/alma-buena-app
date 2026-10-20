# Alma Buena — App móvil

App de **Alma Buena Indumentaria** (Mendoza, Argentina), hecha en **Flutter / Dart**.
Replica el diseño de Figma "Alma Buena — App móvil": mismas pantallas, imágenes,
tipografía (Montserrat), colores y navegación.

## Pantallas

| Ruta | Pantalla |
|---|---|
| `/splash` | Splash con el logo (pantalla inicial) |
| `/ruleta` | Ruleta de beneficios |
| `/ruleta-resultado` | Resultado de la ruleta (50% OFF, 10% OFF, 2x1 o "Seguí participando") |
| `/` | Inicio |
| `/productos` | Catálogo con filtros por categoría |
| `/detalle` | Detalle de producto |
| `/nosotras` | Sobre nosotras |
| `/pagos` | Métodos de pago |
| `/contacto` | Contacto |
| `/comunidad` | Newsletter "Comunidad Alma Buena" |
| `/comunidad-ok` | Confirmación de suscripción |

También tiene menú lateral, barra de pestañas inferior y botón flotante de WhatsApp.

## Estructura

```
lib/
  main.dart             rutas (go_router) y tema
  alma_buena_app.dart   todas las pantallas, íconos, catálogo y ruleta
assets/
  images/               fotos de productos, logos, banner y mapa
  fonts/                Montserrat (licencia OFL)
```

El catálogo (34 productos con precio, color y foto) está en la lista `_kProds`
de `lib/alma_buena_app.dart`. Para cambiar un precio o agregar una prenda se edita ahí.

## Cómo correrla en tu computadora

1. Instalá Flutter: https://docs.flutter.dev/get-started/install
2. En la carpeta del proyecto:

```bash
flutter pub get
flutter run
```

Las carpetas `android/`, `ios/` y `web/` las genera automáticamente GitHub Actions
la primera vez. Si no están, se crean con:

```bash
flutter create --org com.almabuena --project-name alma_buena --platforms=android,ios,web .
```

## Versión web

Cada cambio que se sube a `main` se compila solo (GitHub Actions) y se publica en
GitHub Pages, así se puede ver la app desde el navegador.
