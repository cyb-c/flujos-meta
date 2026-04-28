# Operaciones de Implantación — Etapa 1: Slim + FTP

**Versión:** 3.0  
**Fecha:** 28 de abril de 2026  
**Estado:** ✅ Aprobado

---

## Índice Interno

1. [Propósito](#1-propósito)
2. [Pre-requisitos obligatorios](#2-pre-requisitos-obligatorios)
3. [Preparación del paquete](#3-preparación-del-paquete)
4. [Despliegue mediante agente](#4-despliegue-mediante-agente)
5. [Verificación post-despliegue](#5-verificación-post-despliegue)
6. [Diagnóstico de errores](#6-diagnóstico-de-errores)
7. [Seguridad](#7-seguridad)
8. [Pendientes y seguimiento](#8-pendientes-y-seguimiento)
9. [Referencias](#9-referencias)

---

## 1. Propósito

Procedimientos operativos de Etapa 1: despliegue (solo mediante agente), verificación, diagnóstico y seguimiento de pendientes.

Sustituye a: `40-Despliegue-Etapa01-Slim-FTP.md` v1.0, `50-Verificacion-Etapa01-Slim-FTP.md` v1.0, `60-Pendientes-Etapa01-Slim-FTP.md` v1.0  
Depende de: `10-Plan-Etapa01-Slim-FTP.md` (plan de trabajo), `00-INDICE-Implantacion.md` (decisiones), `.gobernanza/inventario_recursos.md` (valores de configuración)

---

## 2. Pre-requisitos obligatorios

Estas acciones son responsabilidad del equipo. Deben completarse antes de la Fase 1 del plan. Si alguna no puede completarse, la Etapa 1 no debe iniciarse.

| # | Requisito | Verificación |
|---|-----------|--------------|
| 0.1 | Credenciales FTP disponibles | `echo $CONTRASENYA_FTP_WA` no vacío |
| 0.2 | Acceso FTP desde Codespace | `nc -zv` según servidor en `inventario_recursos.md` → éxito |
| 0.3 | Acceso a logs del servidor | Ruta confirmada según `inventario_recursos.md` |

### Pre-requisitos de desarrollo

| Requisito | Verificación |
|-----------|--------------|
| Slim instalado | `composer show slim/slim` |
| Dependencias OK | `vendor/` existe |
| Front controller | `public/index.php` existe |
| `.htaccess` raíz | `.htaccess` existe (redirección a `public/`) |
| `.htaccess` public | `public/.htaccess` existe |
| `.env` configurado | Variables según `inventario_recursos.md` y `.env.example` |
| lftp disponible | `which lftp` |

---

## 3. Preparación del paquete

```bash
composer install --no-dev --optimize-autoloader
du -sh vendor/   # Esperado: < 4 MB
```

### Archivos a desplegar

| Elemento | Incluir |
|----------|---------|
| `public/index.php` | ✅ |
| `public/.htaccess` | ✅ |
| `.htaccess` (raíz) | ✅ |
| `vendor/` | ✅ |
| `composer.json` | ✅ |
| `composer.lock` | ✅ |
| `app/` | ✅ |
| `config/` | ✅ |
| `.env` | ✅ |
| `.git/` | ❌ |
| `.gitignore` | ❌ |
| `pre-proyecto/` | ❌ |

---

## 4. Despliegue mediante agente

El despliegue se realiza **exclusivamente mediante el agente `@ftp-deployer`**. No se usa ni crea `deploy.sh`.

### Implementación del agente

| Campo | Valor |
|-------|-------|
| **Archivo** | `.opencode/agents/ftp-deployer.md` |
| **Especificación** | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` |
| **Modo** | `subagent` |
| **Invocación** | `@ftp-deployer despliega la Web-App` |

### Configuración del agente

Las variables de entorno que el agente lee se definen en `inventario_recursos.md` (secciones Secrets para Despliegue y Variables de Entorno). El agente:

1. Exporta `LFTP_PASSWORD` desde la variable de contraseña del inventario
2. Conecta a `FTP_SERVER:FTP_PORT` con FTPS explícito
3. Configura `set ftp:ssl-force on` y `set ftp:ssl-protect-data on` para TLS

### Flujo del agente

1. **Pre-validación:** Verifica directorio fuente (raíz), archivos esenciales y credenciales
2. **Verificar cliente:** Comprueba lftp; si no, lo instala
3. **Preparar paquete:** Ejecuta `composer install --no-dev --optimize-autoloader`
4. **Conectar FTP:** Exporta `LFTP_PASSWORD`, conecta con FTPS explícito + SSL
5. **Transferir:** `lftp mirror --reverse --delete ./ .` sobre `FTP_TARGET_PATH`
6. **Verificar:** Confirma archivos transferidos
7. **Informar:** Resumen estructurado con resultado

### Respuesta esperada

```
✅ Despliegue completado
📦 Origen:  raíz del repositorio (~3 MB)
🎯 Destino: (según inventario_recursos.md)
✅ HTTP 200: (según inventario_recursos.md)
```

---

## 5. Verificación post-despliegue

### Checklist inmediato

- [ ] `curl -I` según URL de `inventario_recursos.md` → HTTP 200
- [ ] `curl` según URL → "Hola mundo"
- [ ] `curl` según URL + `/hello` → "Hola mundo desde Slim"
- [ ] Tiempo de respuesta < 2s

### Checklist de archivos (24h)

- [ ] Permisos correctos (644 archivos, 755 directorios)
- [ ] `vendor/` completo
- [ ] `autoload.php` funciona

### Comandos de verificación

```bash
# HTTP
curl -I https://stg2.cofemlevante.es/
curl https://stg2.cofemlevante.es/
curl -w "%{time_total}" -o /dev/null -s https://stg2.cofemlevante.es/
curl https://stg2.cofemlevante.es/hello

# Archivos (vía FTP)
lftp -e "ls -la /home/beevivac/stg2.cofemlevante.es/; bye"
```

### Criterios de éxito

| Criterio | Esperado |
|----------|----------|
| HTTP Status | 200 OK |
| Contenido | "Hola mundo" |
| Tiempo | < 2s |
| Errores logs | Ninguno |
| Permisos | 644/755 |

---

## 6. Diagnóstico de errores

### Error 404

**Causas:** Ruta incorrecta, `.htaccess` faltante, front controller no encontrado.  
**Solución:** Verificar `.htaccess` (raíz y `public/`) y `public/index.php` existen en servidor.

### Error 500

**Causas:** Error de sintaxis PHP, vendor incompleto, autoload corrupto.  
**Solución:**
```bash
composer dump-autoload --optimize
# Re-desplegar con @ftp-deployer
```

### Error 403

**Causas:** Permisos incorrectos.  
**Solución:** Verificar con `ls -la`. Archivos 644, directorios 755.

### Conexión FTP rechazada

**Verificar:**
```bash
nc -zv ${FTP_SERVER} ${FTP_PORT}
lftp -e "set ftp:ssl-force on; set ftp:ssl-protect-data on; open -u ${FTP_USER},${FTP_PASSWORD} ${FTP_SERVER}; ls; bye"
```

### Credenciales no encontradas

**Verificar:** La variable definida en `inventario_recursos.md` está disponible y no vacía.

---

## 7. Seguridad

| Práctica | Correcto | Incorrecto |
|----------|----------|------------|
| Almacenamiento | Variables de entorno / `.env` (NO versionado) | Hardcodeadas en código |
| Transmisión | FTPS explícito con `set ftp:ssl-force on` | FTP plano |
| Logs | Nunca mostrar contraseñas | `echo $CONTRASENYA_FTP_WA` |
| Comandos | Variable de entorno (`LFTP_PASSWORD`) | Argumento visible en `ps` |

Permisos post-despliegue:
```bash
# Archivos: 644, Directorios: 755
```

---

## 8. Pendientes y seguimiento

### Acciones del equipo

| # | Acción | Prioridad | Responsable | Estado |
|---|--------|-----------|-------------|--------|
| 1 | Verificar credenciales FTP según inventario | Alta | Equipo | ⏳ Pendiente |
| 2 | Confirmar acceso FTP desde Codespace | Alta | Equipo | ⏳ Pendiente |
| 3 | Proporcionar acceso a logs del servidor | Media | Equipo | ⏳ Pendiente |
| 4 | Aprobar documentación de implantación v3.0 | Alta | Equipo | ⏳ Pendiente |

### Acciones del desarrollador

| # | Acción | Prioridad | Estado |
|---|--------|-----------|--------|
| 1 | Verificar PHP `php -v` | Alta | ⏳ Pendiente |
| 2 | Verificar Composer `composer --version` | Alta | ⏳ Pendiente |
| 3 | Instalar lftp | Alta | ⏳ Pendiente |
| 4 | Primer despliegue | Alta | ⏳ Pendiente |

### Decisiones resueltas

| Decisión | Resolución |
|----------|------------|
| ~~¿Crear deploy.sh o solo agente?~~ | ✅ Solo agente, no crear `deploy.sh` |
| ~~¿.htaccess para reescritura?~~ | ✅ Sí, raíz + `public/` |
| ~~¿.env o GitHub Secrets?~~ | ✅ `.env` para configuración |
| ~~¿Incluir app/ y config/ en primer despliegue?~~ | ✅ Sí, estructura completa base |
| ~~¿Subdirectorio fijo?~~ | ✅ No, despliegue directo sin `wa-slim/` |
| ~~¿Ruta de skill correcta?~~ | ✅ Corregida a `.opencode/skills/context7/SKILL.md` |
| ~~¿Front controller sin middlewares?~~ | ✅ Corregido con `addRoutingMiddleware()` y `addErrorMiddleware()` |

### Seguimiento de Etapa 2

**Dependencias para iniciar Etapa 2:**
- [ ] Slim integrado ✅
- [ ] Despliegue FTP validado
- [ ] Documentación aprobada
- [ ] Dependencias: `monolog/monolog`, `illuminate/database`, `guzzlehttp/guzzle`, `slim/csrf`

---

## 9. Referencias

| Documento | Ruta |
|-----------|------|
| Decisiones e índice | `00-INDICE-Implantacion.md` |
| Plan Etapa 1 | `10-Plan-Etapa01-Slim-FTP.md` |
| Inventario de recursos | `.gobernanza/inventario_recursos.md` |
| Info. servidor WA | `wa-server-info-2026-04-28-101933.json` |
| Agente ftp-deployer | `.opencode/agents/ftp-deployer.md` |
| Especificación agente | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` |
| lftp docs | https://lftp.yar.ru/ |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 3.0 | 28 abr 2026 | Adición de configuración SSL explícita para lftp. Eliminación de valores hardcodeados → referencias a inventario. Corrección de lista de archivos a desplegar (agregado `.htaccess` raíz). Actualización de agentes a rutas v2.0. Adición de decisiones resueltas. | OpenCode |
| 2.0 | 28 abr 2026 | Consolidación de despliegue + verificación + pendientes | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
