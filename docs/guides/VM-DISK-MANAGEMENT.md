# Gestión de Imágenes de Disco para la VM OpenVMS

## 📋 Descripción del Problema Resuelto

Anteriormente, el script `createvm-improved.sh` tenía un problema:
- Las imágenes VMDK permanecían en la carpeta del proyecto
- La VM apuntaba a estas imágenes directamente
- Si movías o eliminabas las imágenes del proyecto, la VM dejaba de funcionar

## ✅ Solución Implementada

El script ha sido actualizado para:

### 1. **Copiar las imágenes a la carpeta de la VM**
   - Las imágenes se copian desde el proyecto a la carpeta específica de la VM
   - Ubicación: `~/VirtualBox VMs/OpenVMS-Community_2026/Disks/`

### 2. **Mantener las imágenes en el proyecto**
   - Las imágenes originales permanecen en `vm-images/disks/` del proyecto
   - Puedes mantenerlas como respaldo o para crear más VMs

### 3. **Apuntar correctamente**
   - La VM utiliza las imágenes copiadas en su carpeta
   - La VM es independiente del proyecto

## 🔄 Flujo de Archivos

```
Proyecto (OpenVMS-Community_2026)
└── vm-images/
    └── disks/
        ├── X86_V923-comm-2026.vmdk (Original - Respaldo)
        └── X86_V923-comm-2026-flat.vmdk (Original - Respaldo)
                            ↓ (copia)
~/VirtualBox VMs/
└── OpenVMS-Community_2026/
    ├── Disks/
    │   ├── X86_V923-comm-2026.vmdk (Usada por la VM)
    │   └── X86_V923-comm-2026-flat.vmdk (Usada por la VM)
    └── OpenVMS-Community_2026.vbox (Configuración de VirtualBox)
```

## 🚀 Cómo Usar el Script Actualizado

```bash
# Navega a la carpeta de scripts
cd scripts/vm-creation/

# Ejecuta el script
./createvm-improved.sh
```

### Lo que hace el script:

1. ✓ Verifica que VirtualBox esté instalado
2. ✓ Verifica que las imágenes VMDK existan en el proyecto
3. ✓ Crea el directorio para la VM en `~/VirtualBox VMs`
4. ✓ Copia ambos archivos VMDK a la carpeta de la VM
5. ✓ Crea la máquina virtual
6. ✓ Configura el hardware (CPUs, memoria, red, etc.)
7. ✓ Monta el disco en la configuración de VirtualBox

## 📌 Ventajas

- ✅ **Independencia**: La VM funciona sin depender de los archivos del proyecto
- ✅ **Seguridad**: Las imágenes originales permanecen intactas
- ✅ **Flexibilidad**: Puedes mover la carpeta del proyecto sin afectar la VM
- ✅ **Respaldo**: Tienes copias de las imágenes para crear más VMs si es necesario
- ✅ **Portabilidad**: La VM es completamente autocontenida en su carpeta

## ⚙️ Configuración Técnica

### Variables Clave

```bash
VMDK_SOURCE="X86_V923-comm-2026.vmdk"              # En el proyecto
VMDK_FLAT_SOURCE="X86_V923-comm-2026-flat.vmdk"    # En el proyecto

VM_DISK_DIR="$HOME/VirtualBox VMs/$VM_NAME/Disks"  # Destino
VMDK_DEST="$VM_DISK_DIR/X86_V923-comm-2026.vmdk"   # Archivo descriptor
VMDK_FLAT_DEST="$VM_DISK_DIR/X86_V923-comm-2026-flat.vmdk"  # Datos
```

## 🔍 Verificación

Para verificar que todo está funcionando correctamente:

```bash
# Ver el contenido de la carpeta de la VM
ls -lh ~/VirtualBox\ VMs/OpenVMS-Community_2026/Disks/

# Verificar la configuración de VirtualBox
vboxmanage showmediuminfo disk "$HOME/VirtualBox VMs/OpenVMS-Community_2026/Disks/X86_V923-comm-2026.vmdk"
```

## ⚠️ Nota Importante

- El primer script de creación de VM copia archivos de ~8.5 GB, esto puede tardar varios minutos
- No interrumpas el proceso durante la copia
- Asegúrate de tener suficiente espacio en disco: ~17 GB (8.5 GB originales + 8.5 GB copia)

## 🆘 Solución de Problemas

### La VM no inicia o no encuentra el disco

1. Verifica que los archivos existan en la carpeta de la VM:
   ```bash
   ls -la ~/VirtualBox\ VMs/OpenVMS-Community_2026/Disks/
   ```

2. Recrea la VM si es necesario:
   ```bash
   vboxmanage unregistervm "OpenVMS-Community_2026" --delete
   ./createvm-improved.sh
   ```

### El script dice "Archivos VMDK no encontrados"

1. Verifica que estés en la carpeta correcta del proyecto
2. Verifica que los archivos existan en `vm-images/disks/`
3. Ejecuta el script desde `scripts/vm-creation/`

## 📝 Cambios del Script

El script `createvm-improved.sh` fue actualizado para:

1. Definir rutas explícitas para origen y destino de las imágenes
2. Crear el directorio de discos en la carpeta de la VM
3. Copiar ambos archivos VMDK antes de crear la VM
4. Usar la ruta de destino al montar el disco
5. Mostrar información clara sobre dónde se encuentran los archivos
