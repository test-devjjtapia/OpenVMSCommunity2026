# 🐧 OpenVMS Community 2026 - Guía de Conexión en Fedora 43

## ⚡ FORMA MÁS RÁPIDA

**Opción 1 - Telnet Directo (RECOMENDADO):**
```bash
telnet 127.0.0.1 2026
```

**Opción 2 - Usando el script interactivo:**
```bash
chmod +x connect-openvms.sh
./connect-openvms.sh
```

**Opción 3 - Crear un alias permanente:**

Abre `~/.bashrc` y añade al final:
```bash
alias openvms='telnet 127.0.0.1 2026'
```

Luego:
```bash
source ~/.bashrc
openvms
```

---

## 📦 Archivos Disponibles

| Archivo | Descripción | Uso |
|---------|-------------|-----|
| `createvm-improved.sh` | Crea la VM OpenVMS | `./createvm-improved.sh` |
| `connect-openvms.sh` | Conector interactivo (Linux) | `./connect-openvms.sh` |
| `PUTTY-LINUX-CONFIG.md` | Guía completa de PuTTY en Linux | Referencia |
| `PUTTY-CONFIG.md` | Guía general de PuTTY (Windows/Linux) | Referencia |

---

## 🔌 Datos de Conexión

```
Host:       127.0.0.1 (localhost)
Puerto:     2026
Protocolo:  Telnet
Terminal:   VT100
Codificación: UTF-8
```

---

## 🚀 Paso a Paso - Fedora 43

### 1️⃣ **Verificar que la VM está corriendo:**
```bash
vboxmanage list runningvms
```

Si no aparece, iniciala:
```bash
vboxmanage startvm "OpenVMS-Community_2026" --type=headless
```

### 2️⃣ **Verificar que telnet está instalado:**
```bash
which telnet
```

Si no lo encuentras, instálalo:
```bash
sudo dnf install telnet
```

### 3️⃣ **Conectar:**
```bash
telnet 127.0.0.1 2026
```

### 4️⃣ **Ingresa credenciales:**
```
Username: SYSTEM
Password: (según tu configuración)
```

---

## 🛠️ Usando PuTTY en Fedora

### **Opción A - Línea de comandos rápida:**
```bash
putty -telnet 127.0.0.1 2026 &
```

### **Opción B - Con el script interactivo:**
```bash
./connect-openvms.sh
# Selecciona opción 2 (PuTTY GTK)
```

### **Opción C - Desde GUI:**
```bash
# Abre el menú de aplicaciones y busca "PuTTY"
# O ejecuta:
putty &
```

En PuTTY GTK, configura:
- **Host:** `127.0.0.1`
- **Port:** `2026`
- **Type:** Telnet

---

## 💡 Scripts y Alias Útiles

### **Script de conexión rápida:**
```bash
#!/bin/bash
echo "Conectando a OpenVMS..."
sleep 1
telnet 127.0.0.1 2026
```

Guardalo como `openvms-connect.sh`, luego:
```bash
chmod +x openvms-connect.sh
./openvms-connect.sh
```

### **Alias en .bashrc:**
```bash
# Conexión telnet
alias openvms='telnet 127.0.0.1 2026'

# Ver VM corriendo
alias vm-status='vboxmanage list runningvms'

# Iniciar VM
alias vm-start='vboxmanage startvm "OpenVMS-Community_2026" --type=headless'

# Detener VM
alias vm-stop='vboxmanage controlvm "OpenVMS-Community_2026" poweroff'
```

Luego usa:
```bash
openvms              # Conectar
vm-status            # Ver si VM está corriendo
vm-start             # Iniciar VM
vm-stop              # Detener VM
```

---

## 🎯 Checklist de Conexión

- [ ] PuTTY 0.83 está instalado en Fedora 43
- [ ] Telnet está instalado
- [ ] VM OpenVMS está corriendo: `vboxmanage list runningvms`
- [ ] Puerto 2026 está abierto: `ss -an | grep 2026`
- [ ] Ejecuto: `telnet 127.0.0.1 2026`
- [ ] Veo el login de OpenVMS
- [ ] Ingreso credenciales

---

## 🆘 Troubleshooting

### **"Connection refused"**
```bash
# Verifica que la VM está corriendo
vboxmanage list runningvms

# Si no aparece, inicia
vboxmanage startvm "OpenVMS-Community_2026" --type=headless

# Espera 30 segundos y vuelve a intentar
```

### **"telnet: command not found"**
```bash
# Instala telnet
sudo dnf install telnet

# O usa plink (viene con PuTTY)
plink -telnet 127.0.0.1 2026
```

### **Caracteres extraños en terminal**
```bash
# Asegúrate que TERM está correctamente configurado
TERM=vt100 telnet 127.0.0.1 2026

# O intenta con xterm
TERM=xterm telnet 127.0.0.1 2026
```

### **PuTTY no se abre desde terminal**
```bash
# Instala PuTTY
sudo dnf install putty

# O desde repositorio de actualizaciones
sudo dnf install --refresh putty

# Verifica que está instalado
putty --version
```

---

## 📚 Comandos Básicos de OpenVMS

Una vez conectado, prueba estos comandos:

```vms
$ HELP                    ! Ayuda general
$ HELP COMMANDS           ! Lista de comandos disponibles
$ SHOW TIME               ! Fecha y hora actual
$ SHOW USERS              ! Usuarios conectados
$ DIRECTORY               ! Listar archivos
$ TYPE FILENAME.EXT       ! Ver contenido de archivo
$ DELETE FILENAME.EXT     ! Borrar archivo
$ LOGOUT                  ! Desconectar
```

---

## 📌 Información Rápida

**PuTTY Version:**
```
Release 0.83
Build: 64-bit Unix (pure GTK)
Compiler: gcc 15.2.1
GTK: 3.24.49
```

**Tu Sistema:**
```
OS: Fedora 43
Arquitectura: x86_64
```

**Conexión:**
```
Tipo: Telnet
Host: 127.0.0.1
Puerto: 2026
```

---

## ✅ Resumen Final

**Para conectarte rápido:**
1. Abre terminal
2. Ejecuta: `telnet 127.0.0.1 2026`
3. Ingresa credenciales

**O usa el script interactivo:**
```bash
./connect-openvms.sh
```

**Listo! 🎉**

Cualquier pregunta, revisa `PUTTY-LINUX-CONFIG.md` para más detalles.
