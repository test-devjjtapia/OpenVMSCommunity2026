# 🔧 Solución: Caracteres Extraños en Terminal OpenVMS

## ❌ Problema Identificado

```
^[[?61;1;21;22;28c
^[[45;212R
^[[?61;1;21;22;28c
```

Estos son **códigos ANSI de escape** que OpenVMS envía pero telnet no interpreta correctamente.

**Causa:** Tipo de terminal no configurado adecuadamente.

---

## ✅ SOLUCIONES (Elige una)

### **SOLUCIÓN 1: Ejecutar telnet con TERM correcto (RECOMENDADO)**

**ANTES de conectar, desde tu terminal Fedora:**

```bash
TERM=vt100 telnet 127.0.0.1 2026
```

O intenta con otros tipos:
```bash
TERM=xterm telnet 127.0.0.1 2026
TERM=ansi telnet 127.0.0.1 2026
```

**Esto debería resolver el problema inmediatamente.**

---

### **SOLUCIÓN 2: Configurar desde OpenVMS después de conectar**

Si ya estás conectado y ves caracteres raros, ejecuta esto:

```vms
$ SET TERMINAL /NOBROADCAST /NOTYPEAHEAD
```

Para limpiar la pantalla:
```vms
$ CLEAR
```

---

### **SOLUCIÓN 3: Crear alias en Fedora para conexión "limpia"**

Abre `~/.bashrc` y añade:

```bash
# Alias para conectar a OpenVMS sin caracteres raros
alias openvms-clean='TERM=vt100 telnet 127.0.0.1 2026'
```

Luego:
```bash
source ~/.bashrc
openvms-clean
```

---

### **SOLUCIÓN 4: Script mejorado**

Crea archivo `connect-clean.sh`:

```bash
#!/bin/bash

# Forza tipo de terminal VT100
export TERM=vt100

# Opciones de telnet limpias
echo "Conectando con terminal limpia..."
telnet 127.0.0.1 2026
```

Úsalo:
```bash
chmod +x connect-clean.sh
./connect-clean.sh
```

---

### **SOLUCIÓN 5: PuTTY (Sin caracteres raros)**

PuTTY maneja mejor los tipos de terminal. Usa:

```bash
putty -telnet 127.0.0.1 2026 &
```

En PuTTY, configura:
- **Connection** → **Terminal** → **Terminal-type string**: `vt100`

---

## 🎯 MÁS RÁPIDO - Una Línea

```bash
TERM=vt100 telnet 127.0.0.1 2026
```

**Esto es lo que necesitas ejecutar ahora mismo.**

---

## 📋 Comparación de Tipos de Terminal

| Tipo | Recomendación | Uso |
|------|---------------|-----|
| `vt100` | ⭐ MEJOR | Terminal clásico, máxima compatibilidad OpenVMS |
| `xterm` | ✓ Bueno | Terminal moderno, más colores |
| `ansi` | ✓ Aceptable | ANSI básico |
| `linux` | ⚠️ Evitar | Puede causar problemas |

---

## 🆘 Si Persisten los Caracteres Raros

1. **Intenta con TERM diferente:**
   ```bash
   TERM=xterm telnet 127.0.0.1 2026
   ```

2. **Desde OpenVMS, intenta:**
   ```vms
   $ SET TERMINAL /NOTYPEAHEAD /NOBROADCAST
   $ CLEAR
   ```

3. **Usa PuTTY en lugar de telnet:**
   ```bash
   putty -telnet 127.0.0.1 2026 &
   ```

---

## 💡 Comandos Útiles Una Vez Conectado

```vms
$ SHOW TERMINAL        ! Ver configuración de terminal
$ SET TERMINAL /CLEAR  ! Limpiar pantalla
$ SET TERMINAL /WRAP   ! Habilitar wrap de líneas
$ LOGOUT               ! Desconectar
```

---

## ✔️ Cómo Saber que Funcionó

✅ Verás esto **sin caracteres extraños:**
```
VMS Software, Inc. OpenVMS (TM) x86_64 Operating System, V9.2-3
    Last interactive login on Friday, 30-JAN-2026 13:43:52.85

$
```

❌ En lugar de esto:
```
^[[?61;1;21;22;28cactive login on Friday
^[[45;212R^[[?61;1;21;22;28c
```

---

## 📝 Resumen

**Ejecuta esto ahora:**

```bash
TERM=vt100 telnet 127.0.0.1 2026
```

Si funciona, guarda este alias en `~/.bashrc`:

```bash
alias openvms='TERM=vt100 telnet 127.0.0.1 2026'
```

**¡Problema resuelto! ✅**
