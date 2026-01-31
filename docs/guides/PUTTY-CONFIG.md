# 🔌 Configuración de PuTTY para OpenVMS Community 2026

## 📋 Información de Conexión

```
Protocolo:  Telnet
Host:       127.0.0.1 (o localhost)
Puerto:     2026
Codificación: UTF-8 (recomendado)
Terminal:   VT100 (compatible con OpenVMS)
```

---

## 🛠️ Configuración Paso a Paso en PuTTY

### **PASO 1: Abre PuTTY**
1. Descarga PuTTY desde: https://www.putty.org/
2. Ejecuta `putty.exe`

### **PASO 2: Configuración Básica (Session)**
En la sección izquierda, verás **"Session"** (ya debe estar seleccionada)

| Campo | Valor |
|-------|-------|
| **Host Name (or IP address)** | `127.0.0.1` |
| **Port** | `2026` |
| **Connection type** | ⦿ **Telnet** (selecciona el radio button) |
| **Saved Sessions** | `OpenVMS-Community_2026` (opcional, para guardar) |

**Captura visual esperada:**
```
┌─────────────────────────────────────────┐
│ Session                                 │
├─────────────────────────────────────────┤
│ Host Name (or IP address)               │
│ [127.0.0.1________________________]      │
│                                         │
│ Port                                    │
│ [2026____]                              │
│                                         │
│ Connection type:                        │
│ ⦿ Raw  ○ Telnet  ○ Rlogin  ○ SSH      │
│ (cambiar a Telnet)                      │
└─────────────────────────────────────────┘
```

### **PASO 3: Configuración de Terminal (Recomendado)**
En la sección izquierda, expande **"Connection"** y selecciona **"Terminal"**

| Opción | Valor |
|--------|-------|
| **Terminal type string** | `VT100` |
| **Local line editing** | ☑ Dejar activado |
| **Local echo** | ☑ Dejar activado |

### **PASO 4: Configuración de Caracteres (Opcional pero Recomendado)**
En la sección izquierda: **Connection** → **Data**

| Opción | Valor |
|--------|-------|
| **Terminal-type string** | `VT100` |
| **Username** | Dejar en blanco (OpenVMS pedirá login) |
| **Auto-login username** | ☐ Sin marcar |

### **PASO 5: Configuración de Línea (Recomendado)**
En la sección izquierda: **Connection** → **Telnet**

| Opción | Valor |
|--------|-------|
| **Negotiated line speed** | ☐ Sin marcar (usa defecto) |
| **Active negotiations** | Dejar como está |

### **PASO 6: Guardar la Configuración (Opcional)**
1. Vuelve a **"Session"** (arriba en el árbol)
2. En **"Saved Sessions"** escribe: `OpenVMS-Community_2026`
3. Haz clic en **"Save"**
4. Luego puedes seleccionar esta sesión guardada y hacer clic en **"Load"** o **"Open"**

---

## 🚀 Conectarte a OpenVMS

### **Opción 1: Conexión Directa**
1. En la pantalla principal de PuTTY, ingresa:
   - **Host**: `127.0.0.1`
   - **Port**: `2026`
   - **Tipo**: Telnet
2. Haz clic en **"Open"**

### **Opción 2: Usar Sesión Guardada**
1. Selecciona `OpenVMS-Community_2026` de la lista
2. Haz clic en **"Load"**
3. Haz clic en **"Open"**

---

## 🔐 Credenciales de Acceso

Cuando se conecte, OpenVMS te pedirá:

```
OpenVMS (TM) Alpha Version 9.2-3

Username: [ingresa tu usuario]
Password: [ingresa tu contraseña]
```

**Credenciales predeterminadas** (depende de la instalación):
- **Usuario**: `SYSTEM` o `OPERATOR`
- **Contraseña**: Consulta con el administrador o documentación

---

## 💡 Consejos y Troubleshooting

### ✓ Si la conexión funciona correctamente:
- Verás la pantalla de login de OpenVMS
- El terminal responderá a comandos
- Puedes escribir comandos VMS

### ✗ Si no conecta:
1. **Verifica que la VM está corriendo:**
   ```bash
   vboxmanage list runningvms
   ```

2. **Verifica el puerto correcto:**
   - Puerto correcto: `2026`
   - No es `2025` ni `2027`

3. **Comprueba localhost:**
   - Usa `127.0.0.1` o `localhost`
   - No uses direcciones de red locales

4. **Firewall:**
   - Asegúrate que el firewall permite conexiones en puerto 2026
   - Es puerto local, generalmente no es problema

5. **Terminal Type:**
   - Si ves caracteres raros, cambia a `VT100` o `ANSI`

---

## 📌 Resumen Rápido

| Parámetro | Valor |
|-----------|-------|
| Host | 127.0.0.1 |
| Puerto | 2026 |
| Protocolo | Telnet |
| Terminal | VT100 |
| Codificación | UTF-8 |

---

## 📚 Referencia Rápida de Comandos OpenVMS

Una vez conectado:

```vms
$ HELP                    ! Ver ayuda general
$ SHOW TIME               ! Ver fecha y hora del sistema
$ SHOW USERS              ! Ver usuarios conectados
$ DIRECTORY               ! Listar archivos (equivalent to ls)
$ LOGOUT                  ! Desconectar
```

---

## 🎯 Configuración Alternativa (Advanced)

Si deseas ajustes adicionales en PuTTY:

### **Colors (Colores en Terminal)**
- **Connection** → **Data** → **Terminal Modes**
- Habilita colores si lo deseas

### **Fonts (Fuentes)**
- **Window** → **Appearance**
- Cambia fuente a **Courier New** (recomendado para terminal)
- Tamaño: **10-12 pt**

### **Scrollback (Buffer de desplazamiento)**
- **Window** → **Scrollback**
- Líneas de scrollback: `1000` (o más si lo necesitas)

---

## ✅ Checklist de Configuración

- [ ] Descargué PuTTY desde putty.org
- [ ] Abrí PuTTY
- [ ] Configuré Host: `127.0.0.1`
- [ ] Configuré Puerto: `2026`
- [ ] Seleccioné protocolo: **Telnet**
- [ ] Verifiqué tipo de terminal: **VT100**
- [ ] Guardé la sesión (opcional)
- [ ] La VM OpenVMS está corriendo
- [ ] Hago clic en "Open" para conectar

---

## 🆘 Contacto / Más Ayuda

Si algo no funciona:
1. Verifica que la VM está corriendo: `vboxmanage startvm "OpenVMS-Community_2026" --type=headless`
2. Espera 30-60 segundos para que boot completamente
3. Intenta conectar nuevamente
4. Si persiste, verifica firewall local

**¡Listo para conectarte! 🚀**
