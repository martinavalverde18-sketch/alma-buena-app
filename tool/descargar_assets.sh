#!/usr/bin/env bash
# Descarga las fotos, logos y fuentes de la app a assets/.
# Se usa una sola vez (lo corre GitHub Actions si faltan los archivos).
set -euo pipefail
cd "$(dirname "$0")/.."

BASE="https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/alma-buena-l2bskk/assets"
mkdir -p assets/images assets/fonts

IMAGENES="
  ib2tns52wxi0/remera_japo.jpg
  llspxem5q7io/remera_v.jpg
  qaa6n8omjwfi/nosotras.jpg
  tmno7n7ylv1f/jean_roma.jpg
  cffvk1ok3ij2/body_hombro.jpg
  p8tg9e0m16pz/falda_dallas.jpg
  iqccalcpcnfq/jean_rombo.jpg
  tx54bky3cnpg/falda_aruba.jpg
  ismhvswrtioq/body_cuadrado.jpg
  sbnu4hphhseg/mapa.jpg
  2xh3q3sae4i0/remera_roja.jpg
  auds5zp3o44j/falda_tul.jpg
  fm5tuyaavwnk/short_puntilla.jpg
  f1upp5t6nx1q/jean_celeste.jpg
  gp05aezk4jh8/body_olimpia.jpg
  fqjjw5j9dmfl/short_bolsillos.jpg
  ct8gox2l1n88/short_tirobajo.jpg
  3vb05u0f2ez0/jean_martina.jpg
  seotaatcgpvv/falda_vegas.jpg
  u1ev7cdmiuu2/jean_siena.jpg
  t0vvypejzv0a/top_panuelo.jpg
  qsfx1923nyn9/tee_wild.jpg
  bvh5nb6a2a5j/short_botones.jpg
  xrboojrdyhvo/short_cierre.jpg
  a82jm9rypfg9/jean_tini.jpg
  blugqqw44bj9/body_americano.jpg
  sul69gmugo39/top_cey.jpg
  aj6ltjzoittf/blusa_cey.jpg
  oy6in4zs8mqn/jean_nado.jpg
  wzj08aj0kooe/body_collareta.jpg
  w50du4jegaw5/body_trebol.jpg
  1tlkd2fvs5vx/tee_sandy.jpg
  ntm5e0a28wby/logo_negro.png
  hsuln5clb44k/logo_blanco.png
  2huoz2n5lj9v/banner_app.png
"

for ruta in $IMAGENES; do
  archivo="assets/images/$(basename "$ruta")"
  if [ ! -s "$archivo" ]; then
    curl -fsSL "$BASE/$ruta" -o "$archivo"
    echo "descargado $archivo"
  fi
done

# Montserrat (Google Fonts, licencia OFL), pesos 400/500/600/700
FUENTES="https://cdn.jsdelivr.net/fontsource/fonts/montserrat@latest"
declare -A PESOS=([400]=Regular [500]=Medium [600]=SemiBold [700]=Bold)
for peso in 400 500 600 700; do
  archivo="assets/fonts/Montserrat-${PESOS[$peso]}.ttf"
  if [ ! -s "$archivo" ]; then
    curl -fsSL "$FUENTES/latin-$peso-normal.ttf" -o "$archivo"
    echo "descargado $archivo"
  fi
done
