import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

// ---------------------------------------------------------------------------
// ALMA BUENA - app completa (replica del Figma "Alma Buena - App movil")
// Cada ruta de la app (ver main.dart) usa este widget con un valor distinto de
// "pantalla": splash, ruleta, ruletaResultado, inicio, productos, detalle,
// nosotras, pagos, contacto, comunidad, comunidadOK.
// ---------------------------------------------------------------------------

const Color _kB = Color(0xFF5F1725);
const Color _kN = Color(0xFF121212);
const Color _kG = Color(0xFF6B6B6B);
const Color _kL = Color(0xFFE0DCD9);
const Color _kBeige = Color(0xFFF7F3F0);
const Color _kBeige2 = Color(0xFFF3F0EA);
const Color _kRosa = Color(0xFFF4ECED);
const Color _kRosaT = Color(0xFFE8CFD3);
const Color _k33 = Color(0xFF333333);
const Color _k3B = Color(0xFF3B3B3D);
const Color _k9E = Color(0xFF9E9E9E);
const Color _kBD = Color(0xFFBDBDBD);
const Color _kW = Colors.white;

const String _kWaGeneral =
    'https://wa.me/542616395545?text=%C2%A1Hola%20Alma%20Buena!%20Quer%C3%ADa%20hacer%20una%20consulta.';
const String _kWaProducto =
    'https://wa.me/542616395545?text=%C2%A1Hola!%20Quiero%20consultar%20por%20este%20producto%20de%20Alma%20Buena%20%F0%9F%98%8A';
const String _kIg = 'https://www.instagram.com/almabuena.ind/?hl=es';
const String _kTiktok = 'https://www.tiktok.com/@almabuena.ind';
const String _kMail = 'mailto:almabuena.ind@gmail.com';
const String _kMaps = 'https://maps.app.goo.gl/WyT4EkxYpegyDxUr9';

const String _kImgBase = 'assets/images/';
String _img(String k) => '$_kImgBase$k.jpg';
const String _kLogoNegro = '${_kImgBase}logo_negro.png';
const String _kLogoBlanco = '${_kImgBase}logo_blanco.png';
const String _kBanner = '${_kImgBase}banner_app.png';

// ---------------------------------------------------------------------------
// Datos del catalogo
// ---------------------------------------------------------------------------
class _P {
  const _P(this.nombre, this.cat, this.precio, this.color, this.colorCard,
      this.dots, this.img);
  final String nombre;
  final String cat;
  final int precio;
  final String color;
  final String colorCard;
  final List<int> dots;
  final String img;
}

const List<String> _kCats = [
  'Jeans',
  'Shorts',
  'Tops y remeras',
  'Faldas',
  'Bodys',
  'Conjuntos'
];

const Map<String, String> _kCatSub = {
  'Jeans': 'Todos a \$50.000 · Tiro medio/alto',
  'Shorts': '5 modelos',
  'Tops y remeras': '8 modelos',
  'Faldas': '4 modelos',
  'Bodys': '6 modelos',
  'Conjuntos': 'Top + falda a juego, precio por el set',
};

const Map<String, String> _kCatDesc = {
  'Jeans':
      'Jean de calce cómodo y tiro alto, ideal para el día a día. Combinalo con un body o una baby tee.',
  'Shorts':
      'Short de calce cómodo, ideal para armar looks urbanos o de salida.',
  'Tops y remeras':
      'Prenda versátil y cómoda, para usar todos los días o arreglarla para salir.',
  'Faldas':
      'Falda con caída liviana y forro, perfecta para salidas y eventos.',
  'Bodys':
      'Body de calce ajustado que estiliza la figura. Combinalo con jeans o polleras.',
  'Conjuntos':
      'Conjunto de dos piezas para un look completo, se pueden usar por separado.',
};

const List<_P> _kProds = [
  _P('Jean Mom Siena', 'Jeans', 50000, 'Chocolate', 'Chocolate', [0xFF4E3127], 'jean_siena'),
  _P('Jean Wide Leg Nado', 'Jeans', 50000, 'Negro lavado', 'Negro lavado', [0xFF3B3B3D], 'jean_nado'),
  _P('Jean Rombo', 'Jeans', 50000, 'Azul', 'Azul', [0xFF3C5F92], 'jean_rombo'),
  _P('Jean Wide Leg Tini', 'Jeans', 50000, 'Azul', 'Azul', [0xFF3C5F92], 'jean_tini'),
  _P('Jean Wide Leg Celeste', 'Jeans', 50000, 'Celeste', 'Celeste', [0xFFA3BCD8], 'jean_celeste'),
  _P('Jean Wide Leg Roma', 'Jeans', 50000, 'Negro', 'Negro', [0xFF121212], 'jean_roma'),
  _P('Jean Wide Leg Martina', 'Jeans', 50000, 'Celeste', 'Celeste', [0xFFA3BCD8], 'jean_martina'),
  _P('Microshort con Puntilla', 'Shorts', 12500, 'Blanco', 'Blanco', [0xFFFFFFFF], 'short_puntilla'),
  _P('Microshort Cuero con Cierre', 'Shorts', 13500, 'Negro', 'Negro', [0xFF121212], 'short_cierre'),
  _P('Short Cuerina con Bolsillos', 'Shorts', 13000, 'Negro', '2 colores', [0xFF121212, 0xFF4E3127], 'short_bolsillos'),
  _P('Short Cuero Botones Dorados', 'Shorts', 14500, 'Chocolate', 'Chocolate', [0xFF4E3127], 'short_botones'),
  _P('Short Cuero Tiro Bajo', 'Shorts', 12000, 'Negro', 'Negro', [0xFF121212], 'short_tirobajo'),
  _P('Baby Tee Sandy Beach', 'Tops y remeras', 10500, 'Blanco', 'Blanco', [0xFFFFFFFF], 'tee_sandy'),
  _P('Baby Tee Wild Heart', 'Tops y remeras', 12000, 'Negro', 'Negro', [0xFF121212], 'tee_wild'),
  _P('Remera Morley Cuello Redondo', 'Tops y remeras', 9000, 'Rojo', '3 colores', [0xFFC0262D, 0xFF121212, 0xFFFFFFFF], 'remera_roja'),
  _P('Remera Escote V Morley', 'Tops y remeras', 9500, 'Blanco', '2 colores', [0xFFFFFFFF, 0xFF121212], 'remera_v'),
  _P('Remera Manga Japo con Tiras', 'Tops y remeras', 10500, 'Chocolate', 'Chocolate', [0xFF4E3127], 'remera_japo'),
  _P('Blusa Puntilla Cey Brillo', 'Tops y remeras', 13000, 'Negro', 'Negro', [0xFF121212], 'blusa_cey'),
  _P('Top Cey Brillo con Aplique', 'Tops y remeras', 13500, 'Chocolate', 'Chocolate', [0xFF4E3127], 'top_cey'),
  _P('Top Pañuelo Seda con Puntilla', 'Tops y remeras', 14000, 'Negro', 'Negro', [0xFF121212], 'top_panuelo'),
  _P('Mini Lentejuela Vegas', 'Faldas', 13500, 'Chocolate', 'Chocolate', [0xFF4E3127], 'falda_vegas'),
  _P('Mini Tul Lentejuela y Puntilla', 'Faldas', 14500, 'Bordó', 'Bordó', [0xFF5F1725], 'falda_tul'),
  _P('Mini Volado Dallas', 'Faldas', 13000, 'Champagne', 'Champagne', [0xFFD8C9B4], 'falda_dallas'),
  _P('Pollera Mini Encaje Aruba', 'Faldas', 14000, 'Chocolate', 'Chocolate', [0xFF4E3127], 'falda_aruba'),
  _P('Body Americano Microfibra', 'Bodys', 5500, 'Blanco', '3 colores', [0xFFFFFFFF, 0xFF4E3127, 0xFF121212], 'body_americano'),
  _P('Body Morley Cuello Redondo', 'Bodys', 6000, 'Rojo', '2 colores', [0xFFC0262D, 0xFF121212], 'body_collareta'),
  _P('Body Escote Cuadrado', 'Bodys', 6000, 'Negro', '2 colores', [0xFF121212, 0xFFFFFFFF], 'body_cuadrado'),
  _P('Body Hombro Caído Fruncido', 'Bodys', 7000, 'Chocolate', 'Chocolate', [0xFF4E3127], 'body_hombro'),
  _P('Body Olimpia con Puntilla', 'Bodys', 7000, 'Chocolate', '2 colores', [0xFF4E3127, 0xFF121212], 'body_olimpia'),
  _P('Body Aplique Trébol', 'Bodys', 5500, 'Bordó', 'Bordó', [0xFF5F1725], 'body_trebol'),
  _P('Conjunto Cey Brillo Negro', 'Conjuntos', 25000, 'Negro', 'Negro', [0xFF121212], 'blusa_cey'),
  _P('Conjunto Cey Brillo Chocolate', 'Conjuntos', 25500, 'Chocolate', 'Chocolate', [0xFF4E3127], 'top_cey'),
  _P('Conjunto Dallas', 'Conjuntos', 24000, 'Champagne', 'Champagne', [0xFFD8C9B4], 'falda_dallas'),
  _P('Conjunto Encaje Aruba', 'Conjuntos', 26000, 'Chocolate', 'Chocolate', [0xFF4E3127], 'falda_aruba'),
];

const Map<int, String> _kColorNames = {
  0xFF4E3127: 'Chocolate',
  0xFF3B3B3D: 'Negro lavado',
  0xFF3C5F92: 'Azul',
  0xFFA3BCD8: 'Celeste',
  0xFF121212: 'Negro',
  0xFFFFFFFF: 'Blanco',
  0xFFC0262D: 'Rojo',
  0xFF5F1725: 'Bordó',
  0xFFD8C9B4: 'Champagne',
};

String _money(int v) {
  final s = v.toString();
  final b = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final left = s.length - i;
    b.write(s[i]);
    if (left > 1 && left % 3 == 1) b.write('.');
  }
  return '\$' + b.toString();
}

String _cuotas(int p) => '3 cuotas sin interés de ' + _money((p / 3).round());

// ---------------------------------------------------------------------------
// Estado compartido entre pantallas
// ---------------------------------------------------------------------------
String _gCat = 'Todo';
int _gProd = 0;
String _gPremio = ''; // '50', '10', '2x1', 'nada'

// ---------------------------------------------------------------------------
// Iconos (paths exportados del Figma, viewBox 24x24)
// ---------------------------------------------------------------------------
class _IcoPath {
  const _IcoPath(this.d, this.w, {this.fill = false});
  final String d;
  final double w;
  final bool fill;
}

