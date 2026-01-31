#!/bin/bash
################################################################################
# OpenVMS Community 2026 - VirtualBox VM Creation Script
#
# Propósito:
#   Automatizar la creación y configuración de una máquina virtual OpenVMS
#   versión 9.2-3 (Community Edition 2026) en VirtualBox con hardware
#   optimizado y conectividad de red configurada.
#
# Requisitos:
#   - VirtualBox instalado y en PATH
#   - Imagen VMDK precompilada (X86_V923-comm-2026.vmdk)
#   - Permisos de usuario para ejecutar vboxmanage
#
# Uso:
#   ./createvm-improved.sh
#
################################################################################
set -euo pipefail
# Manejo de errores: mostrar línea y mensaje en caso de fallo
trap 'log_error "Error en el script en la línea ${LINENO}. Saliendo."; exit 1' ERR

# Modo de ejecución: --check-only para ejecutar solo validaciones (no crear)
CHECK_ONLY=false
if [[ ${1:-} == "--check-only" ]]; then
    CHECK_ONLY=true
fi

# Valida que haya suficiente espacio en el filesystem destino para el disco grande
check_disk_space() {
    log_info "Verificando espacio en disco disponible..."
    local target_dir="$VirtualBox_VM_DIR"
    mkdir -p "$target_dir" || true
    local avail
    avail=$(df --output=avail -B1 "$target_dir" | tail -n1 | tr -d '[:space:]')
    local required=0
    if [[ -f "$VMDK_FLAT_SOURCE" ]]; then
        required=$(stat -c%s "$VMDK_FLAT_SOURCE")
    fi
    # Añadir margen (10%) y 100MB de seguridad
    local margin=$((required / 10))
    local total_required=$((required + margin + 100000000))
    if (( avail < total_required )); then
        log_error "Espacio insuficiente en $target_dir. Disponible: $avail, requerido aprox: $total_required bytes."
        log_error "Libera espacio o usa otra partición y vuelve a intentarlo."
        exit 1
    fi
    log_success "Espacio suficiente detectado en $target_dir (disponible: $avail bytes)."
}

# ============================================================================
# CONFIGURACIÓN - Variables de la VM
# ============================================================================

# Nombre de la máquina virtual (identificador en VirtualBox)
readonly VM_NAME="OpenVMS-Community_2026"

# Obtener la ruta del script y calcular la ruta del proyecto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Ruta a la imagen VMDK precompilada en el proyecto (vm-images/disks/)
readonly VMDK_SOURCE="$PROJECT_ROOT/vm-images/disks/X86_V923-comm-2026.vmdk"
readonly VMDK_FLAT_SOURCE="$PROJECT_ROOT/vm-images/disks/X86_V923-comm-2026-flat.vmdk"

# Directorio de máquinas virtuales de VirtualBox
VirtualBox_VM_DIR="$HOME/VirtualBox VMs"

# Directorio donde se guardarán las imágenes de disco de la VM
VM_DISK_DIR="$VirtualBox_VM_DIR/$VM_NAME/Disks"

# Rutas finales de las imágenes en la carpeta de la VM
readonly VMDK_DEST="$VM_DISK_DIR/X86_V923-comm-2026.vmdk"
readonly VMDK_FLAT_DEST="$VM_DISK_DIR/X86_V923-comm-2026-flat.vmdk"

# Nombre del controlador de almacenamiento SATA
readonly CONTROLLER="SATA"

# Puerto para la conexión serial/telnet (puerto TCP)
# Uso: telnet 127.0.0.1 2026
readonly TELNET_PORT=2026

# ============================================================================
# CONFIGURACIÓN - Especificaciones de Hardware
# ============================================================================

# Número de CPUs asignadas a la VM
readonly CPU_COUNT=2

# Memoria RAM en MB (2049 MB = ~2 GB)
readonly MEMORY_MB=2049

# Tipo de firmware: efi64 para arquitectura x86-64
readonly FIRMWARE="efi64"

# Chipset: ICH9 es compatible con OpenVMS en x86
readonly CHIPSET="ich9"

# Tipo de NIC: 82540EM es ampliamente compatible
readonly NIC_TYPE="82540EM"

