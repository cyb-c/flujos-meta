# Procedimiento de Despliegue — Etapa 1: Slim + FTP

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Estado:** Pendiente de aprobación

---

## Índice de Contenido

1. [Propósito de este documento](#1-propósito-de-este-documento)
2. [Preparación del despliegue](#2-preparación-del-despliegue)
3. [Despliegue mediante agente](#3-despliegue-mediante-agente)
4. [Despliegue manual alternativo](#4-despliegue-manual-alternativo)
5. [Consideraciones de seguridad](#5-consideraciones-de-seguridad)
6. [Solución de problemas](#6-solución-de-problemas)
7. [Relación con otros documentos](#7-relación-con-otros-documentos)
8. [Referencias](#8-referencias)

---

## 1. Propósito de este documento

Este documento describe el **procedimiento operativo de despliegue FTP** para Etapa 1, incluyendo el uso del agente desplegador y alternativas manuales.

### Contexto

Este documento se deriva de:
- `30-Plan-Etapa01-Slim-FTP.md` — Plan de trabajo
- `10-Decisiones-Etapa01-Slim-FTP.md` — Decisiones de rutas y configuración

---

## 2. Preparación del despliegue

### 2.1 Pre-requisitos

Antes de desplegar, verificar:

| Requisito | Verificación | Comando |
|-----------|--------------|---------|
| Slim instalado | `composer.json` existe y tiene Slim | `composer show slim/slim` |
| Dependencias instaladas | `vendor/` existe | `ls -la vendor/` |
| Front controller existe | `public/index.php` existe | `ls -la public/index.php` |
| Credenciales FTP | Variables de entorno configuradas | `echo $CONTRASENYA_FTP_WA` (debe mostrar algo) |
| Cliente FTP | `lftp` disponible | `which lftp` |

### 2.2 Preparación del paquete

```bash
# Desde la raíz del repositorio
composer install --no-dev --optimize-autoloader

# Verificar tamaño
du -sh vendor/
# Esperado: 2-4 MB
```

### 2.3 Archivos a desplegar

| Elemento | Incluir | Justificación |
|----------|---------|---------------|
| `public/index.php` | ✅ Sí | Front controller |
| `vendor/` | ✅ Sí | Dependencias pre-instaladas |
| `composer.json` | ✅ Sí | Referencia de versiones |
| `composer.lock` | ✅ Sí | Bloqueo de versiones exactas |
| `app/` | ✅ Sí | Estructura base |
| `config/` | ✅ Sí | Configuración |
| `.git/` | ❌ No | No necesario en producción |
| `.gitignore` | ❌ No | No necesario en producción |
| `pre-proyecto/` | ❌ No | Solo documentación |

---

## 3. Despliegue mediante agente

### 3.1 Agente disponible

El proyecto dispone del agente `@ftp-deployer` para despliegues FTP.

**Implementación:** `.opencode/agents/ftp-deployer.md`  
**Especificación:** `pre-proyecto/agentica/ftp-deployer-agent-spec.md`

### 3.2 Invocación manual

Desde el TUI de OpenCode:

```
@ftp-deployer despliega la Web-App
```

### 3.3 Invocación desde orquestador

Un agente orquestador puede delegar vía Task:

```
Task: @ftp-deployer despliega la WA completa
```

### 3.4 Flujo del agente

El agente ejecuta automáticamente:

1. **Pre-validación:** Verifica directorio fuente y credenciales
2. **Preparación:** Ejecuta `composer install --no-dev` si es necesario
3. **Conexión FTP:** Conecta con credenciales de variables de entorno
4. **Transferencia:** Usa `lftp mirror --reverse` para sincronizar
5. **Verificación:** Confirma archivos transferidos
6. **Informe:** Devuelve resumen estructurado

### 3.5 Configuración del agente

El agente debe leer las siguientes variables de entorno:

| Variable | Propósito | Ejemplo |
|----------|-----------|---------|
| `FTP_SERVER` | Servidor FTP | `ftp.bee-viva.es` |
| `FTP_USER` | Usuario FTP | `ftp-wa@levantecofem.es` |
| `FTP_PASSWORD` | Contraseña FTP | `${CONTRASENYA_FTP_WA}` |
| `FTP_TARGET_PATH` | Directorio target | `/home/beevivac/stg2.cofemlevante.es/` |
| `FTP_PORT` | Puerto FTP | `21` |

### 3.6 Respuesta esperada del agente

```
✅ Despliegue completado
━━━━━━━━━━━━━━━━━━━━━━━━━
📦 Origen:  raíz del repositorio (3.2 MB)
🎯 Destino: /home/beevivac/stg2.cofemlevante.es/
📡 Cliente: lftp

📋 Archivos transferidos:
  - public/index.php
  - vendor/ (18 subdirectorios, 142 archivos)
  - composer.json
  - composer.lock
  - app/
  - config/

✅ Verificación:
  - HTTP 200: ✅ (1.2s)
  - Contenido "Hola mundo": ✅
  - Archivos remotos coinciden: ✅

➡️ Siguiente paso: Verificar en navegador https://stg2.cofemlevante.es/
```

---

## 4. Despliegue manual alternativo

### 4.1 Script de despliegue (`deploy.sh`)

Crear en la raíz del repositorio:

```bash
#!/bin/bash
set -e

echo "🚀 Preparando despliegue..."

# 1. Instalar dependencias
composer install --no-dev --optimize-autoloader

# 2. Verificar archivos
echo "📦 Archivos a subir:"
du -sh .

# 3. Conectar por FTP y subir
echo "📡 Conectando a FTP..."
lftp -e "
open ${FTP_SERVER:-ftp.bee-viva.es};
user ${FTP_USER:-ftp-wa@levantecofem.es} ${FTP_PASSWORD};
cd ${FTP_TARGET_PATH:-/home/beevivac/stg2.cofemlevante.es};
mirror --reverse --delete ./ .;
bye
"

echo "✅ Despliegue completado"
```

### 4.2 Ejecución del script

```bash
# Hacer ejecutable
chmod +x deploy.sh

# Ejecutar (FTP_PASSWORD debe estar en entorno)
FTP_PASSWORD=$CONTRASENYA_FTP_WA ./deploy.sh
```

### 4.3 Comando lftp directo

Alternativa sin script:

```bash
cd /path/to/repositorio

lftp -e "
open ftp.bee-viva.es;
user ftp-wa@levantecofem.es $CONTRASENYA_FTP_WA;
cd /home/beevivac/stg2.cofemlevante.es;
mirror --reverse --delete ./ .;
bye
"
```

### 4.4 Opción con curl (archivos individuales)

No recomendado para despliegue completo, útil para archivos específicos:

```bash
# Subir archivo individual
curl -T public/index.php ftps://ftp.bee-viva.es/ \
  --user ftp-wa@levantecofem.es:$CONTRASENYA_FTP_WA \
  --ssl-reqd
```

---

## 5. Consideraciones de seguridad

### 5.1 Gestión de credenciales

| Práctica | Correcto | Incorrecto |
|----------|----------|------------|
| **Almacenamiento** | GitHub Secrets | Archivos en el repositorio |
| **Uso en scripts** | Variables de entorno | Hardcodeadas en el script |
| **Logs** | Nunca mostrar contraseña | `echo $CONTRASENYA_FTP_WA` |
| **Comandos** | Pasar como variable | Argumento visible en `ps` |

### 5.2 FTPS (FTP sobre TLS)

**Siempre usar FTPS explícito:**

```bash
# lftp usa FTPS por defecto en puerto 21
# Verificar con:
lftp -e "set ssl:verify-certificate no; open ftps://ftp.bee-viva.es; ..."
```

### 5.3 Permisos de archivos

Verificar después del despliegue:

```bash
# Archivos: 644
# Directorios: 755

# Verificar con lftp:
lftp -e "ls -la /home/beevivac/stg2.cofemlevante.es/; bye"
```

---

## 6. Solución de problemas

### 6.1 Errores comunes

| Error | Causa probable | Solución |
|-------|----------------|----------|
| `Connection refused` | Firewall o puerto incorrecto | Verificar puerto 21, firewall |
| `Login incorrect` | Credenciales incorrectas | Verificar en GitHub Secrets |
| `No such file or directory` | Directorio target incorrecto | Verificar `FTP_TARGET_PATH` |
| `Permission denied` | Permisos FTP insuficientes | Verificar permisos de la cuenta FTP |
| `Timeout` | Red o servidor lento | Reintentar, verificar conectividad |

### 6.2 Diagnóstico de conectividad

```bash
# Verificar conexión al servidor
nc -zv ftp.bee-viva.es 21

# Verificar credenciales (sin subir archivos)
lftp -e "open ftp.bee-viva.es; user ftp-wa@levantecofem.es $CONTRASENYA_FTP_WA; ls; bye"
```

### 6.3 Verificación post-despliegue

```bash
# Verificar HTTP 200
curl -I https://stg2.cofemlevante.es/

# Verificar contenido
curl https://stg2.cofemlevante.es/

# Verificar archivos remotos
lftp -e "ls -la /home/beevivac/stg2.cofemlevante.es/; bye"
```

---

## 7. Relación con otros documentos

### Documentos de los que depende

| Documento | Relación |
|-----------|----------|
| `30-Plan-Etapa01-Slim-FTP.md` | Plan de trabajo |
| `10-Decisiones-Etapa01-Slim-FTP.md` | Decisiones de configuración |

### Documentos que dependen de este

| Documento | Relación |
|-----------|----------|
| `50-Verificacion-Etapa01-Slim-FTP.md` | Verificación post-despliegue |
| `60-Pendientes-Etapa01-Slim-FTP.md` | Registro de incidencias |

### Jerarquía de documentos de Etapa 1

```
10-Decisiones-Etapa01-Slim-FTP.md
└── 20-Alcance-Etapa01-Slim-FTP.md
    └── 30-Plan-Etapa01-Slim-FTP.md
        └── 40-Despliegue-Etapa01-Slim-FTP.md (este documento)
            └── 50-Verificacion-Etapa01-Slim-FTP.md
```

---

## 8. Referencias

### Documentos de este proyecto

| Documento | Ruta |
|-----------|------|
| Plan de Etapa 1 | `30-Plan-Etapa01-Slim-FTP.md` |
| Índice de implantación | `00-INDICE-Implantacion.md` |
| Agente ftp-deployer | `../agentica/ftp-deployer-agent-spec.md` |

### Documentación externa

| Recurso | URL |
|---------|-----|
| lftp documentation | https://lftp.yar.ru/ |
| curl documentation | https://curl.se/docs/ |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Creación del documento (descompuesto de Etapa01_Slim-Despliegue-FTP.md) | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