const Map<String, List<_IcoPath>> _kIcons = {
  'wa': [
    _IcoPath('M3.6 20.4001L4.9 16.2001C3.84792 14.3949 3.48905 12.2684 3.89043 10.2178C4.2918 8.16731 5.42597 6.33303 7.08104 5.05769C8.73612 3.78235 10.7989 3.15317 12.884 3.28771C14.9691 3.42225 16.9339 4.31129 18.4113 5.78875C19.8888 7.26621 20.7779 9.23103 20.9124 11.3161C21.0469 13.4012 20.4177 15.464 19.1424 17.1191C17.8671 18.7741 16.0328 19.9083 13.9823 20.3097C11.9318 20.7111 9.80524 20.3523 8 19.3001L3.6 20.4001Z', 1.1),
    _IcoPath('M9.2 8.30013C8.8 11.2001 12.6 15.1001 15.7 14.7001L16.6 13.3001L14.6 12.2001L13.7 13.0001C12.6 12.5001 11.4 11.3001 10.9 10.2001L11.7 9.30013L10.6 7.30013L9.2 8.30013Z', 1.1),
  ],
  'ig': [
    _IcoPath('M15.5 3.5H8.5C5.73857 3.5 3.5 5.73857 3.5 8.5V15.5C3.5 18.2614 5.73857 20.5 8.5 20.5H15.5C18.2614 20.5 20.5 18.2614 20.5 15.5V8.5C20.5 5.73857 18.2614 3.5 15.5 3.5Z', 2.2),
    _IcoPath('M12 16C14.2091 16 16 14.2091 16 12C16 9.79087 14.2091 8 12 8C9.79087 8 8 9.79087 8 12C8 14.2091 9.79087 16 12 16Z', 2.2),
    _IcoPath('M17.2 7.4C17.5314 7.4 17.8 7.1314 17.8 6.8C17.8 6.46866 17.5314 6.20003 17.2 6.20003C16.8687 6.20003 16.6 6.46866 16.6 6.8C16.6 7.1314 16.8687 7.4 17.2 7.4Z', 2.2),
  ],
  'tiktok': [
    _IcoPath('M12.2434 3.01476C13.2102 3 14.1696 3.00738 15.129 3C15.188 4.12914 15.594 5.28042 16.4206 6.07746C17.2471 6.89664 18.4132 7.27302 19.5497 7.39848V10.3726C18.487 10.3357 17.4168 10.1143 16.4501 9.65676C16.0294 9.46488 15.6383 9.22134 15.2545 8.97042C15.2471 11.1254 15.2618 13.2803 15.2398 15.4279C15.1807 16.4611 14.8412 17.487 14.2434 18.3356C13.2766 19.7526 11.6014 20.675 9.88184 20.7046C8.8265 20.7637 7.77116 20.4758 6.8708 19.9445C5.38004 19.0662 4.33208 17.4575 4.1771 15.7306C4.16234 15.3616 4.15496 14.9925 4.16972 14.6309C4.30256 13.2287 4.99628 11.8855 6.07376 10.9704C7.29884 9.90768 9.011 9.39846 10.6125 9.70104C10.6272 10.7933 10.5829 11.8855 10.5829 12.9778C9.85232 12.7416 8.99624 12.808 8.35418 13.2508C7.88924 13.5534 7.535 14.0183 7.3505 14.5423C7.19552 14.9187 7.2398 15.332 7.24718 15.7306C7.4243 16.9409 8.59034 17.9593 9.83018 17.8486C10.6567 17.8412 11.4464 17.3615 11.8744 16.6604C12.0147 16.4168 12.1696 16.1659 12.177 15.8782C12.2508 14.5571 12.2213 13.2434 12.2287 11.9224C12.2361 8.94828 12.2213 5.98152 12.2434 3.01476Z', 0, fill: true),
  ],
  'mail': [
    _IcoPath('M19.5 5.5H4.5C3.67 5.5 3 6.17 3 7V17C3 17.83 3.67 18.5 4.5 18.5H19.5C20.33 18.5 21 17.83 21 17V7C21 6.17 20.33 5.5 19.5 5.5Z', 1.5),
    _IcoPath('M3.5 6.5L12 13L20.5 6.5', 1.5),
  ],
  'pin': [
    _IcoPath('M12 21C12 21 5.5 15.2 5.5 10C5.5 6.41 8.41 3.5 12 3.5C15.59 3.5 18.5 6.41 18.5 10C18.5 15.2 12 21 12 21Z', 1.5),
    _IcoPath('M12 12.3C13.27 12.3 14.3 11.27 14.3 10C14.3 8.73 13.27 7.7 12 7.7C10.73 7.7 9.7 8.73 9.7 10C9.7 11.27 10.73 12.3 12 12.3Z', 1.5),
  ],
  'clock': [
    _IcoPath('M12 20.5C16.69 20.5 20.5 16.69 20.5 12C20.5 7.31 16.69 3.5 12 3.5C7.31 3.5 3.5 7.31 3.5 12C3.5 16.69 7.31 20.5 12 20.5Z', 1.5),
    _IcoPath('M12 7.5V12L15 14', 1.5),
  ],
  'card': [
    _IcoPath('M19.5 5.5H4.5C3.4 5.5 2.5 6.4 2.5 7.5V16.5C2.5 17.6 3.4 18.5 4.5 18.5H19.5C20.6 18.5 21.5 17.6 21.5 16.5V7.5C21.5 6.4 20.6 5.5 19.5 5.5Z', 1.5),
    _IcoPath('M2.5 9.8H21.5M6 15H10', 1.5),
  ],
  'cash': [
    _IcoPath('M20 6.5H4C3.17 6.5 2.5 7.17 2.5 8V16C2.5 16.83 3.17 17.5 4 17.5H20C20.83 17.5 21.5 16.83 21.5 16V8C21.5 7.17 20.83 6.5 20 6.5Z', 1.5),
    _IcoPath('M12 14.6C13.44 14.6 14.6 13.44 14.6 12C14.6 10.56 13.44 9.4 12 9.4C10.56 9.4 9.39999 10.56 9.39999 12C9.39999 13.44 10.56 14.6 12 14.6Z', 1.5),
    _IcoPath('M6 9.5V14.5M18 9.5V14.5', 1.5),
  ],
  'store': [
    _IcoPath('M4 9.5V20H20V9.5M9.5 20V15H14.5V20M3 9.5L4.8 4.5H19.2L21 9.5H3Z', 1.5),
  ],
  'tr': [
    _IcoPath('M4 8.5H19M15.5 5L19 8.5L15.5 12M20 15.5H5M8.5 12L5 15.5L8.5 19', 1.5),
  ],
  'tag': [
    _IcoPath('M3.5 12.5V4.5C3.5 3.95 3.95 3.5 4.5 3.5H12.5L20.5 11.5L11.5 20.5L3.5 12.5Z', 1.5),
    _IcoPath('M8.00001 9.3C8.72001 9.3 9.30001 8.72 9.30001 8C9.30001 7.28 8.72001 6.7 8.00001 6.7C7.28001 6.7 6.70001 7.28 6.70001 8C6.70001 8.72 7.28001 9.3 8.00001 9.3Z', 1.5),
  ],
  'check': [_IcoPath('M5 12.5L9.5 17L19 7.5', 1.5)],
  'arr': [_IcoPath('M4.5 12H19.5M14 6.5L19.5 12L14 17.5', 1.5)],
  'back': [_IcoPath('M19.5 12H4.5M10 6.5L4.5 12L10 17.5', 1.5)],
  'heart': [
    _IcoPath('M12 20C12 20 4.5 15.4 4.5 10C4.55 9.15 4.85 8.34 5.37 7.66C5.88 6.99 6.58 6.48 7.38 6.2C8.19 5.92 9.05 5.89 9.87 6.1C10.69 6.31 11.43 6.77 12 7.4C12.57 6.77 13.31 6.31 14.13 6.1C14.95 5.89 15.81 5.92 16.62 6.2C17.42 6.48 18.12 6.99 18.63 7.66C19.15 8.34 19.45 9.15 19.5 10C19.5 15.4 12 20 12 20Z', 1.5),
  ],
  'spark': [
    _IcoPath('M12 3.5V7.5M12 16.5V20.5M3.5 12H7.5M16.5 12H20.5M6 6L8.5 8.5M15.5 15.5L18 18M6 18L8.5 15.5M15.5 8.5L18 6', 1.5),
  ],
  'home': [
    _IcoPath('M4 10.5L12 4L20 10.5V19.5C20 20.05 19.55 20.5 19 20.5H14.5V14.5H9.5V20.5H5C4.45 20.5 4 20.05 4 19.5V10.5Z', 1.5),
  ],
  'bag': [
    _IcoPath('M6 7.5H18L19.2 20.5H4.8L6 7.5Z', 1.5),
    _IcoPath('M9 10V6.5C9 4.84 10.34 3.5 12 3.5C13.66 3.5 15 4.84 15 6.5V10', 1.5),
  ],
  'chat': [
    _IcoPath('M20.5 12C20.5 16.42 16.69 20 12 20C10.6 20 9.28 19.68 8.12 19.12L3.5 20.5L4.88 16.6C4.01 15.29 3.5 13.7 3.5 12C3.5 7.58 7.31 4 12 4C16.69 4 20.5 7.58 20.5 12Z', 1.5),
  ],
  'menu': [_IcoPath('M3.5 7H20.5M3.5 12H20.5M3.5 17H14', 1.5)],
  'close': [_IcoPath('M6 6L18 18M18 6L6 18', 1.5)],
  'chevron': [_IcoPath('M9 5.5L15.5 12L9 18.5', 1.5)],
  'gift': [
    _IcoPath('M4 11H20V20.5H4V11Z', 1.5),
    _IcoPath('M3 7.5H21V11H3V7.5Z', 1.5),
    _IcoPath('M12 7.5V20.5', 1.5),
    _IcoPath('M12 7.5C12 7.5 11 3.5 8.5 3.5C7.12 3.5 6.5 4.4 6.5 5.4C6.5 6.6 7.6 7.5 9 7.5H12Z', 1.5),
    _IcoPath('M12 7.5C12 7.5 13 3.5 15.5 3.5C16.88 3.5 17.5 4.4 17.5 5.4C17.5 6.6 16.4 7.5 15 7.5H12Z', 1.5),
  ],
  'bell': [
    _IcoPath('M18 9.5C18 6.19 15.31 3.5 12 3.5C8.69 3.5 6 6.19 6 9.5V14L4.5 17H19.5L18 14V9.5Z', 1.5),
    _IcoPath('M10 20C10.4 20.6 11.15 21 12 21C12.85 21 13.6 20.6 14 20', 1.5),
  ],
  'copy': [
    _IcoPath('M9 9H19.5V19.5H9V9Z', 1.5),
    _IcoPath('M15 9V4.5H4.5V15H9', 1.5),
  ],
  'star': [
    _IcoPath('M12 3.5L14.6 8.8L20.5 9.7L16.25 13.8L17.25 19.6L12 16.85L6.75 19.6L7.75 13.8L3.5 9.7L9.4 8.8L12 3.5Z', 1.5),
  ],
};

Path _parseSvgPath(String d) {
  final path = Path();
  final re = RegExp(r'[MLHVCZmlhvcz]|-?\d*\.?\d+(?:[eE]-?\d+)?');
  final tokens = re.allMatches(d).map((m) => m.group(0)!).toList();
  int i = 0;
  String cmd = 'M';
  double cx = 0, cy = 0, sx = 0, sy = 0;
  bool isCmd(String t) => RegExp(r'^[MLHVCZmlhvcz]$').hasMatch(t);
  double n() => double.parse(tokens[i++]);
  while (i < tokens.length) {
    if (isCmd(tokens[i])) {
      cmd = tokens[i++];
      if (cmd == 'Z' || cmd == 'z') {
        path.close();
        cx = sx;
        cy = sy;
        continue;
      }
    }
    switch (cmd) {
      case 'M':
        cx = n();
        cy = n();
        sx = cx;
        sy = cy;
        path.moveTo(cx, cy);
        cmd = 'L';
        break;
      case 'L':
        cx = n();
        cy = n();
        path.lineTo(cx, cy);
        break;
      case 'H':
        cx = n();
        path.lineTo(cx, cy);
        break;
      case 'V':
        cy = n();
        path.lineTo(cx, cy);
        break;
      case 'C':
        final x1 = n(), y1 = n(), x2 = n(), y2 = n();
        cx = n();
        cy = n();
        path.cubicTo(x1, y1, x2, y2, cx, cy);
        break;
      default:
        i++;
    }
  }
  return path;
}

