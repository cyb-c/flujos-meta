# Procedimiento de Verificación — Etapa 1: Slim + FTP

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Estado:** Pendiente de aprobación

---

## Índice de Contenido

1. [Propósito de este documento](#1-propósito-de-este-documento)
2. [Checklist de verificación](#2-checklist-de-verificación)
3. [Verificación HTTP](#3-verificación-http)
4. [Verificación de archivos](#4-verificación-de-archivos)
5. [Verificación de logs](#5-verificación-de-logs)
6. [Criterios de éxito](#6-criterios-de-éxito)
7. [Diagnóstico de errores](#7-diagnóstico-de-errores)
8. [Relación con otros documentos](#8-relación-con-otros-documentos)
9. [Referencias](#9-referencias)

---

## 1. Propósito de este documento

Este documento describe el **procedimiento de verificación post-despliegue** para Etapa 1, incluyendo tests HTTP, verificación de archivos y revisión de logs.

### Contexto

Este documento se deriva de:
- `40-Despliegue-Etapa01-Slim-FTP.md` — Procedimiento de despliegue
- `30-Plan-Etapa01-Slim-FTP.md` — Plan de trabajo

---

## 2. Checklist de verificación

### 2.1 Verificación inmediata post-despliegue

Completar **inmediatamente después** del despliegue:

- [ ] El endpoint `/` responde HTTP 200 OK
- [ ] El contenido muestra "Hola mundo"
- [ ] El endpoint `/hello` responde HTTP 200 OK
- [ ] El contenido de `/hello` muestra "Hola mundo desde Slim"
- [ ] No hay errores 404 o 500 en la respuesta
- [ ] El tiempo de respuesta es menor a 2 segundos

### 2.2 Verificación de archivos

Completar **dentro de las 24 horas** siguientes:

- [ ] Los archivos tienen permisos correctos (644/755)
- [ ] El directorio `vendor/` está completo
- [ ] El autoload de Composer funciona
- [ ] `public/index.php` existe y es legible
- [ ] `composer.json` y `composer.lock` existen

### 2.3 Verificación de logs

Completar **dentro de las 24 horas** siguientes:

- [ ] No hay errores en logs de PHP
- [ ] No hay errores en logs del servidor web
- [ ] No hay warnings críticos en logs

---

## 3. Verificación HTTP

### 3.1 Verificar código de estado HTTP

```bash
# Verificar HTTP 200
curl -I https://stg2.cofemlevante.es/

# Respuesta esperada:
# HTTP/2 200
# content-type: text/html; charset=UTF-8
```

### 3.2 Verificar contenido

```bash
# Verificar contenido de la raíz
curl https://stg2.cofemlevante.es/

# Respuesta esperada:
# Hola mundo
```

```bash
# Verificar contenido de /hello
curl https://stg2.cofemlevante.es/hello

# Respuesta esperada:
# Hola mundo desde Slim
```

### 3.3 Verificar headers completos

```bash
# Verificar headers detallados
curl -v https://stg2.cofemlevante.es/

# Verificar:
# - HTTP/2 200
# - server: LiteSpeed (o similar)
# - content-type: text/html; charset=UTF-8
# - Sin headers de error
```

### 3.4 Verificar tiempo de respuesta

```bash
# Verificar tiempo de respuesta
curl -w "%{time_total}\n" -o /dev/null -s https://stg2.cofemlevante.es/

# Esperado: < 2 segundos
```

---

## 4. Verificación de archivos

### 4.1 Verificar estructura de directorios

```bash
# Conectar por FTP y listar
lftp -e "
open ftp.bee-viva.es;
user ftp-wa@levantecofem.es $CONTRASENYA_FTP_WA;
ls -la /home/beevivac/stg2.cofemlevante.es/;
bye
"
```

### 4.2 Estructura esperada

```
/home/beevivac/stg2.cofemlevante.es/
├── app/
│   ├── Controllers/
│   ├── Services/
│   ├── Middleware/
│   └── Config/
├── public/
│   └── index.php
├── vendor/
├── config/
├── composer.json
└── composer.lock
```

### 4.3 Verificar permisos

```bash
# Verificar permisos por FTP
lftp -e "
open ftp.bee-viva.es;
user ftp-wa@levantecofem.es $CONTRASENYA_FTP_WA;
ls -la /home/beevivac/stg2.cofemlevante.es/public/;
bye
"

# Esperado:
# -rw-r--r-- (644) para archivos
# drwxr-xr-x (755) para directorios
```

### 4.4 Verificar autoload

```bash
# Crear archivo de test temporal
# test-autoload.php en raíz:
<?php
require __DIR__ . '/vendor/autoload.php';
echo "Autoload OK";

# Subir por FTP y acceder vía web:
# https://stg2.cofemlevante.es/test-autoload.php

# Esperado: "Autoload OK"

# Eliminar archivo después del test
```

---

## 5. Verificación de logs

### 5.1 Acceder a logs de error

Si hay acceso por FTP:

```bash
lftp -e "
open ftp.bee-viva.es;
user ftp-wa@levantecofem.es $CONTRASENYA_FTP_WA;
get /home/beevivac/logs/stg2.cofemlevante.es/error.log;
bye
"

# Revisar archivo local:
cat error.log | tail -50
```

### 5.2 Verificar errores de PHP

Buscar en logs:

```bash
# Errores críticos
grep -i "fatal error" error.log

# Errores generales
grep -i "error" error.log | tail -20

# Warnings importantes
grep -i "warning" error.log | tail -20
```

### 5.3 Errores comunes a buscar

| Error | Causa | Solución |
|-------|-------|----------|
| `failed to open stream` | Autoload no encuentra archivo | Verificar vendor/ |
| `Class 'Slim\Factory\AppFactory' not found` | Vendor incompleto | Re-ejecutar composer install |
| `Permission denied` | Permisos incorrectos | chmod 644/755 |
| `Unexpected value in expression` | Error de sintaxis en PHP | Revisar index.php |

---

## 6. Criterios de éxito

### 6.1 Criterios obligatorios

| Criterio | Estado esperado | Verificación |
|----------|-----------------|--------------|
| **HTTP Status** | 200 OK | `curl -I` |
| **Contenido** | "Hola mundo" visible | `curl` |
| **Tiempo de respuesta** | < 2 segundos | `curl -w "%{time_total}"` |
| **Errores en logs** | Ninguno | Revisión de logs |
| **Permisos** | Correctos (644/755) | `ls -la` |

### 6.2 Criterios opcionales (recomendados)

| Criterio | Estado esperado | Verificación |
|----------|-----------------|--------------|
| **HTTPS** | Redirección automática | `curl -I http://...` |
| **Gzip** | Compresión activada | `curl -I -H "Accept-Encoding: gzip"` |
| **Cache headers** | Headers de cache presentes | `curl -I` |

---

## 7. Diagnóstico de errores

### 7.1 Error 404 Not Found

**Causas probables:**
- `.htaccess` faltante o incorrecto
- Ruta incorrecta
- `public/index.php` no encontrado

**Solución:**
```bash
# Verificar archivo
lftp -e "ls -la /home/beevivac/stg2.cofemlevante.es/public/; bye"

# Crear .htaccess si no existe
# public/.htaccess:
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^ index.php [QSA,L]
</IfModule>
```

### 7.2 Error 500 Internal Server Error

**Causas probables:**
- Error de sintaxis en PHP
- Autoload corrupto
- Vendor incompleto

**Solución:**
```bash
# Verificar logs
tail -50 /home/beevivac/logs/stg2.cofemlevante.es/error.log

# Regenerar autoload
composer dump-autoload --optimize

# Re-desplegar
./deploy.sh
```

### 7.3 Error 403 Forbidden

**Causas probables:**
- Permisos incorrectos
- Directorio sin index

**Solución:**
```bash
# Verificar permisos
lftp -e "ls -la /home/beevivac/stg2.cofemlevante.es/; bye"

# Corregir permisos (si el servidor lo permite)
lftp -e "chmod 644 public/index.php; chmod 755 public/; bye"
```

### 7.4 Timeout o conexión lenta

**Causas probables:**
- Servidor sobrecargado
- vendor/ demasiado grande
- Problemas de red

**Solución:**
```bash
# Verificar tamaño de vendor
du -sh vendor/

# Optimizar autoload
composer dump-autoload --optimize --classmap-authoritative

# Re-desplegar
./deploy.sh
```

---

## 8. Relación con otros documentos

### Documentos de los que depende

| Documento | Relación |
|-----------|----------|
| `40-Despliegue-Etapa01-Slim-FTP.md` | Procedimiento de despliegue |
| `30-Plan-Etapa01-Slim-FTP.md` | Criterios de aceptación |

### Documentos que dependen de este

| Documento | Relación |
|-----------|----------|
| `60-Pendientes-Etapa01-Slim-FTP.md` | Registro de incidencias |

### Jerarquía de documentos de Etapa 1

```
10-Decisiones-Etapa01-Slim-FTP.md
└── 20-Alcance-Etapa01-Slim-FTP.md
    └── 30-Plan-Etapa01-Slim-FTP.md
        ├── 40-Despliegue-Etapa01-Slim-FTP.md
        └── 50-Verificacion-Etapa01-Slim-FTP.md (este documento)
```

---

## 9. Referencias

### Documentos de este proyecto

| Documento | Ruta |
|-----------|------|
| Despliegue Etapa 1 | `40-Despliegue-Etapa01-Slim-FTP.md` |
| Plan Etapa 1 | `30-Plan-Etapa01-Slim-FTP.md` |
| Índice de implantación | `00-INDICE-Implantacion.md` |

### Documentación externa

| Recurso | URL |
|---------|-----|
| curl documentation | https://curl.se/docs/ |
| lftp documentation | https://lftp.yar.ru/ |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Creación del documento (descompuesto de Etapa01_Slim-Despliegue-FTP.md) | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
