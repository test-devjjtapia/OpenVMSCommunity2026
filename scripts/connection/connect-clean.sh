#!/bin/bash

################################################################################
# OpenVMS Community 2026 - Conector Telnet "Limpio"
#
# Soluciona el problema de caracteres ANSI extraños configurando
# correctamente el tipo de terminal ANTES de conectar.
#
# Uso:
#   chmod +x connect-clean.sh
#   ./connect-clean.sh
#
################################################################################

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}OpenVMS - Conector Telnet Limpio${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Configuración de terminal
export TERM=vt100

echo -e "${GREEN}[✓]${NC} Tipo de terminal configurado: VT100"
echo -e "${GREEN}[✓]${NC} Esta configuración elimina caracteres ANSI raros"
echo ""
echo "Conectando a OpenVMS en 127.0.0.1:2026..."
echo ""
echo -e "${YELLOW}Nota: Si aún ves caracteres extraños, intenta:${NC}"
echo "  TERM=xterm telnet 127.0.0.1 2026"
echo ""

# Conectar
telnet 127.0.0.1 2026

exit 0