# ============================================================================
# FUNCIONES AUXILIARES
# ============================================================================

# Imprime un mensaje de información con prefijo
log_info() {
    echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") [INFO] $1"
}

# Imprime un mensaje de error con prefijo
log_error() {
    echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") [ERROR] $1" >&2
}

# Imprime un mensaje de éxito con prefijo
log_success() {
    echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") [✓] $1"
} 

# Valida que vboxmanage está disponible
check_vboxmanage() {
    if ! command -v vboxmanage &> /dev/null; then
        log_error "VirtualBox (vboxmanage) no encontrado en PATH"
        log_error "Por favor instala VirtualBox e intenta de nuevo"
        exit 1
    fi
    log_success "VirtualBox disponible"
}

# Valida que el archivo VMDK existe
check_vmdk_file() {
    if [[ ! -f "$VMDK_SOURCE" ]] || [[ ! -f "$VMDK_FLAT_SOURCE" ]]; then
        log_error "Archivos VMDK no encontrados:"
        log_error "  - $VMDK_SOURCE"
        log_error "  - $VMDK_FLAT_SOURCE"
        log_error "Asegúrate de estar en el directorio correcto"
        exit 1
    fi
    log_success "Imágenes VMDK encontradas"
}

# Verifica si la VM ya existe
check_vm_exists() {
    if vboxmanage list vms | grep -q "\"$VM_NAME\""; then
        log_error "La VM '$VM_NAME' ya existe"
        log_error "Elimínala primero si deseas crear una nueva"
        exit 1
    fi
    log_info "Verificación: VM no existe (OK)"
}

# ============================================================================
# EJECUCIÓN PRINCIPAL
# ============================================================================

log_info "=========================================="
log_info "OpenVMS Community 2026 - Creador de VM"
log_info "=========================================="
echo ""

# Validaciones previas
log_info "Ejecutando validaciones previas..."
check_vboxmanage
check_vmdk_file
check_disk_space
check_vm_exists

echo ""
if [ "$CHECK_ONLY" = true ]; then
    log_success "Validaciones completadas (modo --check-only). No se realizaron cambios."
    exit 0
fi

# Crear directorio para la VM y discos
log_info "Creando directorio de almacenamiento para la VM..."
mkdir -p "$VM_DISK_DIR"
log_success "Directorio creado: $VM_DISK_DIR"
echo ""

# Copiar imágenes VMDK a la carpeta de la VM
log_info "Copiando imágenes VMDK a la carpeta de la VM..."
for pair in "$VMDK_SOURCE:$VMDK_DEST" "$VMDK_FLAT_SOURCE:$VMDK_FLAT_DEST"; do
    src="${pair%%:*}"
    dest="${pair##*:}"
    log_info "  Origen: $src"
    log_info "  Destino: $dest"
    if command -v rsync &> /dev/null; then
        rsync -ah --info=progress2 "$src" "$dest"
    else
        cp -v "$src" "$dest"
    fi
    if [[ $? -ne 0 ]]; then
        log_error "Error al copiar $src a $dest"
        exit 1
    fi
    log_success "Archivo copiado: $dest"
done

echo ""

# Crear la VM base
log_info "Creando máquina virtual base..."
vboxmanage createvm \
    --ostype=Other_64 \
    --name="$VM_NAME" \
    --basefolder="$VirtualBox_VM_DIR" \
    --register
log_success "VM base creada"
echo ""

# Crear y configurar controlador de almacenamiento SATA
log_info "Configurando controlador de almacenamiento SATA..."
vboxmanage storagectl "$VM_NAME" \
    --name="$CONTROLLER" \
    --add=SATA \
    --bootable=on \
    --portcount=4 \
    --controller=IntelAhci \
    --hostiocache=on
log_success "Controlador SATA creado (4 puertos)"
echo ""

# Configurar especificaciones de hardware
log_info "Configurando hardware de la VM..."

# Sistema operativo y arquitectura
vboxmanage modifyvm "$VM_NAME" --ostype=Other_64
log_info "  • OS Type: Other 64-bit"