final Map<String, List<Path>> _kPathCache = {};

class _IcoPainter extends CustomPainter {
  _IcoPainter(this.name, this.color);
  final String name;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final parts = _kIcons[name] ?? const <_IcoPath>[];
    final paths = _kPathCache.putIfAbsent(
        name, () => parts.map((p) => _parseSvgPath(p.d)).toList());
    canvas.save();
    canvas.scale(size.width / 24, size.height / 24);
    for (int k = 0; k < parts.length; k++) {
      final p = Paint()
        ..color = color
        ..isAntiAlias = true;
      if (parts[k].fill) {
        p.style = PaintingStyle.fill;
      } else {
        p.style = PaintingStyle.stroke;
        p.strokeWidth = parts[k].w;
        p.strokeCap = StrokeCap.round;
        p.strokeJoin = StrokeJoin.round;
      }
      canvas.drawPath(paths[k], p);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _IcoPainter old) =>
      old.name != name || old.color != color;
}

class _Ico extends StatelessWidget {
  const _Ico(this.name, {this.size = 24, this.color = _kN});
  final String name;
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _IcoPainter(name, color)));
}

// ---------------------------------------------------------------------------
// Helpers de estilo
// ---------------------------------------------------------------------------
TextStyle _t(double size, FontWeight w, Color c, {double ls = 0, double? h}) =>
    TextStyle(
        fontFamily: 'Montserrat',
        fontSize: size,
        fontWeight: w,
        color: c,
        letterSpacing: size * ls,
        height: h);

const FontWeight _r = FontWeight.w400;
const FontWeight _m = FontWeight.w500;
const FontWeight _sb = FontWeight.w600;
const FontWeight _b = FontWeight.w700;

Widget _eyebrow(String s, {Color c = _kB, TextAlign? align}) => Text(
    s.toUpperCase(),
    textAlign: align,
    style: _t(11, _m, c, ls: 0.24));

Future<void> _open(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

Widget _tap(Widget child, VoidCallback onTap) => GestureDetector(
    behavior: HitTestBehavior.opaque, onTap: onTap, child: child);

Widget _net(String url,
        {BoxFit fit = BoxFit.cover,
        double? w,
        double? h,
        Alignment align = Alignment.center}) =>
    Image.asset(url,
        fit: fit,
        alignment: align,
        width: w,
        height: h,
        errorBuilder: (c, e, s) =>
            Container(width: w, height: h, color: const Color(0xFFF2F2F2)));

Widget _btn(String label,
    {required VoidCallback onTap,
    Color bg = Colors.transparent,
    Color fg = _kN,
    Color? border,
    String? iconL,
    String? iconR,
    double height = 48,
    double fs = 12,
    FontWeight w = _m,
    double ls = 0.1,
    double iconSize = 18,
    double? radius}) {
  final kids = <Widget>[];
  if (iconL != null) {
    kids.add(_Ico(iconL, size: iconSize, color: fg));
    kids.add(const SizedBox(width: 10));
  }
  kids.add(Flexible(
      child: Text(label.toUpperCase(),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: _t(fs, w, fg, ls: ls))));
  if (iconR != null) {
    kids.add(const SizedBox(width: 10));
    kids.add(_Ico(iconR, size: iconSize, color: fg));
  }
  return _tap(
      Container(
        height: height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: bg,
            borderRadius:
                radius == null ? null : BorderRadius.circular(radius),
            border: border == null ? null : Border.all(color: border)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center, children: kids),
      ),
      onTap);
}

Widget _waBtn({String url = _kWaGeneral, double height = 48}) => _btn(
    'Consultar por WhatsApp',
    onTap: () => _open(url),
    bg: _kB,
    fg: _kW,
    iconL: 'wa',
    height: height);

// ---------------------------------------------------------------------------
// Widget principal
// ---------------------------------------------------------------------------
class AlmaBuenaApp extends StatefulWidget {
  const AlmaBuenaApp({
    super.key,
    this.width,
    this.height,
    this.pantalla,
  });

  final double? width;
  final double? height;
  final String? pantalla;

  @override
  State<AlmaBuenaApp> createState() => _AlmaBuenaAppState();
}

