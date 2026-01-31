@echo off
REM ========================================================================
REM OpenVMS Community 2026 - Conector Rápido PuTTY
REM ========================================================================
REM Este script abre PuTTY con la configuración correcta para conectarse
REM a la VM OpenVMS en puerto 2026
REM ========================================================================

setlocal enabledelayedexpansion

REM Configuración de conexión
set OPENVMS_HOST=127.0.0.1
set OPENVMS_PORT=2026
set PUTTY_PATH="C:\Program Files\PuTTY\putty.exe"
set SESSION_NAME=OpenVMS-Community_2026

echo.
echo ========================================
echo OpenVMS Community 2026 - Conector PuTTY
echo ========================================
echo.
echo Configuracion:
echo   Host:     %OPENVMS_HOST%
echo   Puerto:   %OPENVMS_PORT%
echo   Protocolo: Telnet
echo   Terminal: VT100
echo.

REM Verificar si PuTTY está instalado
if exist %PUTTY_PATH% (
    echo [OK] PuTTY encontrado en: %PUTTY_PATH%
    echo.
    echo Iniciando conexión...
    echo.
    
    REM Ejecutar PuTTY con parámetros de conexión
    start "" %PUTTY_PATH% -telnet -P %OPENVMS_PORT% %OPENVMS_HOST%
    
    echo [✓] PuTTY iniciado
    echo [✓] Conectando a %OPENVMS_HOST%:%OPENVMS_PORT%
    echo.
    echo Espera el diálogo de login de OpenVMS...
    echo.
) else (
    echo [ERROR] PuTTY no encontrado en: %PUTTY_PATH%
    echo.
    echo Por favor:
    echo 1. Descarga PuTTY desde: https://www.putty.org/
    echo 2. Instálalo en: C:\Program Files\PuTTY\
    echo 3. O modifica PUTTY_PATH en este script
    echo.
    pause
    exit /b 1
)

echo Puedes minimizar esta ventana o cerrarla cuando termines.
pause

exit /b 0