# Procesador
vboxmanage modifyvm "$VM_NAME" --cpus "$CPU_COUNT"
log_info "  • CPUs: $CPU_COUNT"

# Extensión de direcciones físicas para memoria >4GB
vboxmanage modifyvm "$VM_NAME" --pae on
log_info "  • PAE (Physical Address Extension): ON"

# Memoria RAM
vboxmanage modifyvm "$VM_NAME" --memory "$MEMORY_MB"
log_info "  • Memoria RAM: ${MEMORY_MB}MB"

# Firmware EFI 64-bit (requerido para OpenVMS x86)
vboxmanage modifyvm "$VM_NAME" --firmware "$FIRMWARE"
log_info "  • Firmware: $FIRMWARE"

# Chipset Intel ICH9
vboxmanage modifyvm "$VM_NAME" --chipset "$CHIPSET"
log_info "  • Chipset: $CHIPSET"

# Boot desde disco (VMDK)
vboxmanage modifyvm "$VM_NAME" --boot1 disk
log_info "  • Boot primario: Disco"

# Controller I/O APIC (requerido para soporte multi-CPU)
vboxmanage modifyvm "$VM_NAME" --ioapic on
log_info "  • IOAPIC: ON"

log_success "Hardware configurado"
echo ""

# Configurar conectividad serial/Telnet
log_info "Configurando conectividad serial (Telnet)..."
vboxmanage modifyvm "$VM_NAME" \
    --uart1 0x3F8 4 \
    --uartmode1=tcpserver "$TELNET_PORT"
log_success "Serial sobre TCP en puerto $TELNET_PORT"
log_info "  • Conexión: telnet 127.0.0.1 $TELNET_PORT"
echo ""

# Configurar interfaz de red
log_info "Configurando interfaz de red..."
vboxmanage modifyvm "$VM_NAME" --nic1 nat
log_info "  • NIC1 Modo: NAT"

vboxmanage modifyvm "$VM_NAME" --nictype1 "$NIC_TYPE"
log_info "  • NIC1 Tipo: $NIC_TYPE"

vboxmanage modifyvm "$VM_NAME" --cableconnected1 on
log_info "  • Cable conectado: ON"
log_success "Red configurada"
echo ""

# Deshabilitar audio (OpenVMS no lo necesita)
log_info "Deshabilitando audio..."
vboxmanage modifyvm "$VM_NAME" --audio=none
log_success "Audio deshabilitado"
echo ""

# Montar el disco virtual VMDK
log_info "Montando imagen VMDK..."
vboxmanage storageattach "$VM_NAME" \
    --storagectl "$CONTROLLER" \
    --port 0 \
    --type hdd \
    --medium "$VMDK_DEST"
log_success "Imagen VMDK montada en $CONTROLLER puerto 0"
echo ""

# ============================================================================
# RESUMEN Y PRÓXIMOS PASOS
# ============================================================================

log_success "=========================================="
log_success "¡Creación de VM completada exitosamente!"
log_success "=========================================="
echo ""
log_info "Información de la VM creada:"
log_info "  • Nombre: $VM_NAME"
log_info "  • CPUs: $CPU_COUNT"
log_info "  • Memoria: ${MEMORY_MB}MB"
log_info "  • Carpeta VM: $VM_DISK_DIR"
log_info "  • Almacenamiento: $VMDK_DEST"
log_info "  • Red: NAT"
log_info "  • Telnet: puerto $TELNET_PORT"
echo ""
log_info "Información importante:"
log_info "  ✓ Las imágenes VMDK se han copiado a la carpeta de la VM"
log_info "  ✓ Las imágenes originales permanecen en el proyecto"
log_info "  ✓ Puedes mover o eliminar las imágenes del proyecto sin afectar la VM"
echo ""
log_info "Próximos pasos:"
log_info "  1. Inicia la VM con:"
log_info "     vboxmanage startvm \"$VM_NAME\" --type=headless"
echo ""
log_info "  2. Conéctate vía Telnet:"
log_info "     telnet 127.0.0.1 $TELNET_PORT"
echo ""
log_info "  3. O accede desde GUI de VirtualBox:"
log_info "     Busca la VM '$VM_NAME' en la lista"
echo ""

exit 0
