#!/bin/bash
set -euo pipefail

# Script de prueba rápido para validar prerequisitos del creador de VM
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CREATOR="$ROOT_DIR/vm-creation/createvm-improved.sh"

echo "== Test rápido: Validaciones createvm =="
if [[ ! -x "$CREATOR" ]]; then
  echo "ERROR: No existe el script $CREATOR o no es ejecutable"
  exit 1
fi

echo "-> Ejecutando validaciones (modo --check-only)..."
"$CREATOR" --check-only
echo "-> Validaciones completadas correctamente ✅"

echo "-> Verificando vboxmanage..."
if command -v vboxmanage &> /dev/null; then
  echo "vboxmanage disponible: $(command -v vboxmanage)"
else
  echo "ERROR: vboxmanage no encontrado en PATH"
  exit 1
fi

echo "-> Verificando archivos VMDK..."
VMDK_DIR="$ROOT_DIR/vm-images/disks"
for f in "X86_V923-comm-2026.vmdk" "X86_V923-comm-2026-flat.vmdk"; do
  if [[ -f "$VMDK_DIR/$f" ]]; then
    echo "  OK: $f"
  else
    echo "  ERROR: Falta $f en $VMDK_DIR"
    exit 1
  fi
done

echo "== Test completado con éxito ✅"
exit 0
