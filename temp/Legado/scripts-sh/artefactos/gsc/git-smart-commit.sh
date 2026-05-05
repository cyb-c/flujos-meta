#!/bin/bash
#
# ============================================================
# 🧠 git-smart-commit.sh
# ------------------------------------------------------------
# Script para crear commits enriquecidos automáticamente
# con información detallada de cambios (bitácora).
#
# 📦 Qué hace:
#   1. Ejecuta `git add .`
#   2. Solicita una descripción del commit
#   3. Genera automáticamente:
#       - Lista de archivos afectados con estado (M, A, D, R)
#       - Resumen de cambios por archivo (líneas + / -)
#       - Totales de cambios
#   4. Muestra una vista previa antes de confirmar
#   5. Opcionalmente ejecuta `git push`
#
# 🧾 Formato del commit generado:
#
#   Descripción introducida por el usuario
#
#   Archivos:
#   M archivo.js | 10 +++++-----
#   A nuevo.js   |  5 +++++
#   D viejo.js   |  3 ---
#
#   Total:
#   3 files changed, 12 insertions(+), 6 deletions(-)
#
# 🚀 Uso:
#   ./git-smart-commit.sh
#
# 🚀 Uso con push automático:
#   ./git-smart-commit.sh --P
#
# ⚙️ Parámetros:
#   --P    Ejecuta `git push origin main` después del commit
#
# ⚠️ Notas:
#   - Añade automáticamente TODOS los archivos (`git add .`)
#   - Usa solo lo que está en staging para construir el commit
#   - En renombrados (R), el resumen puede no mostrar líneas → se indica como | 0
#
# ============================================================


# Detectar si se pasa --P
DO_PUSH=false
if [[ "$1" == "--P" ]]; then
  DO_PUSH=true
fi

# Añadir todo
git add .

# Pedir descripción
echo "Introduce descripción del commit:"
read DESC

# Obtener datos
NAME_STATUS=$(git diff --cached --name-status)
STAT=$(git diff --cached --stat)
TOTAL=$(git diff --cached --shortstat)

# Construir tabla combinada
ARCHIVOS=""

while IFS= read -r line; do
  STATUS=$(echo "$line" | awk '{print $1}')
  FILE=$(echo "$line" | cut -f2-)

  # Buscar línea correspondiente en stat
  MATCH=$(echo "$STAT" | grep "$FILE")

  if [[ -n "$MATCH" ]]; then
    STATS_PART=$(echo "$MATCH" | cut -d'|' -f2-)
    ARCHIVOS+="$STATUS $FILE |$STATS_PART\n"
  else
    ARCHIVOS+="$STATUS $FILE | 0\n"
  fi
done <<< "$NAME_STATUS"

# Construir mensaje final
COMMIT_MSG="$DESC

Archivos:
$(echo -e "$ARCHIVOS")

Total:
$TOTAL
"

# Mostrar preview
echo "=============================="
echo "$COMMIT_MSG"
echo "=============================="

# Confirmación
read -p "¿Confirmar commit? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]]; then
  echo "Cancelado."
  exit 0
fi

# Hacer commit
git commit -m "$COMMIT_MSG"

# Push opcional
if $DO_PUSH; then
  echo "Haciendo push..."
  git push origin main
fi