class _AlmaBuenaAppState extends State<AlmaBuenaApp>
    with TickerProviderStateMixin {
  // ruleta
  AnimationController? _spin;
  double _angle = 0;
  double _from = 0;
  double _to = 0;
  bool _girando = false;
  // resultado
  bool _copiado = false;
  // detalle
  int _colorSel = 0;
  int _talleSel = -1;
  // comunidad
  final TextEditingController _mailCtrl = TextEditingController();
  bool _acepto = true;
  // splash
  AnimationController? _load;

  String get _p => (widget.pantalla ?? 'inicio').trim();

  @override
  void initState() {
    super.initState();
    if (_p == 'splash') {
      _load = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1800))
        ..forward();
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) _go('Ruleta');
      });
    }
    if (_p == 'ruleta') {
      _spin = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 4200));
      _spin!.addListener(() {
        final v = Curves.easeOutCubic.transform(_spin!.value);
        setState(() => _angle = _from + (_to - _from) * v);
      });
    }
  }

  @override
  void dispose() {
    _spin?.dispose();
    _load?.dispose();
    _mailCtrl.dispose();
    super.dispose();
  }

  // ---------------- navegacion ----------------
  void _go(String route) {
    context.goNamed(route);
  }

  void _verCat(String cat) {
    _gCat = cat;
    _go('Productos');
  }

  void _verProd(int index) {
    _gProd = index;
    context.pushNamed('Detalle');
  }

  void _back() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      _go('Productos');
    }
  }

  // ---------------- build ----------------
  @override
  Widget build(BuildContext context) {
    switch (_p) {
      case 'splash':
        return _splash();
      case 'ruleta':
        return _ruleta();
      case 'ruletaResultado':
        return _resultado();
      case 'productos':
        return _shell(0 + 1, _productos());
      case 'detalle':
        return _detalle();
      case 'nosotras':
        return _shell(2, _nosotras());
      case 'pagos':
        return _shell(3, _pagos());
      case 'contacto':
        return _shell(5, _contacto());
      case 'comunidad':
        return _shell(4, _comunidad(), wa: false);
      case 'comunidadOK':
        return _shell(4, _comunidadOK(), wa: false);
      default:
        return _shell(0, _inicio());
    }
  }

  // ---------------- estructura comun ----------------
  Widget _shell(int tab, Widget body, {bool wa = true}) {
    return Container(
      color: _kW,
      child: Column(
        children: [
          _header(),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                    child: SingleChildScrollView(
                        key: PageStorageKey<String>('scroll_' + _p),
                        child: body)),
                if (wa)
                  Positioned(
                      right: 16,
                      bottom: 16,
                      child: _tap(
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                                color: _kB, shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: const _Ico('wa', size: 28, color: _kW),
                          ),
                          () => _open(_kWaGeneral))),
              ],
            ),
          ),
          _tabBar(tab),
        ],
      ),
    );
  }

  Widget _header() {
    final top = MediaQuery.of(context).padding.top;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: top, color: _kW),
        Container(
          height: 30,
          color: _kB,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _Ico('card', size: 14, color: _kW),
              const SizedBox(width: 6),
              Text('3 cuotas sin interés', style: _t(11, _r, _kW)),
              const SizedBox(width: 6),
              Text('·', style: _t(11, _r, _kW)),
              const SizedBox(width: 6),
              const _Ico('cash', size: 14, color: _kW),
              const SizedBox(width: 6),
              Flexible(
                  child: Text('20% OFF efectivo o transferencia',
                      overflow: TextOverflow.ellipsis,
                      style: _t(11, _r, _kW))),
            ],
          ),
        ),
        _nav(menu: true),
      ],
    );
  }

  Widget _nav({required bool menu}) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
          color: _kW, border: Border(bottom: BorderSide(color: _kL))),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _tap(_Ico(menu ? 'menu' : 'back', size: 24, color: _kN),
              menu ? _abrirMenu : _back),
          Expanded(
              child: Center(
                  child: _tap(
                      _net(_kLogoNegro, fit: BoxFit.contain, w: 62, h: 40),
                      () => _go('HomePage')))),
          _tap(const _Ico('wa', size: 24, color: _kB),
              () => _open(_kWaGeneral)),
        ],
      ),
    );
  }

  Widget _tabBar(int active) {
    const tabs = [
      ['home', 'Inicio', 'HomePage'],
      ['bag', 'Productos', 'Productos'],
      ['heart', 'Nosotras', 'Nosotras'],
      ['card', 'Pagos', 'Pagos'],
      ['bell', 'Comunidad', 'Comunidad'],
      ['chat', 'Contacto', 'Contacto'],
    ];
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
          color: _kW, border: Border(top: BorderSide(color: _kL))),
      padding: EdgeInsets.only(top: 6, bottom: math.max(bottom, 8)),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final on = i == active;
          final c = on ? _kB : _kG;
          return Expanded(
            child: _tap(
              SizedBox(
                height: 56,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Ico(tabs[i][0], size: 24, color: c),
                    const SizedBox(height: 4),
                    Text(tabs[i][1],
                        maxLines: 1,
                        style: _t(10, on ? _sb : _m, c, ls: 0.04)),
                  ],
                ),
              ),
              () {
                if (i == 1) _gCat = 'Todo';
                _go(tabs[i][2]);
              },
            ),
          );
        }),
      ),
    );
  }

  // ---------------- menu lateral ----------------
  void _abrirMenu() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: const Color(0x73000000),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, a1, a2) {
        final top = MediaQuery.of(ctx).padding.top;
        void ir(String route, {String? cat}) {
          Navigator.of(ctx).pop();
          if (cat != null) {
            _verCat(cat);
          } else {
            if (route == 'Productos') _gCat = 'Todo';
            _go(route);
          }
        }

        Widget item(String label, String route) => _tap(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: _kL))),
              child: Row(children: [
                Expanded(
                    child: Text(label.toUpperCase(),
                        style: _t(14, _m, _kN, ls: 0.12))),
                const _Ico('chevron', size: 18, color: _kG),
              ]),
            ),
            () => ir(route));

        Widget circ(String ico, String url) => _tap(
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, border: Border.all(color: _kL)),
              alignment: Alignment.center,
              child: _Ico(ico, size: 18, color: _kN),
            ),
            () => _open(url));

        return Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: _kW,
            child: SizedBox(
              width: 320,
              height: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: top),
                  SizedBox(
                    height: 64,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, right: 20),
                      child: Row(children: [
                        _net(_kLogoNegro, fit: BoxFit.contain, w: 70, h: 45),
                        const Spacer(),
                        _tap(const _Ico('close', size: 26, color: _kN),
                            () => Navigator.of(ctx).pop()),
                      ]),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          item('Inicio', 'HomePage'),
                          item('Productos', 'Productos'),
                          item('Sobre nosotras', 'Nosotras'),
                          item('Métodos de pago', 'Pagos'),
                          item('Comunidad', 'Comunidad'),
                          item('Contacto', 'Contacto'),
                          const SizedBox(height: 24),
                          _eyebrow('Categorías'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _kCats
                                .map((c) => _tap(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 7),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          border: Border.all(color: _kL)),
                                      child:
                                          Text(c, style: _t(12, _m, _kN)),
                                    ),
                                    () => ir('Productos', cat: c)))
                                .toList(),
                          ),
                          const SizedBox(height: 28),
                          _eyebrow('Horarios'),
                          const SizedBox(height: 8),
                          Row(children: [
                            const _Ico('clock', size: 14, color: _kG),
                            const SizedBox(width: 8),
                            Text('Lunes a sábado:', style: _t(12, _m, _kN)),
                            const SizedBox(width: 8),
                            Flexible(
                                child: Text('10:00–13:30 · 17:30–20:30',
                                    style: _t(11.5, _r, _kG))),
                          ]),
                          const SizedBox(height: 8),
                          Row(children: [
                            const _Ico('clock', size: 14, color: _kG),
                            const SizedBox(width: 8),
                            Text('Domingo:', style: _t(12, _m, _kN)),
                            const SizedBox(width: 8),
                            Text('Cerrado', style: _t(12, _r, _kG)),
                          ]),
                          const SizedBox(height: 8),
                          _tap(
                              Row(children: [
                                const _Ico('pin', size: 14, color: _kG),
                                const SizedBox(width: 8),
                                Text('Paso de los Andes 1997, Mendoza',
                                    style: _t(12, _r, _kG)),
                              ]),
                              () => _open(_kMaps)),
                          const SizedBox(height: 24),
                          Row(children: [
                            circ('ig', _kIg),
                            const SizedBox(width: 12),
                            circ('tiktok', _kTiktok),
                            const SizedBox(width: 12),
                            circ('wa', _kWaGeneral),
                            const SizedBox(width: 12),
                            circ('mail', _kMail),
                          ]),
                          const SizedBox(height: 24),
                          _waBtn(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (ctx, a1, a2, child) => SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(-1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: a1, curve: Curves.easeOut)),
          child: child),
    );
  }

  // ---------------- piezas comunes ----------------
  Widget _secHeader(String eyebrow, String title, {double top = 40}) =>
      Padding(
        padding: EdgeInsets.fromLTRB(20, top, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _eyebrow(eyebrow),
            const SizedBox(height: 6),
            Text(title, style: _t(24, _b, _kN)),
          ],
        ),
      );

  Widget _dot(int color, {double size = 10}) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: Color(color),
            shape: BoxShape.circle,
            border: Border.all(color: _kL, width: 0.5)),
      );

  Widget _card(int index, double width) {
    final p = _kProds[index];
    final dots = <Widget>[];
    for (final d in p.dots) {
      dots.add(_dot(d));
      dots.add(const SizedBox(width: 4));
    }
    return _tap(
      SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
                aspectRatio: 171 / 228,
                child: Container(
                    color: const Color(0xFFF2F2F2),
                    child: _net(_img(p.img)))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.nombre, style: _t(13, _r, _kN)),
                  const SizedBox(height: 4),
                  Text(_money(p.precio), style: _t(15, _sb, _kN)),
                  const SizedBox(height: 4),
                  Text(_cuotas(p.precio), style: _t(10.5, _r, _kG)),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(children: [
                      ...dots,
                      const SizedBox(width: 1),
                      Flexible(
                          child: Text(p.colorCard,
                              overflow: TextOverflow.ellipsis,
                              style: _t(11, _r, _kG))),
                    ]),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(border: Border.all(color: _kN)),
              alignment: Alignment.center,
              child: Text('VER PRODUCTO', style: _t(11, _m, _kN, ls: 0.1)),
            ),
          ],
        ),
      ),
      () => _verProd(index),
    );
  }

  Widget _grid(List<int> items) {
    return LayoutBuilder(builder: (ctx, cons) {
      final w = (cons.maxWidth - 40 - 16) / 2;
      final rows = <Widget>[];
      for (int i = 0; i < items.length; i += 2) {
        if (rows.isNotEmpty) rows.add(const SizedBox(height: 24));
        rows.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _card(items[i], w),
            const SizedBox(width: 16),
            if (i + 1 < items.length) _card(items[i + 1], w),
          ],
        ));
      }
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: rows));
    });
  }

  int _idx(String nombre) => _kProds.indexWhere((p) => p.nombre == nombre);

  // ---------------- INICIO ----------------
  Widget _inicio() {
    Widget beneficio(String ico, String t1, String t2) => Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Ico(ico, size: 24, color: _kB),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t1, style: _t(13, _sb, _kN)),
                    const SizedBox(height: 2),
                    Text(t2, style: _t(11, _r, _kG, h: 1.3)),
                  ],
                ),
              ),
            ],
          ),
        );

    const catImgs = {
      'Jeans': 'jean_roma',
      'Shorts': 'short_puntilla',
      'Tops y remeras': 'blusa_cey',
      'Faldas': 'falda_vegas',
      'Bodys': 'body_hombro',
    };

    Widget redCirc(String ico, String url) => _tap(
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x59FFFFFF))),
          alignment: Alignment.center,
          child: _Ico(ico, size: 18, color: _kW),
        ),
        () => _open(url));

    Widget footLink(String s, String route) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: _tap(Text(s, style: _t(13, _r, _kBD)), () {
          if (route == 'Productos') _gCat = 'Todo';
          _go(route);
        }));

    Widget contactRow(String ico, String s, String url) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: _tap(
            Row(children: [
              _Ico(ico, size: 16, color: _kW),
              const SizedBox(width: 10),
              Flexible(child: Text(s, style: _t(13, _r, _kW))),
            ]),
            () => _open(url)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Banner
        _tap(
            AspectRatio(
                aspectRatio: 390 / 223, child: _net(_kBanner)),
            () => _verCat('Todo')),
        // Beneficios
        Container(
          color: _kBeige,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              beneficio('card', '3 cuotas sin interés',
                  'Con tarjetas de crédito bancarias'),
              const SizedBox(width: 14),
              beneficio('card', '5 cuotas sin interés', 'Con Tarjeta Naranja'),
            ]),
            const SizedBox(height: 18),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              beneficio('cash', '20% OFF', 'En efectivo o transferencia'),
              const SizedBox(width: 14),
              beneficio('store', 'Retiro en el local',
                  'Paso de los Andes 1997, Mendoza'),
            ]),
          ]),
        ),
        _secHeader('Explorá', 'Comprá por categoría'),
        SizedBox(
          height: 225,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: catImgs.length,
            separatorBuilder: (c, i) => const SizedBox(width: 12),
            itemBuilder: (c, i) {
              final cat = catImgs.keys.elementAt(i);
              return _tap(
                SizedBox(
                  width: 148,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 148,
                          height: 197,
                          child: _net(_img(catImgs[cat]!))),
                      const SizedBox(height: 10),
                      Row(children: [
                        Text(cat, style: _t(15, _r, _kN)),
                        const SizedBox(width: 6),
                        const _Ico('arr', size: 16, color: _kN),
                      ]),
                    ],
                  ),
                ),
                () => _verCat(cat),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _tap(
                  Row(children: [
                    Text('VER TODO', style: _t(11, _m, _kN, ls: 0.1)),
                    const SizedBox(width: 6),
                    const _Ico('arr', size: 14, color: _kN),
                  ]),
                  () => _verCat('Todo')),
            ],
          ),
        ),
        _secHeader('Recién llegado', 'Novedades', top: 48),
        _grid([
          _idx('Body Aplique Trébol'),
          _idx('Mini Tul Lentejuela y Puntilla'),
          _idx('Jean Wide Leg Celeste'),
          _idx('Baby Tee Wild Heart'),
        ]),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
          child: _btn('Ver catálogo completo',
              onTap: () => _verCat('Todo'), border: _kN, iconR: 'arr'),
        ),
        AspectRatio(aspectRatio: 390 / 340, child: _net(_img('nosotras'))),
        Container(
          color: _kB,
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eyebrow('Nuestra historia', c: _kRosaT),
              const SizedBox(height: 14),
              Text('Somos Marisa y Marti, mamá e hija.',
                  style: _t(26, _b, _kW, h: 1.12)),
              const SizedBox(height: 14),
              Text(
                  'Creamos Alma Buena desde ese vínculo que nos acompaña todos los días, para ayudarte a encontrar ese outfit que te haga sentir cómoda, segura y auténtica.',
                  style: _t(14, _r, _kW, h: 1.65)),
              const SizedBox(height: 14),
              _btn('Conocé nuestra historia',
                  onTap: () => _go('Nosotras'),
                  border: _kW,
                  fg: _kW,
                  iconR: 'arr'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            children: [
              const _Ico('ig', size: 34, color: _kB),
              const SizedBox(height: 10),
              _eyebrow('Seguinos'),
              const SizedBox(height: 10),
              Text('@almabuena.ind', style: _t(26, _b, _kN)),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: Text(
                    'Mirá los ingresos nuevos, los looks de la semana y todo lo que pasa en el local.',
                    textAlign: TextAlign.center,
                    style: _t(13, _r, _kG, h: 1.5)),
              ),
              const SizedBox(height: 10),
              _tap(
                  Container(
                    height: 48,
                    color: _kN,
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const _Ico('ig', size: 18, color: _kW),
                      const SizedBox(width: 10),
                      Text('IR A INSTAGRAM', style: _t(12, _m, _kW, ls: 0.1)),
                    ]),
                  ),
                  () => _open(_kIg)),
            ],
          ),
        ),
        // Footer
        Container(
          color: _kN,
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _net(_kLogoBlanco, fit: BoxFit.contain, w: 90, h: 58),
              const SizedBox(height: 28),
              SizedBox(
                width: 300,
                child: Text(
                    'Ropa que acompaña. Indumentaria urbana, deportiva y de fiesta en Mendoza.',
                    style: _t(13, _r, _kW, h: 1.6)),
              ),
              const SizedBox(height: 28),
              Row(children: [
                redCirc('ig', _kIg),
                const SizedBox(width: 12),
                redCirc('tiktok', _kTiktok),
                const SizedBox(width: 12),
                redCirc('wa', _kWaGeneral),
                const SizedBox(width: 12),
                redCirc('mail', _kMail),
              ]),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INFORMACIÓN', style: _t(11, _sb, _kW, ls: 0.16)),
                      footLink('Inicio', 'HomePage'),
                      footLink('Productos', 'Productos'),
                      footLink('Sobre nosotras', 'Nosotras'),
                      footLink('Métodos de pago', 'Pagos'),
                      footLink('Contacto', 'Contacto'),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HORARIOS', style: _t(11, _sb, _kW, ls: 0.16)),
                      const SizedBox(height: 10),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Ico('clock', size: 16, color: _kW),
                            const SizedBox(width: 8),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Lunes a sábado',
                                      style: _t(13, _m, _kW)),
                                  const SizedBox(height: 3),
                                  Text('10:00 – 13:30 hs\n17:30 – 20:30 hs',
                                      style: _t(12, _r, _kBD, h: 1.5)),
                                ]),
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _Ico('clock', size: 16, color: _kW),
                            const SizedBox(width: 8),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Domingo', style: _t(13, _m, _kW)),
                                  const SizedBox(height: 3),
                                  Text('Cerrado',
                                      style: _t(12, _r, _kBD, h: 1.5)),
                                ]),
                          ]),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text('CONTACTO', style: _t(11, _sb, _kW, ls: 0.16)),
              contactRow('wa', '+54 261 639-5545', _kWaGeneral),
              contactRow('ig', '@almabuena.ind', _kIg),
              contactRow('mail', 'almabuena.ind@gmail.com', _kMail),
              contactRow('pin', 'Paso de los Andes 1997, Mendoza', _kMaps),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0x26FFFFFF)))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('© 2026 Alma Buena Indumentaria · Mendoza, Argentina',
                        style: _t(11, _r, _k9E)),
                    const SizedBox(height: 6),
                    Text('Catálogo online · Consultas por WhatsApp',
                        style: _t(11, _r, _k9E)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- PRODUCTOS ----------------
  Widget _migas(List<List<String>> parts) {
    // parts: [texto, accion] ; accion '' = actual
    final kids = <Widget>[];
    for (int i = 0; i < parts.length; i++) {
      if (i > 0) {
        kids.add(const SizedBox(width: 6));
        kids.add(Text('/', style: _t(11, _r, _kG)));
        kids.add(const SizedBox(width: 6));
      }
      final last = i == parts.length - 1;
      final txt = Text(parts[i][0],
          overflow: TextOverflow.ellipsis,
          style: last ? _t(11, _m, _kN) : _t(11, _r, _kG));
      if (last) {
        kids.add(Flexible(child: txt));
      } else {
        final a = parts[i][1];
        kids.add(_tap(txt, () {
          if (a == 'HomePage') {
            _go('HomePage');
          } else if (a == 'Productos') {
            _verCat('Todo');
          } else {
            _verCat(a);
          }
        }));
      }
    }
    return Row(children: kids);
  }

  Widget _productos() {
    final cat = _kCats.contains(_gCat) ? _gCat : 'Todo';
    final cats = cat == 'Todo' ? _kCats : [cat];
    final count = cat == 'Todo'
        ? _kProds.length
        : _kProds.where((p) => p.cat == cat).length;
    final chips = ['Todo', ..._kCats];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: _kBeige2,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _migas(cat == 'Todo'
                  ? [
                      ['Inicio', 'HomePage'],
                      ['Productos', '']
                    ]
                  : [
                      ['Inicio', 'HomePage'],
                      ['Productos', 'Productos'],
                      [cat, '']
                    ]),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _eyebrow('Catálogo'),
                    const SizedBox(height: 6),
                    Text(cat == 'Todo' ? 'Todas nuestras prendas' : cat,
                        style: _t(26, _b, _kN)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                    color: _kW, borderRadius: BorderRadius.circular(14)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Ico('tag', size: 18, color: _kB),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                          'Precios publicados. Pagando en efectivo o transferencia tenés 20% OFF sobre el precio publicado.',
                          style: _t(11, _r, _k3B, h: 1.4)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 62,
          decoration: const BoxDecoration(
              color: _kW, border: Border(bottom: BorderSide(color: _kL))),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            itemCount: chips.length,
            separatorBuilder: (c, i) => const SizedBox(width: 8),
            itemBuilder: (c, i) {
              final on = chips[i] == cat;
              return _tap(
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: on ? _kN : _kW,
                      borderRadius: BorderRadius.circular(40),
                      border: on ? null : Border.all(color: _kL)),
                  child: Text(chips[i], style: _t(13, _m, on ? _kW : _kN)),
                ),
                () => setState(() => _gCat = chips[i]),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Text('$count productos', style: _t(12, _r, _kG)),
        ),
        for (final c in cats)
          Padding(
            padding: const EdgeInsets.only(top: 28, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c, style: _t(22, _b, _kN)),
                      const SizedBox(height: 4),
                      Text(_kCatSub[c] ?? '', style: _t(12, _r, _kG)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _grid([
                  for (int i = 0; i < _kProds.length; i++)
                    if (_kProds[i].cat == c) i
                ]),
              ],
            ),
          ),
        const SizedBox(height: 24),
        Container(
          color: _kBeige,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            children: [
              Text('¿No encontrás tu talle o color?',
                  textAlign: TextAlign.center, style: _t(19, _b, _kN)),
              const SizedBox(height: 10),
              Text('Escribinos y te contamos qué hay en el local.',
                  textAlign: TextAlign.center, style: _t(13, _r, _kG)),
              const SizedBox(height: 10),
              _waBtn(),
            ],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  // ---------------- DETALLE ----------------
  Widget _detalle() {
    final idx = (_gProd >= 0 && _gProd < _kProds.length) ? _gProd : 0;
    final p = _kProds[idx];
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final colorSel = _colorSel < p.dots.length ? _colorSel : 0;
    final colorName = colorSel == 0
        ? p.color
        : (_kColorNames[p.dots[colorSel]] ?? p.color);

    // relacionados
    final rel = <int>[];
    for (int i = 0; i < _kProds.length && rel.length < 2; i++) {
      if (i != idx && _kProds[i].cat == p.cat) rel.add(i);
    }
    for (int k = 1; rel.length < 4 && k < _kProds.length; k++) {
      final j = (idx + k * 7) % _kProds.length;
      if (j != idx && !rel.contains(j) && _kProds[j].cat != p.cat) rel.add(j);
    }

    // beneficio ruleta
    Widget? beneficio;
    if (_gPremio == '50' || _gPremio == '10' || _gPremio == '2x1') {
      String t1, t2, code, pct;
      if (_gPremio == '50') {
        t1 = 'Beneficio ruleta: 50% OFF';
        t2 = 'Código ALMA50 · pagás ' + _money((p.precio * 0.5).round());
        code = 'ALMA50';
        pct = '50%25%20OFF';
      } else if (_gPremio == '10') {
        t1 = 'Beneficio ruleta: 10% OFF';
        t2 = 'Código ALMA10 · pagás ' + _money((p.precio * 0.9).round());
        code = 'ALMA10';
        pct = '10%25%20OFF';
      } else {
        t1 = 'Beneficio ruleta: 2x1';
        t2 = 'Código ALMA2X1 · llevás 2 y pagás 1';
        code = 'ALMA2X1';
        pct = '2x1';
      }
      final url = 'https://wa.me/542616395545?text=' +
          '%C2%A1Hola!%20Quiero%20usar%20mi%20beneficio%20de%20la%20ruleta%20(' +
          pct +
          '%2C%20c%C3%B3digo%20' +
          code +
          ')%20en%3A%20' +
          Uri.encodeComponent(p.nombre);
      beneficio = Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        decoration: BoxDecoration(color: _kW, border: Border.all(color: _kB)),
        child: Row(
          children: [
            const _Ico('gift', size: 22, color: _kB),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t1, style: _t(13, _sb, _kB)),
                  const SizedBox(height: 3),
                  Text(t2, style: _t(11.5, _r, _k3B)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _tap(
                Container(
                  color: _kB,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  child: Text('APLICAR', style: _t(11, _sb, _kW, ls: 0.1)),
                ),
                () => _open(url)),
          ],
        ),
      );
    }

    Widget divisor() => Container(height: 1, color: _kL);

    Widget medio(String ico, String a, String b) => Row(
          children: [
            _Ico(ico, size: 22, color: _kN),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(a, style: _t(13, _m, _kN)),
              const SizedBox(height: 1),
              Text(b, style: _t(11.5, _r, _kG)),
            ]),
          ],
        );

    Widget bullet(String s) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(children: [
            const _Ico('check', size: 16, color: _kB),
            const SizedBox(width: 8),
            Flexible(child: Text(s, style: _t(13, _r, _k33))),
          ]),
        );

    final talles = ['34', '36', '38', '40', '42', '44'];

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
            aspectRatio: 390 / 500,
            child: Container(
                color: const Color(0xFFF2F2F2), child: _net(_img(p.img)))),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _migas([
                  ['Inicio', 'HomePage'],
                  ['Productos', 'Productos'],
                  [p.cat, p.cat],
                  [p.nombre, '']
                ]),
              ),
              const SizedBox(height: 6),
              _eyebrow(p.cat),
              const SizedBox(height: 6),
              Text(p.nombre, style: _t(24, _b, _kN, h: 1.12)),
              const SizedBox(height: 12),
              Text(_money(p.precio), style: _t(24, _sb, _kN)),
              const SizedBox(height: 2),
              Text(_cuotas(p.precio), style: _t(13, _r, _kG)),
              const SizedBox(height: 20),
              Container(
                color: _kRosa,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Ico('cash', size: 22, color: _kB),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              _money((p.precio * 0.8).round()) +
                                  ' en efectivo o transferencia',
                              style: _t(14, _sb, _kB)),
                          const SizedBox(height: 4),
                          Text(
                              '20% OFF. El descuento no está incluido en el precio publicado: se aplica al momento de la compra.',
                              style: _t(11.5, _r, _k3B, h: 1.45)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (beneficio != null) ...[
                const SizedBox(height: 20),
                beneficio,
              ],
              const SizedBox(height: 20),
              Row(children: [
                Text('Color:', style: _t(13, _m, _kN)),
                const SizedBox(width: 5),
                Text(colorName, style: _t(13, _r, _kG)),
              ]),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (int i = 0; i < p.dots.length; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    _tap(
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: i == colorSel
                                      ? _kN
                                      : Colors.transparent)),
                          child: _dot(p.dots[i], size: 24),
                        ),
                        () => setState(() => _colorSel = i)),
                  ]
                ],
              ),
              const SizedBox(height: 20),
              Text('Talle', style: _t(13, _m, _kN)),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (int i = 0; i < talles.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    _tap(
                        Container(
                          width: 50,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: i == 5
                                ? const Color(0xFFF2F2F2)
                                : (i == _talleSel ? _kN : _kW),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: i == 5
                                    ? const Color(0xFFE0E0E0)
                                    : (i == _talleSel
                                        ? _kN
                                        : const Color(0xFFC7C7C7))),
                          ),
                          child: Text(talles[i],
                              style: _t(
                                  14,
                                  _m,
                                  i == 5
                                      ? _k9E
                                      : (i == _talleSel ? _kW : _kN))),
                        ), () {
                      if (i != 5) setState(() => _talleSel = i);
                    }),
                  ]
                ],
              ),
              const SizedBox(height: 10),
              Text(
                  'Talle 44: sin stock por el momento. Consultanos por WhatsApp.',
                  style: _t(11, _r, _kG)),
              const SizedBox(height: 20),
              _btn('Ver más ' + p.cat.toLowerCase(),
                  onTap: () => _verCat(p.cat), border: _kN, iconR: 'arr'),
              const SizedBox(height: 20),
              _tap(
                  Row(children: [
                    const _Ico('store', size: 20, color: _kB),
                    const SizedBox(width: 10),
                    Flexible(
                        child: Text(
                            'Retiralo en Paso de los Andes 1997, Mendoza',
                            style: _t(12, _r, _k3B))),
                  ]),
                  () => _open(_kMaps)),
              const SizedBox(height: 20),
              divisor(),
              const SizedBox(height: 20),
              Text('DESCRIPCIÓN', style: _t(12, _sb, _kN, ls: 0.16)),
              const SizedBox(height: 10),
              Text(_kCatDesc[p.cat] ?? '', style: _t(14, _r, _k33, h: 1.65)),
              if (p.cat == 'Jeans') ...[
                bullet('Tiro medio alto'),
                bullet('Pierna amplia de cadera a ruedo'),
                bullet('Cinco bolsillos con cierre y botón'),
              ],
              const SizedBox(height: 20),
              divisor(),
              const SizedBox(height: 20),
              Text('MEDIOS DE PAGO', style: _t(12, _sb, _kN, ls: 0.16)),
              const SizedBox(height: 14),
              medio('card', 'Tarjetas de crédito bancarias',
                  '3 cuotas sin interés'),
              const SizedBox(height: 14),
              medio('card', 'Tarjeta Naranja', '5 cuotas sin interés'),
              const SizedBox(height: 14),
              medio('tr', 'Transferencia', '20% OFF sobre el precio publicado'),
              const SizedBox(height: 14),
              medio('cash', 'Efectivo', '20% OFF sobre el precio publicado'),
            ],
          ),
        ),
        Container(
          color: _kBeige,
          padding: const EdgeInsets.only(top: 32, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _eyebrow('Combiná tu look'),
                    const SizedBox(height: 6),
                    Text('También te puede gustar', style: _t(21, _b, _kN)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 380,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: rel.length,
                  separatorBuilder: (c, i) => const SizedBox(width: 14),
                  itemBuilder: (c, i) => Align(
                      alignment: Alignment.topCenter,
                      child: _card(rel[i], 171)),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      color: _kW,
      child: Column(
        children: [
          Container(height: top, color: _kW),
          _nav(menu: false),
          Expanded(
              child: SingleChildScrollView(
                  key: PageStorageKey<String>('det_' + p.nombre),
                  child: body)),
          Container(
            decoration: const BoxDecoration(
                color: _kW, border: Border(top: BorderSide(color: _kL))),
            padding: EdgeInsets.fromLTRB(20, 12, 20, math.max(bottom, 12)),
            child: _waBtn(url: _kWaProducto, height: 52),
          ),
        ],
      ),
    );
  }

  // ---------------- NOSOTRAS ----------------
  Widget _nosotras() {
    Widget valor(String ico, String t, String d) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(border: Border.all(color: _kL)),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration:
                    const BoxDecoration(color: _kRosa, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: _Ico(ico, size: 20, color: _kB),
              ),
              const SizedBox(height: 10),
              Text(t, style: _t(18, _r, _kN)),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: Text(d,
                    textAlign: TextAlign.center,
                    style: _t(13, _r, _kG, h: 1.55)),
              ),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
            aspectRatio: 390 / 380,
            child: _net(_img('nosotras'), align: Alignment.topCenter)),
        Container(
          color: _kB,
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eyebrow('Nuestra historia', c: _kRosaT),
              const SizedBox(height: 16),
              Text('Sobre nosotras', style: _t(30, _b, _kW)),
              const SizedBox(height: 16),
              Text(
                  'Somos Marisa y Marti, mamá e hija, y creamos Alma Buena desde ese vínculo que nos acompaña todos los días.',
                  style: _t(16, _r, _kW, h: 1.55)),
              const SizedBox(height: 16),
              Text(
                  'Nuestra idea es poder ayudar a otras personas a encontrar ese outfit que las haga sentirse cómodas, seguras y auténticas, incluso en los momentos difíciles.',
                  style: _t(13, _r, _kW, h: 1.65)),
              const SizedBox(height: 16),
              Text(
                  'Así como nos acompañamos entre nosotras, queremos que cada persona que llegue a Alma Buena también pueda sentirse acompañada, porque creemos que sentirse bien con una misma muchas veces empieza por algo tan simple como la ropa que elegimos usar.',
                  style: _t(13, _r, _kW, h: 1.65)),
              const SizedBox(height: 16),
              Text('— Marisa & Marti', style: _t(16, _r, _kW)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
          child: Column(
            children: [
              _eyebrow('Lo que nos mueve', align: TextAlign.center),
              const SizedBox(height: 16),
              Text('Cómo queremos que te sientas',
                  textAlign: TextAlign.center, style: _t(22, _b, _kN)),
              const SizedBox(height: 16),
              valor('heart', 'Cómoda',
                  'Prendas para moverte libre y sentirte bien de la mañana a la noche.'),
              const SizedBox(height: 16),
              valor('spark', 'Segura',
                  'Ropa que te acompaña y te hace sentir firme, incluso en los días difíciles.'),
              const SizedBox(height: 16),
              valor('check', 'Auténtica',
                  'Elegir lo que va con vos, con tu estilo y tu momento, sin seguir moldes.'),
            ],
          ),
        ),
        Container(
          color: _kBeige,
          padding: const EdgeInsets.fromLTRB(20, 36, 20, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eyebrow('Visitanos'),
              const SizedBox(height: 12),
              Text('Te esperamos en el local', style: _t(22, _b, _kN)),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Ico('pin', size: 18, color: _kB),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        'Paso de los Andes 1997, Mendoza · Lunes a sábado 10:00–13:30 y 17:30–20:30 hs',
                        style: _t(12, _r, _kG, h: 1.5)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _btn('Ver catálogo',
                  onTap: () => _verCat('Todo'),
                  bg: _kN,
                  fg: _kW,
                  iconR: 'arr'),
              const SizedBox(height: 12),
              _btn('Cómo llegar',
                  onTap: () => _open(_kMaps),
                  bg: _kW,
                  border: _kN,
                  iconL: 'pin',
                  height: 50),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- PAGOS ----------------
  Widget _encabezado(String eyebrow, String title, String text) => Container(
        color: _kBeige2,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _eyebrow(eyebrow),
            const SizedBox(height: 8),
            Text(title, style: _t(28, _b, _kN)),
            const SizedBox(height: 8),
            Text(text, style: _t(13, _r, _kG, h: 1.5)),
          ],
        ),
      );

  Widget _pagos() {
    Widget item(String s) => Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: _Ico('check', size: 16, color: _kB)),
              const SizedBox(width: 8),
              Expanded(child: Text(s, style: _t(13, _r, _k33, h: 1.5))),
            ],
          ),
        );

    Widget opcion(String ico, String title, String tag, List<String> items) =>
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(border: Border.all(color: _kL)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                      color: _kRosa, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: _Ico(ico, size: 20, color: _kB),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: _t(18, _r, _kN)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                          color: _kB, borderRadius: BorderRadius.circular(20)),
                      child: Text(tag, style: _t(10, _m, _kW)),
                    ),
                  ],
                ),
              ]),
              ...items.map(item),
            ],
          ),
        );

    Widget caja(String label, String value,
            {bool blanca = false}) =>
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
              color: blanca ? _kW : Colors.transparent,
              border: blanca
                  ? null
                  : Border.all(color: const Color(0x59FFFFFF))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label.toUpperCase(),
                  style: _t(10, _m, blanca ? _kB : _kW, ls: 0.16)),
              Text(value,
                  style: _t(20, blanca ? _sb : _r, blanca ? _kB : _kW)),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _encabezado('Cómo pagar', 'Métodos de pago',
            'Elegí la forma que te quede más cómoda. Todos los precios publicados son de lista.'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Column(
            children: [
              opcion('card', 'Tarjetas bancarizadas',
                  'Hasta 5 cuotas sin interés', [
                '3 cuotas sin interés con tarjetas de crédito bancarias.',
                '5 cuotas sin interés con Tarjeta Naranja.'
              ]),
              const SizedBox(height: 16),
              opcion('tr', 'Transferencia', '20% OFF', [
                'Te pasamos los datos por WhatsApp cuando confirmás tu prenda.',
                'Aplicá el 20% sobre el precio publicado.'
              ]),
              const SizedBox(height: 16),
              opcion('cash', 'Efectivo', '20% OFF', [
                'Pagás en el local al retirar tu compra.',
                'Aplicá el 20% sobre el precio publicado.'
              ]),
            ],
          ),
        ),
        Container(
          color: _kB,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _eyebrow('Ejemplo', c: _kRosaT),
              const SizedBox(height: 12),
              Text('¿Cómo calculo el 20% OFF?', style: _t(22, _b, _kW)),
              const SizedBox(height: 12),
              Text(
                  'El precio publicado no incluye el descuento. Al momento de la compra, restale el 20% al precio publicado para conocer el precio final.',
                  style: _t(13, _r, _kW, h: 1.6)),
              const SizedBox(height: 20),
              caja('Precio publicado', '\$50.000'),
              const SizedBox(height: 8),
              Text('−', textAlign: TextAlign.center, style: _t(18, _r, _kW)),
              const SizedBox(height: 8),
              caja('20% OFF', '\$10.000'),
              const SizedBox(height: 8),
              Text('=', textAlign: TextAlign.center, style: _t(18, _r, _kW)),
              const SizedBox(height: 8),
              caja('Pagás', '\$40.000', blanca: true),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 80),
          child: Column(
            children: [
              Text('¿Tenés dudas con el pago?',
                  textAlign: TextAlign.center, style: _t(19, _b, _kN)),
              const SizedBox(height: 10),
              Text('Escribinos y te ayudamos a elegir la mejor opción.',
                  textAlign: TextAlign.center, style: _t(13, _r, _kG)),
              const SizedBox(height: 10),
              _waBtn(),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- CONTACTO ----------------
  Widget _contacto() {
    Widget fila(String ico, String label, String value, String accion,
            String url) =>
        _tap(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _kL))),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: _kRosa, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: _Ico(ico, size: 18, color: _kB),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label.toUpperCase(),
                          style: _t(10, _m, _kG, ls: 0.16)),
                      const SizedBox(height: 3),
                      Text(value, style: _t(14, _r, _kN)),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Text(accion.toUpperCase(), style: _t(10, _m, _kN, ls: 0.1)),
                const SizedBox(width: 4),
                const _Ico('arr', size: 12, color: _kN),
              ],
            ),
          ),
          () => _open(url),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _encabezado('Estamos para ayudarte', 'Nuestros contactos',
            'Escribinos por el canal que prefieras o vení a conocernos al local.'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              fila('wa', 'WhatsApp', '+54 261 639 - 5545', 'Escribinos',
                  _kWaGeneral),
              fila('ig', 'Instagram', '@almabuena.ind', 'Seguinos', _kIg),
              fila('tiktok', 'TikTok', '@almabuena.ind', 'Seguinos', _kTiktok),
              fila('mail', 'Email', 'almabuena.ind@gmail.com', 'Enviar mail',
                  _kMail),
              fila('pin', 'Ubicación', 'Paso de los Andes 1997, Mendoza',
                  'Cómo llegar', _kMaps),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            children: [
              _tap(
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                        aspectRatio: 350 / 200, child: _net(_img('mapa'))),
                  ),
                  () => _open(_kMaps)),
              const SizedBox(height: 12),
              _btn('Abrir en Google Maps',
                  onTap: () => _open(_kMaps),
                  border: _kN,
                  iconL: 'pin',
                  iconSize: 16,
                  height: 46),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border.all(color: _kL)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  const _Ico('clock', size: 20, color: _kB),
                  const SizedBox(width: 10),
                  Text('Horarios', style: _t(18, _r, _kN)),
                ]),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Lunes a sábado', style: _t(13, _m, _kN)),
                    Text('10:00 – 13:30 hs\n17:30 – 20:30 hs',
                        textAlign: TextAlign.right,
                        style: _t(13, _r, _kG, h: 1.5)),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Domingo', style: _t(13, _m, _kN)),
                    Text('Cerrado', style: _t(13, _r, _kG, h: 1.5)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- COMUNIDAD ----------------
  bool get _mailOk {
    final s = _mailCtrl.text.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s) && _acepto;
  }

  Widget _comunidad() {
    Widget ben(String ico, String a, String b) => Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration:
                  const BoxDecoration(color: _kRosa, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: _Ico(ico, size: 21, color: _kB),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a, style: _t(15, _sb, _kN)),
                  const SizedBox(height: 3),
                  Text(b, style: _t(12.5, _r, _kG)),
                ],
              ),
            ),
          ],
        );
    final tiene = _mailCtrl.text.isNotEmpty;
    final ok = _mailOk;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: _kB,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration:
                    const BoxDecoration(color: _kW, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const _Ico('bell', size: 25, color: _kB),
              ),
              const SizedBox(height: 12),
              _eyebrow('Comunidad Alma Buena', c: _kRosaT),
              const SizedBox(height: 12),
              Text('Enterate primero', style: _t(30, _b, _kW)),
              const SizedBox(height: 12),
              Text(
                  'Sumate con tu mail y te avisamos de ingresos nuevos, descuentos exclusivos y novedades del local.',
                  style: _t(14, _r, _kW, h: 1.6)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
          child: Column(
            children: [
              ben('bag', 'Ingresos nuevos', 'Las prendas nuevas antes que nadie.'),
              const SizedBox(height: 18),
              ben('tag', 'Descuentos exclusivos',
                  'Promos solo para la comunidad.'),
              const SizedBox(height: 18),
              ben('store', 'Novedades del local',
                  'Eventos, horarios especiales y más.'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('TU MAIL', style: _t(12, _sb, _kN, ls: 0.12)),
              const SizedBox(height: 12),
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    color: _kW,
                    border: Border.all(
                        color: tiene ? _kN : const Color(0xFFC7C7C7),
                        width: tiene ? 1.5 : 1)),
                child: Row(
                  children: [
                    _Ico('mail', size: 20, color: tiene ? _kN : _k9E),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _mailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: _kB,
                        style: _t(14, _r, _kN),
                        onChanged: (v) => setState(() {}),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: 'tuemail@ejemplo.com',
                          hintStyle: _t(14, _r, _k9E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _tap(
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: _acepto ? _kB : _kW,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: _acepto ? _kB : const Color(0xFFC7C7C7))),
                        alignment: Alignment.center,
                        child: _acepto
                            ? const _Ico('check', size: 16, color: _kW)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                            'Quiero recibir notificaciones de descuentos, ingresos nuevos y novedades.',
                            style: _t(12.5, _r, _k3B, h: 1.45)),
                      ),
                    ],
                  ),
                  () => setState(() => _acepto = !_acepto)),
              const SizedBox(height: 12),
              _btn('Quiero sumarme', onTap: () {
                if (_mailOk) {
                  FocusScope.of(context).unfocus();
                  _go('ComunidadOK');
                }
              },
                  bg: ok ? _kB : const Color(0xFFD9D4CF),
                  fg: _kW,
                  iconL: 'bell',
                  height: 50,
                  fs: 13,
                  w: _sb,
                  ls: 0.12),
              const SizedBox(height: 12),
              Text('Podés darte de baja cuando quieras. No compartimos tu mail.',
                  textAlign: TextAlign.center, style: _t(11, _r, _k9E)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _comunidadOK() {
    Widget notif(String time, String title, String body) => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: _kW,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFEFEAE6))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: _kN, borderRadius: BorderRadius.circular(10)),
                alignment: Alignment.center,
                child: _net(_kLogoBlanco, fit: BoxFit.contain, w: 32, h: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ALMA BUENA', style: _t(10.5, _sb, _kN, ls: 0.08)),
                        Text(time, style: _t(10.5, _r, _k9E)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(title, style: _t(13, _sb, _kN)),
                    const SizedBox(height: 3),
                    Text(body, style: _t(12, _r, _k3B, h: 1.4)),
                  ],
                ),
              ),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
          child: Column(
            children: [
              Container(
                width: 84,
                height: 84,
                decoration:
                    const BoxDecoration(color: _kB, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const _Ico('check', size: 40, color: _kW),
              ),
              const SizedBox(height: 14),
              Text('¡Ya estás!', style: _t(32, _b, _kN)),
              const SizedBox(height: 14),
              Text('Ya sos parte de nuestra comunidad',
                  textAlign: TextAlign.center, style: _t(16, _sb, _kB)),
              const SizedBox(height: 14),
              Text(
                  'Te vamos a avisar por mail y con notificaciones cuando haya descuentos, ingresos nuevos y novedades. ¡Vas a ser la primera en enterarte!',
                  textAlign: TextAlign.center,
                  style: _t(14, _r, _kG, h: 1.6)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _eyebrow('Así te van a llegar'),
              const SizedBox(height: 10),
              notif('ahora', '¡Bienvenida a la comunidad! 🦋',
                  'Ya te llegan los ingresos nuevos y los descuentos antes que a nadie.'),
              const SizedBox(height: 10),
              notif('hace 2 días', 'Nuevo ingreso: Jeans Wide Leg 👖',
                  'Llegaron modelos nuevos. Vení a verlos al local o consultá por WhatsApp.'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: Column(
            children: [
              _btn('Ver novedades',
                  onTap: () => _go('HomePage'),
                  bg: _kN,
                  fg: _kW,
                  iconR: 'arr',
                  height: 50),
              const SizedBox(height: 12),
              _btn('Seguir comprando',
                  onTap: () => _verCat('Todo'),
                  border: _kN,
                  iconR: 'arr',
                  height: 52),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- SPLASH ----------------
  Widget _splash() {
    return Container(
      color: _kN,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _net(_kLogoBlanco, fit: BoxFit.contain, w: 200, h: 129),
                const SizedBox(height: 22),
                SizedBox(
                  width: 300,
                  child: Text('INDUMENTARIA URBANA, DEPORTIVA & DE FIESTA',
                      textAlign: TextAlign.center,
                      style: _t(10, _m, _kW, ls: 0.24)),
                ),
                const SizedBox(height: 55),
                SizedBox(
                  width: 48,
                  height: 2,
                  child: AnimatedBuilder(
                    animation: _load ?? const AlwaysStoppedAnimation(1.0),
                    builder: (c, _) => Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          width: 48 * (_load?.value ?? 1.0),
                          height: 2,
                          color: _kB),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 61,
            child: Text('MENDOZA · ARGENTINA',
                textAlign: TextAlign.center,
                style: _t(11, _r, _k9E, ls: 0.16)),
          ),
        ],
      ),
    );
  }

  // ---------------- RULETA ----------------
  static const List<String> _segs = [
    '50',
    '10',
    '2x1',
    'nada',
    '50',
    '10',
    '2x1',
    'nada'
  ];

  void _girar() {
    if (_girando) return;
    final rnd = math.Random();
    final i = rnd.nextInt(8);
    final jitter = (rnd.nextDouble() - 0.5) * 30;
    final base = 360.0 * 6;
    final target = base + ((360 - i * 45) % 360) + jitter;
    _from = _angle % 360;
    _to = target;
    setState(() => _girando = true);
    _spin!.forward(from: 0).whenComplete(() {
      _gPremio = _segs[i];
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) _go('RuletaResultado');
      });
    });
  }

  BoxDecoration get _bgRuleta => const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5F1725), Color(0xFF1A0A0D)]),
      );

  Widget _ruleta() {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: _bgRuleta,
      child: Column(
        children: [
          SizedBox(height: top + 7),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _tap(
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: Row(children: [
                        Text('Ahora no', style: _t(12, _m, _kRosaT)),
                        const SizedBox(width: 4),
                        const _Ico('close', size: 16, color: _kRosaT),
                      ]),
                    ),
                    () => _go('HomePage')),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _net(_kLogoBlanco, fit: BoxFit.contain, w: 84, h: 54),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                _eyebrow('Bienvenida a Alma Buena',
                    c: _kRosaT, align: TextAlign.center),
                const SizedBox(height: 10),
                Text('Girá la ruleta y ganá un beneficio',
                    textAlign: TextAlign.center,
                    style: _t(26, _b, _kW, h: 1.15)),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: Text('Tenés un giro de regalo para usar en tu compra.',
                      textAlign: TextAlign.center,
                      style: _t(13, _r, _kRosaT)),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (c, cons) {
              final s = math.min(1.0, math.min(cons.maxHeight - 20, cons.maxWidth) / 360);
              return Center(
                child: SizedBox(
                  width: 360 * s,
                  height: 360 * s,
                  child: FittedBox(
                    child: SizedBox(
                      width: 360,
                      height: 360,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0x14F4ECED)),
                          ),
                          Positioned(
                            left: 20,
                            top: 20,
                            child: Transform.rotate(
                              angle: _angle * math.pi / 180,
                              child: const SizedBox(
                                  width: 320,
                                  height: 320,
                                  child: CustomPaint(painter: _RuedaPainter())),
                            ),
                          ),
                          Positioned(
                            left: 141,
                            top: 141,
                            child: Container(
                              width: 78,
                              height: 78,
                              decoration: BoxDecoration(
                                color: _kW,
                                shape: BoxShape.circle,
                                border: Border.all(color: _kB, width: 3),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0x40000000),
                                      offset: Offset(0, 3),
                                      blurRadius: 8)
                                ],
                              ),
                              alignment: Alignment.center,
                              child: _net(_kLogoNegro,
                                  fit: BoxFit.contain, w: 56, h: 36),
                            ),
                          ),
                          const Positioned(
                            left: 157,
                            top: 1,
                            child: SizedBox(
                                width: 46,
                                height: 52,
                                child: CustomPaint(painter: _PunteroPainter())),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: _tap(
              Container(
                height: 56,
                decoration: const BoxDecoration(color: _kW, boxShadow: [
                  BoxShadow(
                      color: Color(0x4D000000),
                      offset: Offset(0, 6),
                      blurRadius: 16)
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _Ico('star', size: 18, color: _kB),
                    const SizedBox(width: 10),
                    Text(_girando ? 'GIRANDO…' : 'GIRÁ AHORA',
                        style: _t(15, _sb, _kB, ls: 0.14)),
                  ],
                ),
              ),
              _girar,
            ),
          ),
          const SizedBox(height: 14),
          Text('1 giro por persona · Beneficio válido por 7 días',
              textAlign: TextAlign.center,
              style: _t(11, _r, const Color(0xFFBFA3A8))),
          SizedBox(height: math.max(bottom, 16) + 20),
        ],
      ),
    );
  }

  // ---------------- RESULTADO RULETA ----------------
  Widget _resultado() {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;
    final premio = _gPremio.isEmpty ? 'nada' : _gPremio;

    Widget acciones(List<Widget> kids) => Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, math.max(bottom, 12) + 22),
          child: Column(children: kids),
        );

    Widget irInicio() => _tap(
        Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 4),
          child: Text('IR AL INICIO', style: _t(12, _m, _kRosaT, ls: 0.1)),
        ),
        () => _go('HomePage'));

    if (premio == 'nada') {
      return Container(
        decoration: _bgRuleta,
        child: Column(
          children: [
            SizedBox(height: top + 143),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: const BoxDecoration(
                        color: _kW, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const _Ico('bell', size: 36, color: _kB),
                  ),
                  const SizedBox(height: 14),
                  _eyebrow('¡Uy, casi!', c: _kRosaT),
                  const SizedBox(height: 14),
                  Text('Seguí participando',
                      textAlign: TextAlign.center,
                      style: _t(30, _b, _kW, h: 1.12)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: 310,
                    child: Text(
                        'Esta vez no salió premio, pero sumate a la comunidad y enterate primero de las próximas promos.',
                        textAlign: TextAlign.center,
                        style: _t(13, _r, _kRosaT, h: 1.5)),
                  ),
                ],
              ),
            ),
            const Spacer(),
            acciones([
              _btn('Sumarme a la comunidad',
                  onTap: () => _go('Comunidad'),
                  bg: _kW,
                  fg: _kB,
                  iconR: 'arr',
                  height: 50,
                  fs: 13,
                  w: _sb,
                  ls: 0.12),
              irInicio(),
            ]),
          ],
        ),
      );
    }

    String titulo, sub, big, desc, code;
    if (premio == '50') {
      titulo = '¡Ganaste 50% OFF!';
      sub = 'Usalo en tu próxima compra en Alma Buena.';
      big = '50% OFF';
      desc = 'en una prenda a elección';
      code = 'ALMA50';
    } else if (premio == '10') {
      titulo = '¡Ganaste 10% OFF!';
      sub = 'Usalo en tu próxima compra en Alma Buena.';
      big = '10% OFF';
      desc = 'en toda tu compra';
      code = 'ALMA10';
    } else {
      titulo = '¡Ganaste un 2x1!';
      sub = 'Llevate dos prendas y pagá una.';
      big = '2x1';
      desc = 'en prendas';
      code = 'ALMA2X1';
    }

    return Container(
      decoration: _bgRuleta,
      child: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: top - 7,
              height: 300,
              child: const CustomPaint(painter: _ConfetiPainter())),
          Column(
            children: [
              SizedBox(height: top + 49),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: const BoxDecoration(
                          color: _kW, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const _Ico('gift', size: 36, color: _kB),
                    ),
                    const SizedBox(height: 14),
                    _eyebrow('¡Felicitaciones!', c: _kRosaT),
                    const SizedBox(height: 14),
                    Text(titulo,
                        textAlign: TextAlign.center,
                        style: _t(30, _b, _kW, h: 1.12)),
                    const SizedBox(height: 14),
                    Text(sub,
                        textAlign: TextAlign.center,
                        style: _t(13, _r, _kRosaT, h: 1.5)),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                      decoration: BoxDecoration(
                          color: _kW, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          Text('TU BENEFICIO',
                              style: _t(10, _m, _kB, ls: 0.24)),
                          const SizedBox(height: 6),
                          Text(big, style: _t(44, _b, _kB)),
                          const SizedBox(height: 6),
                          Text(desc, style: _t(12, _r, _kG)),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CustomPaint(
                                size: const Size(double.infinity, 1.5),
                                painter: _DashPainter()),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Código', style: _t(12, _r, _kG)),
                              Text(code, style: _t(22, _b, _kN, ls: 0.14)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                              'Válido por 7 días · No acumulable con otras promociones.',
                              textAlign: TextAlign.center,
                              style: _t(10.5, _r, _k9E)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              acciones([
                _btn('Usar mi beneficio',
                    onTap: () => _verCat('Todo'),
                    bg: _kW,
                    fg: _kB,
                    iconR: 'arr',
                    height: 50,
                    fs: 13,
                    w: _sb,
                    ls: 0.12),
                const SizedBox(height: 12),
                _btn(_copiado ? '¡Código copiado!' : 'Copiar código',
                    onTap: () async {
                  await Clipboard.setData(ClipboardData(text: code));
                  if (mounted) setState(() => _copiado = true);
                },
                    border: const Color(0x99FFFFFF),
                    fg: _kW,
                    iconL: _copiado ? 'check' : 'copy',
                    height: 50),
                irInicio(),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pintores
// ---------------------------------------------------------------------------
class _RuedaPainter extends CustomPainter {
  const _RuedaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    // aro
    canvas.drawCircle(c, 160, Paint()..color = _kB);
    canvas.drawCircle(
        c,
        156,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0x80E8CFD3));
    // luces
    for (int i = 0; i < 16; i++) {
      final a = -math.pi / 2 + i * math.pi / 8;
      final p = c + Offset(math.cos(a), math.sin(a)) * 150.5;
      canvas.drawCircle(
          p,
          3.5,
          Paint()
            ..color =
                i.isEven ? const Color(0xFFF3D9A4) : const Color(0xFFFFFFFF));
    }
    // porciones
    const fills = [
      Color(0xFF121212),
      Color(0xFFF3F0EA),
      Color(0xFF5F1725),
      Color(0xFFF4ECED),
    ];
    final rect = Rect.fromCircle(center: c, radius: 142);
    for (int i = 0; i < 8; i++) {
      final start = -math.pi / 2 - math.pi / 8 + i * math.pi / 4;
      final path = Path()
        ..moveTo(c.dx, c.dy)
        ..arcTo(rect, start, math.pi / 4, false)
        ..close();
      canvas.drawPath(path, Paint()..color = fills[i % 4]);
      canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = Colors.white);
    }
    // textos
    for (int i = 0; i < 8; i++) {
      final a = -math.pi / 2 + i * math.pi / 4;
      final k = i % 4;
      String label;
      TextStyle st;
      if (k == 0) {
        label = '50% OFF';
        st = _t(16, FontWeight.w700, Colors.white, ls: 0.02, h: 1.1);
      } else if (k == 1) {
        label = '10% OFF';
        st = _t(16, FontWeight.w700, _kB, ls: 0.02, h: 1.1);
      } else if (k == 2) {
        label = '2x1';
        st = _t(22, FontWeight.w700, Colors.white, ls: 0.02, h: 1.1);
      } else {
        label = 'Seguí\nparticipando';
        st = _t(10, FontWeight.w600, _kB, h: 1.1);
      }
      final tp = TextPainter(
          text: TextSpan(text: label, style: st),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr)
        ..layout();
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(a);
      canvas.translate(95, 0);
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PunteroPainter extends CustomPainter {
  const _PunteroPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(23, 41)
      ..lineTo(9, 13)
      ..cubicTo(7.5, 9.5, 10, 5, 14, 5)
      ..lineTo(32, 5)
      ..cubicTo(36, 5, 38.5, 9.5, 37, 13)
      ..close();
    canvas.drawShadow(path.shift(const Offset(0, 1)),
        const Color(0x4D000000), 4, false);
    canvas.drawPath(path, Paint()..color = Colors.white);
    canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeJoin = StrokeJoin.round
          ..color = _kB);
    canvas.drawCircle(const Offset(23, 14), 4, Paint()..color = _kB);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = _kL
      ..strokeWidth = 1.5;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(math.min(x + 6, size.width), 0), p);
      x += 10;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConfetiPainter extends CustomPainter {
  const _ConfetiPainter();
  // x, y, w, h, rot, opacity, color, circle
  static const List<List<num>> _d = [
    [168, 147, 4, 12, 14, .66, 0xFFFFFFFF, 0],
    [297, 191, 8, 8, 0, .68, 0xFFF4ECED, 1],
    [60, 163, 4, 11, 88, .85, 0xFFF3D9A4, 0],
    [46, 129, 3, 7, 172, .99, 0xFFC0262D, 0],
    [107, 49, 4, 10, 177, .85, 0xFFF4ECED, 0],
    [58, 224, 3, 9, 63, .70, 0xFFF4ECED, 0],
    [336, 137, 3, 7, 42, .66, 0xFFC0262D, 0],
    [52, 65, 6, 6, 0, .84, 0xFFE8CFD3, 1],
    [259, 188, 3, 7, 172, .74, 0xFFFFFFFF, 0],
    [319, 131, 4, 11, 79, .75, 0xFFF4ECED, 0],
    [103, 222, 3, 9, 155, .61, 0xFFE8CFD3, 0],
    [243, 161, 10, 10, 0, .89, 0xFFC0262D, 1],
    [150, 199, 4, 10, 133, .65, 0xFFF3D9A4, 0],
    [223, 128, 6, 16, 16, .71, 0xFFFFFFFF, 0],
    [178, 36, 7, 7, 0, .81, 0xFFC0262D, 1],
    [59, 205, 9, 9, 0, .56, 0xFFF3D9A4, 1],
    [316, 49, 8, 8, 0, .65, 0xFFC0262D, 1],
    [316, 245, 3, 7, 26, .79, 0xFFFFFFFF, 0],
    [24, 103, 3, 7, 41, .77, 0xFFF3D9A4, 0],
    [0, 181, 5, 14, 16, .62, 0xFFFFFFFF, 0],
    [3, 219, 3, 7, 81, .74, 0xFFF4ECED, 0],
    [243, 78, 6, 6, 0, .87, 0xFFC0262D, 1],
    [26, 54, 3, 7, 55, .59, 0xFFC0262D, 0],
    [205, 263, 5, 12, 95, .72, 0xFFF4ECED, 0],
    [190, 263, 3, 8, 122, .85, 0xFFC0262D, 0],
    [189, 204, 6, 16, 142, .74, 0xFFC0262D, 0],
    [315, 128, 7, 7, 0, .84, 0xFFC0262D, 1],
    [149, 218, 6, 16, 141, .84, 0xFFF4ECED, 0],
    [20, 107, 7, 7, 0, .87, 0xFFC0262D, 1],
    [257, 49, 6, 16, 36, .62, 0xFFE8CFD3, 0],
    [195, 10, 6, 6, 0, .98, 0xFFFFFFFF, 1],
    [281, 89, 3, 8, 163, .65, 0xFFE8CFD3, 0],
    [131, 121, 6, 6, 0, .63, 0xFFC0262D, 1],
    [184, 73, 7, 7, 0, .62, 0xFFFFFFFF, 1],
    [23, 215, 4, 11, 82, .56, 0xFFF3D9A4, 0],
    [85, 113, 9, 9, 0, .73, 0xFFFFFFFF, 1],
    [11, 156, 3, 8, 50, .93, 0xFFE8CFD3, 0],
    [87, 182, 3, 9, 160, .77, 0xFFE8CFD3, 0],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 390;
    for (final e in _d) {
      final paint = Paint()
        ..color = Color(e[6].toInt()).withOpacity(e[5].toDouble());
      final x = e[0].toDouble() * sx;
      final y = e[1].toDouble();
      final w = e[2].toDouble();
      final h = e[3].toDouble();
      if (e[7] == 1) {
        canvas.drawOval(Rect.fromLTWH(x, y, w, h), paint);
      } else {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(-e[4].toDouble() * math.pi / 180);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
