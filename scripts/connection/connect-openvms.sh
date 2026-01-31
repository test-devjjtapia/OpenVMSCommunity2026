#!/bin/bash

################################################################################
# OpenVMS Community 2026 - Conector Telnet/PuTTY para Linux
#
# Este script proporciona opciones interactivas para conectarse a la VM
# OpenVMS desde Linux/Fedora usando telnet o PuTTY
#
# Uso:
#   chmod +x connect-openvms.sh
#   ./connect-openvms.sh
#
################################################################################
set -euo pipefail
trap 'print_error "Error en línea ${LINENO}. Saliendo."; exit 1' ERR

# Configuración
readonly HOST="127.0.0.1"
readonly PORT="2026"
readonly VM_NAME="OpenVMS-Community_2026"

# Colores para output (opcional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# FUNCIONES
# ============================================================================

# Imprime mensaje con color
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}OpenVMS Community 2026 - Conector Linux${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_info() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1" >&2
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Verifica si la VM está corriendo
check_vm_running() {
    if vboxmanage list runningvms | grep -q "$VM_NAME"; then
        print_info "VM OpenVMS está corriendo"
        return 0
    else
        print_error "VM OpenVMS NO está corriendo"
        return 1
    fi
}

# Verifica si el puerto está abierto
check_port_open() {
    if nc -z 127.0.0.1 $PORT 2>/dev/null || \
       ss -an 2>/dev/null | grep -q ":$PORT "; then
        print_info "Puerto $PORT está abierto y escuchando"
        return 0
    else
        print_warning "Puerto $PORT no parece estar abierto"
        return 1
    fi
}

# Verifica herramientas disponibles
check_tools() {
    echo ""
    echo -e "${BLUE}Verificando herramientas disponibles:${NC}"
    
    if command -v telnet &> /dev/null; then
        print_info "telnet disponible"
        TELNET_AVAILABLE=true
    else
        print_warning "telnet NO disponible (instálalo con: sudo dnf install telnet o sudo apt install telnet)"
        TELNET_AVAILABLE=false
    fi
    
    if command -v putty &> /dev/null; then
        print_info "PuTTY disponible"
        PUTTY_AVAILABLE=true
    else
        print_warning "PuTTY NO disponible (instálalo con: sudo dnf install putty o sudo apt install putty)"
        PUTTY_AVAILABLE=false
    fi
    
    if command -v plink &> /dev/null; then
        print_info "plink disponible"
        PLINK_AVAILABLE=true
    else
        print_warning "plink NO disponible"
        PLINK_AVAILABLE=false
    fi
} 

# Menú de conexión
show_menu() {
    echo ""
    echo -e "${BLUE}Opciones de conexión:${NC}"
    
    local option_num=1
    
    if [ "$TELNET_AVAILABLE" = true ]; then
        echo "  $option_num) Telnet directo (RECOMENDADO)"
        ((option_num++))
        TELNET_OPTION=$((option_num - 1))
    fi
    
    if [ "$TELNET_AVAILABLE" = true ]; then
        echo "  $option_num) Telnet limpio (sin caracteres ANSI)"
        ((option_num++))
        TELNET_CLEAN_OPTION=$((option_num - 1))
    fi
    
    if [ "$PUTTY_AVAILABLE" = true ]; then
        echo "  $option_num) PuTTY GTK (interfaz gráfica)"
        ((option_num++))
        PUTTY_OPTION=$((option_num - 1))
    fi
    
    if [ "$PLINK_AVAILABLE" = true ]; then
        echo "  $option_num) Plink (cliente PuTTY en terminal)"
        ((option_num++))
        PLINK_OPTION=$((option_num - 1))
    fi
    
    echo "  $option_num) Instalar telnet (si es necesario)"
    ((option_num++))
    INSTALL_OPTION=$((option_num - 1))
    
    echo "  $option_num) Ver información de conexión"
    ((option_num++))
    INFO_OPTION=$((option_num - 1))
    
    echo "  $option_num) Salir"
    ((option_num++))
    EXIT_OPTION=$((option_num - 1))
    
    echo ""
    read -p "Selecciona una opción (1-$((option_num-1))): " selected_option
}

# Conectar con telnet
connect_telnet() {
    echo ""
    print_info "Conectando con telnet a $HOST:$PORT..."
    echo -e "${YELLOW}(Para salir, escribe: quit)${NC}"
    echo ""
    
    telnet $HOST $PORT
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_info "Conexión telnet cerrada correctamente"
    else
        print_warning "Conexión telnet cerrada con código: $exit_code"
    fi
}

# Conectar con telnet (terminal limpio)
connect_telnet_clean() {
    echo ""
    print_info "Conectando con telnet (terminal limpio)..."
    echo -e "${YELLOW}Tipo de terminal: VT100 (sin caracteres ANSI extraños)${NC}"
    echo ""
    
    export TERM=vt100
    telnet $HOST $PORT
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_info "Conexión telnet cerrada correctamente"
    else
        print_warning "Conexión telnet cerrada con código: $exit_code"
    fi
}

# Conectar con PuTTY
connect_putty() {
    echo ""
    print_info "Abriendo PuTTY GTK..."
    
    putty -telnet $HOST $PORT &
    local pid=$!
    
    sleep 1
    print_info "PuTTY iniciado (PID: $pid)"
    echo -e "${YELLOW}La ventana de PuTTY se abrió en segundo plano${NC}"
}

# Conectar con plink
connect_plink() {
    echo ""
    print_info "Conectando con plink a $HOST:$PORT..."
    echo ""
    
    plink -telnet $HOST $PORT
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        print_info "Conexión plink cerrada correctamente"
    else
        print_warning "Conexión plink cerrada con código: $exit_code"
    fi
}

# Instalar telnet
install_telnet() {
    echo ""
    print_warning "Instalando telnet para Fedora..."
    
    if command -v dnf &> /dev/null; then
        echo "Ejecutando: sudo dnf install -y telnet"
        sudo dnf install -y telnet
        
        if [ $? -eq 0 ]; then
            print_info "telnet instalado correctamente"
        else
            print_error "Error durante la instalación de telnet"
        fi
    elif command -v yum &> /dev/null; then
        echo "Ejecutando: sudo yum install -y telnet"
        sudo yum install -y telnet
        
        if [ $? -eq 0 ]; then
            print_info "telnet instalado correctamente"
        else
            print_error "Error durante la instalación de telnet"
        fi
    else
        print_error "No se encontró dnf ni yum. Instala telnet manualmente."
    fi
}

# Mostrar información de conexión
show_connection_info() {
    echo ""
    echo -e "${BLUE}========== Información de Conexión ==========${NC}"
    echo "Host:              $HOST"
    echo "Puerto:            $PORT"
    echo "Protocolo:         Telnet"
    echo "Terminal Type:     VT100"
    echo "VM Name:           $VM_NAME"
    echo ""
    echo -e "${BLUE}========== Comandos Rápidos ==========${NC}"
    echo ""
    echo "Telnet directo:"
    echo -e "  ${GREEN}telnet $HOST $PORT${NC}"
    echo ""
    echo "PuTTY:"
    echo -e "  ${GREEN}putty -telnet $HOST $PORT &${NC}"
    echo ""
    echo "Alias permanente (agregar a ~/.bashrc):"
    echo -e "  ${GREEN}alias openvms='telnet $HOST $PORT'${NC}"
    echo ""
    echo "Luego solo necesitas escribir: openvms"
    echo ""
    echo -e "${BLUE}========== Credenciales ==========${NC}"
    echo "Username: SYSTEM (o según tu configuración)"
    echo "Password: (pregunta al login)"
    echo ""
}

# ============================================================================
# EJECUCIÓN PRINCIPAL
# ============================================================================

clear
print_header
echo ""

# Verificaciones previas
echo -e "${BLUE}Ejecutando verificaciones previas...${NC}"
echo ""

# Comprobar VM
if ! check_vm_running; then
    echo ""
    print_warning "¿Deseas iniciar la VM ahora?"
    read -p "Escribe 'si' para iniciar: " start_vm
    
    if [ "$start_vm" = "si" ]; then
        echo ""
        print_info "Iniciando VM..."
        vboxmanage startvm "$VM_NAME" --type=headless
        
        if [ $? -eq 0 ]; then
            print_info "VM iniciada. Esperando 30 segundos para que boot..."
            sleep 30
        else
            print_error "Error al iniciar la VM"
            exit 1
        fi
    else
        print_error "La VM debe estar corriendo para conectar"
        exit 1
    fi
fi

# Comprobar puerto
check_port_open
PORT_CHECK=$?

if [ $PORT_CHECK -ne 0 ]; then
    echo ""
    print_warning "El puerto puede no estar listo aún"
    print_info "Esperando 5 segundos..."
    sleep 5
fi

# Comprobar herramientas
check_tools

# Mostrar menú
show_menu

# Procesar selección
case $selected_option in
    $TELNET_OPTION)
        connect_telnet
        ;;
    $TELNET_CLEAN_OPTION)
        connect_telnet_clean
        ;;
    $PUTTY_OPTION)
        connect_putty
        ;;
    $PLINK_OPTION)
        connect_plink
        ;;
    $INSTALL_OPTION)
        install_telnet
        ;;
    $INFO_OPTION)
        show_connection_info
        ;;
    $EXIT_OPTION)
        print_info "Saliendo..."
        exit 0
        ;;
    *)
        print_error "Opción inválida"
        exit 1
        ;;
esac

echo ""
print_info "Operación completada"
echo ""

exit 0
