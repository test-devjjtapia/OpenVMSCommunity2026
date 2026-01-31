# OpenVMS Community 2026

Repositorio para la gestión y documentación del paquete OpenVMS Community 2026, incluyendo scripts de instalación, configuración de conexiones y recursos educativos.

## 📁 Estructura del Proyecto

```
.
├── docs/                          # Documentación
│   ├── setup/                     # Guías de configuración inicial
│   ├── guides/                    # Guías de uso y troubleshooting
│   └── tutorials/                 # Tutoriales paso a paso
├── scripts/                       # Scripts de utilidad
│   ├── connection/                # Scripts de conexión a OpenVMS
│   └── vm-creation/               # Scripts para crear VMs
├── vm-images/
│   └── disks/                     # Imágenes de disco VMDK
├── resources/
│   ├── pdfs/                      # Documentos PDF
│   └── videos/                    # Videos educativos
├── config/                        # Archivos de configuración
└── README.md                      # Este archivo
```

## 🚀 Inicio Rápido

### Instalación en Windows
Consulta la guía de Putty para Windows: `docs/guides/PUTTY-CONFIG.md`

### Instalación en Linux
Consulta la guía de Putty para Linux: `docs/guides/PUTTY-LINUX-CONFIG.md`

### Conexión a OpenVMS
- Script de conexión: `scripts/connection/connect-openvms.sh`
- Script de limpieza: `scripts/connection/connect-clean.sh`

### Creación de VMs
- Script básico: `scripts/vm-creation/createvm.sh`
- Script mejorado: `scripts/vm-creation/createvm-improved.sh`

## 📚 Documentación

- **Configuración Fedora**: `docs/setup/CONEXION-FEDORA.md`
- **Terminal Fix**: `docs/guides/TERMINAL-FIX.md`
- **PDFs Adicionales**: `resources/pdfs/`

## 💾 Imágenes de VM

Las imágenes de disco están en `vm-images/disks/`:
- `X86_V923-comm-2026.vmdk` - Archivo descriptor
- `X86_V923-comm-2026-flat.vmdk` - Archivo de datos de disco

## 📖 Recursos

- **Videos**: `resources/videos/`
- **Documentos**: `resources/pdfs/`

## 🔧 Requisitos

- VirtualBox o hypervisor compatible
- PuTTY o cliente SSH
- Imagen OpenVMS Community 2026

## ✅ Pre-flight checklist

- [ ] `vboxmanage` disponible en PATH: `command -v vboxmanage`
- [ ] Espacio en disco suficiente (recomendado > 10 GB libre en la partición destino)
- [ ] `telnet` o `putty` instalado en el host
- [ ] Archivos VMDK presentes en `vm-images/disks/`
- [ ] Privilegios para ejecutar `vboxmanage` y crear directorios en `~/VirtualBox VMs`

## 📝 Licencia

OpenVMS Community License Package 2026

## 📧 Contacto

Para consultas sobre el paquete de licencia de OpenVMS Community 2026, consulte los documentos en `resources/pdfs/`
