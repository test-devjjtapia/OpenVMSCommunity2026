# Scripts de Utilidad

Este directorio contiene scripts bash y batch para automatizar tareas comunes.

## Subdirectorios

### connection/
Scripts para conectarse a OpenVMS:
- `connect-openvms.sh` - Script principal de conexión
- `connect-clean.sh` - Script para limpiar conexiones
- `connect-putty.bat` - Script para Windows usando PuTTY

### vm-creation/
Scripts para crear y gestionar máquinas virtuales:
- `createvm.sh` - Script básico de creación
- `createvm-improved.sh` - Script mejorado con más opciones

## Uso

```bash
# Conexión a OpenVMS (Linux)
./scripts/connection/connect-openvms.sh

# Crear una VM
./scripts/vm-creation/createvm-improved.sh

# Limpiar conexiones
./scripts/connection/connect-clean.sh
```

## Permisos

Los scripts requieren permisos de ejecución:
```bash
chmod +x scripts/connection/*.sh
chmod +x scripts/vm-creation/*.sh
```
