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

## Descargar e instalar la app

- **Android:** entrá a [Releases → Alma Buena — última versión](https://github.com/martinavalverde18-sketch/alma-buena-app/releases/latest)
  desde el celular, descargá `alma-buena.apk`, abrilo y tocá *Instalar*
  (Android puede pedir permitir "instalar apps de origen desconocido").
- **iPhone:** abrí https://martinavalverde18-sketch.github.io/alma-buena-app/ en **Safari**
  → botón *Compartir* → **Agregar a pantalla de inicio**. Queda con su ícono y a pantalla completa.

El APK se compila solo con GitHub Actions cada vez que se sube un cambio a `main`
(`.github/workflows/android.yml`).

## Base de datos (Firebase · Cloud Firestore, plan gratuito)

Proyecto de Firebase: **alma-buena-app** · Consola: https://console.firebase.google.com/project/alma-buena-app/firestore

| Colección | Qué guarda |
|---|---|
| `suscriptores` | Los mails que se suman a *Comunidad Alma Buena* (el id es el mail, no se repiten) |
| `giros_ruleta` | Cada premio que sale en la ruleta |
| `consultas` | Cada "Consultar por WhatsApp" desde el detalle de una prenda |
| `productos` | (Opcional) precio y visibilidad de cada prenda: documento con id = nombre en minúsculas y con guiones (ej. `jean-mom-siena`), campos `precio` (número) y `activo` (true/false). Si no existe, la app usa el precio que trae incorporado. |

La conexión está en `lib/firebase_db.dart`. Las reglas de seguridad están en `firestore.rules`
(publicadas en la consola): la app solo puede leer el catálogo y agregar datos; nadie puede leer los
mails ni borrar nada desde la app.

## Estructura

```
lib/
  main.dart             rutas (go_router) y tema
  firebase_db.dart      conexión con la base de datos (Firebase)
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
