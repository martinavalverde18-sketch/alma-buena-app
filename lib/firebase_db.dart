// ---------------------------------------------------------------------------
// BASE DE DATOS — Firebase (Cloud Firestore)
//
// La app habla con Firestore por su API REST oficial. Así funciona igual en
// Android, iPhone (versión web instalable) y navegador, sin archivos extra
// de configuración.
//
// Colecciones:
//   productos     → precio y si la prenda está visible (lo editan Marisa y Marti
//                   desde la consola de Firebase; la app lo lee al abrir)
//   suscriptores  → mails que se suman a "Comunidad Alma Buena"
//   giros_ruleta  → cada premio que sale en la ruleta
//   consultas     → cada "Consultar por WhatsApp" desde el detalle de un producto
//
// Las reglas de seguridad (firestore.rules) solo permiten LEER productos y
// AGREGAR suscripciones, giros y consultas. Nadie puede leer los mails desde
// la app ni borrar datos.
// ---------------------------------------------------------------------------
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Datos públicos del proyecto de Firebase (Configuración del proyecto →
/// General). La "Clave de API web" está pensada para ir dentro de la app.
const String kFirebaseProjectId = 'alma-buena-app';
const String kFirebaseApiKey = 'AIzaSyDS8XCAULrbArs7AvBFEfqjbq3-0mXp-Mo';

bool get firebaseConfigurado =>
    !kFirebaseProjectId.startsWith('FIREBASE_') &&
    !kFirebaseApiKey.startsWith('FIREBASE_');

String get _base =>
    'https://firestore.googleapis.com/v1/projects/$kFirebaseProjectId/databases/(default)/documents';

String get _plataforma {
  if (kIsWeb) return 'web';
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return 'android';
    case TargetPlatform.iOS:
      return 'ios';
    default:
      return defaultTargetPlatform.name;
  }
}

Map<String, dynamic> _valor(Object? v) {
  if (v == null) return {'nullValue': null};
  if (v is bool) return {'booleanValue': v};
  if (v is int) return {'integerValue': '$v'};
  if (v is double) return {'doubleValue': v};
  if (v is DateTime) return {'timestampValue': v.toUtc().toIso8601String()};
  return {'stringValue': '$v'};
}

Map<String, dynamic> _doc(Map<String, Object?> campos) =>
    {'fields': campos.map((k, v) => MapEntry(k, _valor(v)))};

/// Convierte un nombre en el id del documento: "Top Pañuelo Seda" → "top-panuelo-seda".
String slugProducto(String nombre) {
  const de = 'áàäâãéèëêíìïîóòöôõúùüûñç';
  const a = 'aaaaaeeeeiiiiooooouuuunc';
  final b = StringBuffer();
  for (final ch in nombre.toLowerCase().split('')) {
    final i = de.indexOf(ch);
    b.write(i >= 0 ? a[i] : ch);
  }
  return b
      .toString()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}

/// Lo que la base dice de cada producto: precio y si se muestra.
class DatosProducto {
  const DatosProducto({this.precio, this.activo = true});
  final int? precio;
  final bool activo;
}

class FirebaseDb {
  FirebaseDb._();

  static const _timeout = Duration(seconds: 12);

  /// Lee la colección "productos". Devuelve {id: datos}. Si no hay conexión
  /// devuelve un mapa vacío y la app usa los precios que trae incorporados.
  static Future<Map<String, DatosProducto>> leerProductos() async {
    if (!firebaseConfigurado) return {};
    try {
      final r = await http
          .get(Uri.parse('$_base/productos?pageSize=300&key=$kFirebaseApiKey'))
          .timeout(_timeout);
      if (r.statusCode != 200) return {};
      final docs = (jsonDecode(r.body)['documents'] as List?) ?? const [];
      final out = <String, DatosProducto>{};
      for (final d in docs) {
        final id = (d['name'] as String).split('/').last;
        final f = (d['fields'] as Map?) ?? const {};
        final p = f['precio'];
        final precio = p == null
            ? null
            : int.tryParse('${p['integerValue'] ?? p['doubleValue'] ?? ''}'
                .split('.')
                .first);
        final activo = f['activo']?['booleanValue'] as bool? ?? true;
        out[id] = DatosProducto(precio: precio, activo: activo);
      }
      return out;
    } catch (e) {
      debugPrint('Firebase: no se pudieron leer productos ($e)');
      return {};
    }
  }

  /// Suma un mail a la Comunidad. El id del documento es el mail, así una
  /// misma persona no queda repetida (si ya estaba, se toma como éxito).
  /// Lanza una excepción si no se pudo guardar.
  static Future<void> suscribir(String email, {required bool notificaciones}) async {
    if (!firebaseConfigurado) {
      throw StateError('Firebase no está configurado');
    }
    final mail = email.trim().toLowerCase();
    final uri = Uri.parse(
        '$_base/suscriptores?documentId=${Uri.encodeQueryComponent(mail)}&key=$kFirebaseApiKey');
    final r = await http
        .post(uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(_doc({
              'email': mail,
              'notificaciones': notificaciones,
              'plataforma': _plataforma,
              'creado': DateTime.now(),
            })))
        .timeout(_timeout);
    if (r.statusCode == 200) return;
    if (r.statusCode == 409) return; // ya estaba suscripta
    throw Exception('Firebase respondió ${r.statusCode}: ${r.body}');
  }

  /// Guarda el premio que salió en la ruleta (no bloquea la app si falla).
  static Future<void> registrarGiro(String premio, String? codigo) =>
      _agregar('giros_ruleta', {
        'premio': premio,
        'codigo': codigo,
        'plataforma': _plataforma,
        'creado': DateTime.now(),
      });

  /// Guarda que alguien consultó por WhatsApp una prenda.
  static Future<void> registrarConsulta(String producto) =>
      _agregar('consultas', {
        'producto': producto,
        'plataforma': _plataforma,
        'creado': DateTime.now(),
      });

  static Future<void> _agregar(String coleccion, Map<String, Object?> campos) async {
    if (!firebaseConfigurado) return;
    try {
      await http
          .post(Uri.parse('$_base/$coleccion?key=$kFirebaseApiKey'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(_doc(campos)))
          .timeout(_timeout);
    } catch (e) {
      debugPrint('Firebase: no se guardó en $coleccion ($e)');
    }
  }
}
