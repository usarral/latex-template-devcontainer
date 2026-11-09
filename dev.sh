#!/usr/bin/env bash
# Abre una shell en el contenedor, o ejecuta dentro lo que se le pase, sin
# necesidad de VS Code:
#
#   ./dev.sh                  shell interactiva
#   ./dev.sh ./doc compila    ejecuta y sale
#   ./dev.sh --rebuild        reconstruye la imagen antes
#
# El devcontainer.json es spec estándar, así que DevPod (https://devpod.sh)
# también sirve para levantar este mismo entorno.
set -euo pipefail

RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# La etiqueta lleva el nombre de la carpeta: cada repo creado desde esta
# plantilla tiene su propia imagen y no reutiliza la de otro con una lista de
# paquetes distinta.
NOMBRE="$(printf '%s' "$(basename "$RAIZ")" \
          | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9_.-' '-')"
IMAGEN="${NOMBRE}:dev"

if command -v podman >/dev/null; then
  MOTOR=podman
  # :z reetiqueta el volumen para SELinux; en Docker esa opción no existe.
  MONTAJE="$RAIZ:/workspace:z"
elif command -v docker >/dev/null; then
  MOTOR=docker
  MONTAJE="$RAIZ:/workspace"
else
  echo "error: hace falta podman o docker" >&2
  exit 1
fi

construir() {
  echo "Construyendo $IMAGEN (unos minutos la primera vez)..." >&2
  "$MOTOR" build -f "$RAIZ/.devcontainer/Dockerfile" -t "$IMAGEN" "$RAIZ/.devcontainer"
}

if [ "${1:-}" = "--rebuild" ]; then
  shift
  construir
elif ! "$MOTOR" image inspect "$IMAGEN" >/dev/null 2>&1; then
  construir
fi

# -t solo si hay terminal, para que funcione igual desde un script o la CI.
BANDERAS=(--rm -i -v "$MONTAJE" -w /workspace)
[ -t 0 ] && BANDERAS+=(-t)

if [ $# -eq 0 ]; then
  exec "$MOTOR" run "${BANDERAS[@]}" "$IMAGEN" bash
else
  exec "$MOTOR" run "${BANDERAS[@]}" "$IMAGEN" "$@"
fi
