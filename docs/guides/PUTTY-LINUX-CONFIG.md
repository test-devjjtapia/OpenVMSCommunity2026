# 🔌 Configuración de PuTTY para OpenVMS en Linux Fedora 43

## 📋 Información de Conexión

```
Protocolo:  Telnet
Host:       127.0.0.1 (o localhost)
Puerto:     2026
Codificación: UTF-8
Terminal:   VT100
```

**PuTTY versión instalada:**
```
Release 0.83 (GTK 3.24.49)
Compilador: gcc 15.2.1
Plataforma: 64-bit Unix
```

---

## 🚀 FORMA MÁS RÁPIDA - Telnet Directo

La forma más simple es usar el cliente `telnet` nativo de Linux:

```bash
telnet 127.0.0.1 2026
```

O si prefieres alias para acceso rápido, añade a `~/.bashrc`:

```bash
alias openvms-telnet="telnet 127.0.0.1 2026"
```

Luego solo necesitas escribir:
```bash
openvms-telnet
```

---

## 🛠️ Configuración de PuTTY en Linux/Fedora (Alternativa)

### **PASO 1: Abre PuTTY desde Terminal**

```bash
putty &
```

O simplemente busca PuTTY en tu menú de aplicaciones.

### **PASO 2: Configuración Básica (Session)**

En la sección izquierda, verás **"Session"** (ya debe estar seleccionada)

| Campo | Valor |
|-------|-------|
| **Host Name (or IP address)** | `127.0.0.1` |
| **Port** | `2026` |
| **Connection type** | ⦿ **Telnet** |
| **Saved Sessions** | `OpenVMS-Community_2026` |

**Pasos:**
1. En el campo "Host Name", escribe: `127.0.0.1`
2. En el campo "Port", escribe: `2026`
3. Selecciona el radio button **"Telnet"**
4. En "Saved Sessions" escribe: `OpenVMS-Community_2026`
5. Haz clic en **"Save"**

### **PASO 3: Configuración de Terminal (Recomendado)**

En el árbol izquierdo, expande **"Connection"** → selecciona **"Terminal"**

| Opción | Valor |
|--------|-------|
| **Terminal-type string** | `VT100` |
| **Local line editing** | ☑ Activado |
| **Local echo** | ☑ Activado |

### **PASO 4: Guardar y Conectar**

Vuelve a **"Session"** y haz clic en **"Open"**

---

## ⚡ Formas de Conectar desde Terminal Linux

### **Opción 1: Telnet Directo (RECOMENDADO)**
```bash
telnet 127.0.0.1 2026
```

### **Opción 2: PuTTY desde CLI**
```bash
putty -telnet 127.0.0.1 2026 &
```

### **Opción 3: PuTTY con sesión guardada**
```bash
putty -load "OpenVMS-Community_2026" &
```

### **Opción 4: Conexión SSH-like con plink (cliente PuTTY)**
```bash
plink -telnet 127.0.0.1 2026
```

---

## 📝 Script Bash para Conectar Rápido

Crea un archivo `connect-openvms.sh`:

```bash
#!/bin/bash

# OpenVMS Community 2026 - Conector Telnet/PuTTY en Linux

HOST="127.0.0.1"
PORT="2026"

echo ""
echo "=========================================="
echo "OpenVMS Community 2026 - Conector Linux"
echo "=========================================="
echo ""
echo "Opciones de conexión:"
echo "  1) Telnet directo (recomendado)"
echo "  2) PuTTY GTK"
echo "  3) Plink (cliente PuTTY en terminal)"
echo ""
read -p "Selecciona opción (1-3): " option

case $option in
    1)
        echo ""
        echo "Conectando con telnet a $HOST:$PORT..."
        echo "(Para salir, escribe: quit)"
        echo ""
        telnet $HOST $PORT
        ;;
    2)
        echo ""
        echo "Abriendo PuTTY..."
        putty -telnet $HOST $PORT &
        ;;
    3)
        echo ""
        echo "Conectando con plink a $HOST:$PORT..."
        plink -telnet $HOST $PORT
        ;;
    *)
        echo "Opción inválida"
        exit 1
        ;;
esac

exit 0
```

**Hacer ejecutable y usar:**
```bash
chmod +x connect-openvms.sh
./connect-openvms.sh
```

---

## 🔐 Credenciales de Acceso

Cuando se conecte, OpenVMS te pedirá:

```
OpenVMS (TM) Alpha Version 9.2-3

Username: [ingresa tu usuario]
Password: [ingresa tu contraseña]
```

**Credenciales predeterminadas:**
- **Usuario**: `SYSTEM` o `OPERATOR`
- **Contraseña**: Según tu configuración

---

