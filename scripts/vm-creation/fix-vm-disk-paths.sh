#!/bin/bash
################################################################################
# OpenVMS Community 2026 - Corrector de Rutas de Imagen de Disco
#
# Propósito:
#   Si ya creaste una VM con el script anterior y las imágenes están apuntando
#   a la carpeta del proyecto, este script copia las imágenes a la carpeta de la VM
#   y actualiza la configuración automáticamente.
#
# Uso:
#   ./fix-vm-disk-paths.sh
#
################################################################################

set -e

# ============================================================================
# CONFIGURACIÓN
# ============================================================================

readonly VM_NAME="OpenVMS-Community_2026"

# Obtener la ruta del script y calcular la ruta del proyecto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

readonly VMDK_SOURCE="$PROJECT_ROOT/vm-images/disks/X86_V923-comm-2026.vmdk"
readonly VMDK_FLAT_SOURCE="$PROJECT_ROOT/vm-images/disks/X86_V923-comm-2026-flat.vmdk"
readonly VirtualBox_VM_DIR="$HOME/VirtualBox VMs"
readonly VM_DISK_DIR="$VirtualBox_VM_DIR/$VM_NAME/Disks"
readonly VMDK_DEST="$VM_DISK_DIR/X86_V923-comm-2026.vmdk"
readonly VMDK_FLAT_DEST="$VM_DISK_DIR/X86_V923-comm-2026-flat.vmdk"
readonly CONTROLLER="SATA"

# ============================================================================
# FUNCIONES
# ============================================================================

log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

log_success() {
    echo "[✓] $1"
}

log_warning() {
    echo "[⚠] $1"
}

# ============================================================================
# VALIDACIONES
# ============================================================================

log_info "=========================================="
log_info "Corrector de Rutas de Imagen de Disco"
log_info "=========================================="
echo ""

# Verificar que vboxmanage está disponible
if ! command -v vboxmanage &> /dev/null; then
    log_error "VirtualBox (vboxmanage) no encontrado en PATH"
    exit 1
fi
log_success "VirtualBox disponible"
echo ""

# Verificar que la VM existe
if ! vboxmanage list vms | grep -q "\"$VM_NAME\""; then
    log_error "La VM '$VM_NAME' no existe"
    log_error "Primero debes crear la VM con createvm-improved.sh"
    exit 1
fi
log_success "VM '$VM_NAME' encontrada"
echo ""

# Verificar que los archivos fuente existen
if [[ ! -f "$VMDK_SOURCE" ]] || [[ ! -f "$VMDK_FLAT_SOURCE" ]]; then
    log_error "Archivos VMDK no encontrados en el proyecto:"
    log_error "  - $VMDK_SOURCE"
    log_error "  - $VMDK_FLAT_SOURCE"
    log_error "Asegúrate de estar en el directorio scripts/vm-creation/"
    exit 1
fi
log_success "Imágenes VMDK encontradas en el proyecto"
echo ""

# ============================================================================
# PROCESO DE CORRECCIÓN
# ============================================================================

log_info "Iniciando corrección de rutas de imagen de disco..."
echo ""

# Crear directorio de discos si no existe
log_info "Asegurando que existe el directorio de discos..."
mkdir -p "$VM_DISK_DIR"
log_success "Directorio: $VM_DISK_DIR"
echo ""

# Detener la VM si está en ejecución
if vboxmanage list runningvms | grep -q "\"$VM_NAME\""; then
    log_warning "La VM está en ejecución, deteniéndola..."
    vboxmanage controlvm "$VM_NAME" poweroff || true
    sleep 2
    log_success "VM detenida"
    echo ""
fi

# Desmontar el disco actual
log_info "Desmontando imagen de disco actual..."
vboxmanage storageattach "$VM_NAME" \
    --storagectl "$CONTROLLER" \
    --port 0 \
    --medium none || true
log_success "Disco desmontado"
echo ""

# Copiar imágenes VMDK
log_info "Copiando imágenes VMDK a la carpeta de la VM..."
log_info "  Origen: $(pwd)/$VMDK_SOURCE"
log_info "  Destino: $VMDK_DEST"
log_warning "Por favor espera, esto puede tardar varios minutos (8.5 GB)..."
echo ""

cp "$VMDK_SOURCE" "$VMDK_DEST"
log_success "Archivo descriptor copiado"

cp "$VMDK_FLAT_SOURCE" "$VMDK_FLAT_DEST"
log_success "Imagen de disco copiada completamente"
echo ""

# Montar el nuevo disco
log_info "Montando imagen de disco desde la carpeta de la VM..."
vboxmanage storageattach "$VM_NAME" \
    --storagectl "$CONTROLLER" \
    --port 0 \
    --type hdd \
    --medium "$VMDK_DEST"
log_success "Imagen montada desde: $VMDK_DEST"
echo ""

# ============================================================================
# RESUMEN
# ============================================================================

log_success "=========================================="
log_success "¡Corrección completada exitosamente!"
log_success "=========================================="
echo ""
log_info "Cambios realizados:"
log_info "  ✓ Las imágenes VMDK se han copiado a la carpeta de la VM"
log_info "  ✓ La configuración de la VM ha sido actualizada"
log_info "  ✓ La VM ahora es independiente del proyecto"
echo ""
log_info "Ubicaciones:"
log_info "  • Imágenes en proyecto (respaldo): $(pwd)/$VMDK_SOURCE"
log_info "  • Imágenes en VM: $VMDK_DEST"
echo ""
log_info "Próximos pasos:"
log_info "  1. Inicia la VM:"
log_info "     vboxmanage startvm \"$VM_NAME\" --type=headless"
echo ""
log_info "  2. Verifica que funciona correctamente"
echo ""

exit 0