## 💡 Consejos para Linux/Fedora

### ✓ Comandos útiles después de conectar:
```vms
$ HELP                    ! Ver ayuda general
$ SHOW TIME               ! Ver fecha y hora del sistema
$ SHOW USERS              ! Ver usuarios conectados
$ DIRECTORY               ! Listar archivos
$ LOGOUT                  ! Desconectar
```

### ✓ Atajos de teclado en PuTTY (Linux):
- `Ctrl+A` - Seleccionar todo
- `Ctrl+C` - Copiar
- `Ctrl+V` - Pegar
- `Ctrl+D` - Desconectar (en telnet)

### ✓ Guardar sesión de terminal:
```bash
script openvms-session.log
telnet 127.0.0.1 2026
# ... tu sesión ...
exit
```

---

## ⚙️ Configuración Avanzada para PuTTY en Linux

### **Tema Oscuro (para ojos cansados)**
En PuTTY → **Window** → **Colors**:
- Selecciona un tema oscuro o personaliza colores
- Fondo: Negro o gris oscuro
- Texto: Verde o blanco

### **Fuente**
En PuTTY → **Window** → **Appearance**:
- Fuente: **Monospace** o **Courier New**
- Tamaño: **10-12 pt**

### **Scrollback (buffer)**
En PuTTY → **Window** → **Scrollback**:
- Líneas: `2000` (para más historial)

---

## 🔍 Verificaciones Previas

Antes de conectar, asegúrate de:

```bash
# 1. VM está corriendo
vboxmanage list runningvms | grep OpenVMS

# 2. Puerto 2026 está abierto (escuchando)
netstat -an | grep 2026
# O con ss (más moderno):
ss -an | grep 2026

# 3. Telnet está disponible
which telnet

# 4. PuTTY está instalado (opcional)
which putty
putty --version
```

---

## 🆘 Troubleshooting en Linux

### **Problema: "Connection refused"**
- Solución: Verifica que la VM está corriendo
  ```bash
  vboxmanage startvm "OpenVMS-Community_2026" --type=headless
  ```

### **Problema: "telnet: command not found"**
- Solución: Instala telnet
  ```bash
  sudo dnf install telnet
  ```

### **Problema: No puedo ver la pantalla correctamente**
- Solución: Usa terminal type VT100
  ```bash
  TERM=vt100 telnet 127.0.0.1 2026
  ```

### **Problema: Caracteres extraños en la salida**
- Solución: Intenta con codificación UTF-8
  ```bash
  LANG=en_US.UTF-8 telnet 127.0.0.1 2026
  ```

---

## 📌 Resumen Rápido

| Acción | Comando |
|--------|---------|
| Conectar (telnet) | `telnet 127.0.0.1 2026` |
| Conectar (PuTTY) | `putty -telnet 127.0.0.1 2026 &` |
| Ver VM corriendo | `vboxmanage list runningvms` |
| Iniciar VM | `vboxmanage startvm "OpenVMS-Community_2026" --type=headless` |
| Crear alias telnet | Añadir a `~/.bashrc`: `alias openvms='telnet 127.0.0.1 2026'` |

---

## 🎯 Mi Recomendación para Fedora 43

**OPCIÓN 1 (Más simple):**
```bash
alias openvms='telnet 127.0.0.1 2026'
# Luego solo escribes: openvms
```

**OPCIÓN 2 (Más visual):**
```bash
putty -telnet 127.0.0.1 2026 &
```

**OPCIÓN 3 (Script interactivo):**
```bash
chmod +x connect-openvms.sh
./connect-openvms.sh
```

---

## ✅ Checklist de Configuración

- [ ] Tengo PuTTY 0.83 instalado o telnet disponible
- [ ] La VM OpenVMS está corriendo
- [ ] Verifico con: `vboxmanage list runningvms`
- [ ] Ejecuto: `telnet 127.0.0.1 2026`
- [ ] Veo el login de OpenVMS
- [ ] Ingreso credenciales (SYSTEM o según sea)
- [ ] ¡Conectado! ✅

---

## 📚 Comandos útiles post-conexión

```bash
# En tu terminal Linux (ANTES de conectar)

# Ver puertos abiertos
lsof -i :2026

# Monitorear la VM
vboxmanage metrics collect -period 10 -samples 10

# Ver logs de la VM
vboxmanage showvminfo "OpenVMS-Community_2026"

# Detener la VM
vboxmanage controlvm "OpenVMS-Community_2026" poweroff

# Guardar sesión a archivo
script openvms-log-$(date +%Y%m%d-%H%M%S).log
telnet 127.0.0.1 2026
exit
```

---

**¡Listo para conectarte desde Fedora 43! 🚀**
