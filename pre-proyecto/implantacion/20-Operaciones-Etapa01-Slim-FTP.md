# Operaciones de Implantación — Etapa 1: Slim + FTP

**Versión:** 2.0  
**Fecha:** 28 de abril de 2026  
**Estado:** ✅ Aprobado

---

## Índice de Contenido

1. [Propósito y alcance del documento](#1-propósito-y-alcance-del-documento)
2. [Preparación del despliegue](#2-preparación-del-despliegue)
3. [Despliegue mediante agente](#3-despliegue-mediante-agente)
4. [Verificación post-despliegue](#4-verificación-post-despliegue)
5. [Diagnóstico de errores](#5-diagnóstico-de-errores)
6. [Seguridad](#6-seguridad)
7. [Pendientes y seguimiento](#7-pendientes-y-seguimiento)
8. [Referencias](#8-referencias)

---

## 1. Propósito y alcance del documento

Procedimientos operativos de Etapa 1: despliegue (solo mediante agente), verificación, diagnóstico y seguimiento de pendientes.

Sustituye a: `40-Despliegue-Etapa01-Slim-FTP.md` v1.0, `50-Verificacion-Etapa01-Slim-FTP.md` v1.0, `60-Pendientes-Etapa01-Slim-FTP.md` v1.0  
Depende de: `10-Plan-Etapa01-Slim-FTP.md` (plan de trabajo)

---

## 2. Preparación del despliegue

### Pre-requisitos obligatorios

Antes de desplegar, verificar que las siguientes acciones están completadas (responsabilidad del equipo, ejecutar antes de Fase 1 del plan):

| # | Requisito | Verificación |
|---|-----------|--------------|
| 0.1 | Credenciales FTP disponibles | `echo $CONTRASENYA_FTP_WA` no vacío |
| 0.2 | Acceso FTP desde Codespace | `nc -zv ftp.bee-viva.es 21` → éxito |
| 0.3 | Acceso a logs del servidor | Ruta confirmada: `/home/beevivac/logs/stg2.cofemlevante.es/error.log` |

### Pre-requisitos de desarrollo

| Requisito | Verificación |
|-----------|--------------|
| Slim instalado | `composer show slim/slim` |
| Dependencias OK | `vendor/` existe |
| Front controller | `public/index.php` existe |
| `.htaccess` | `public/.htaccess` existe |
| `.env` configurado | Variables FTP_SERVER, FTP_USER, FTP_TARGET_PATH definidas |
| lftp disponible | `which lftp` |

### Preparación del paquete

```bash
composer install --no-dev --optimize-autoloader
du -sh vendor/   # Esperado: < 4 MB
```

### Archivos a desplegar

| Elemento | Incluir |
|----------|---------|
| `public/index.php` | ✅ |
| `public/.htaccess` | ✅ |
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

## 3. Despliegue mediante agente

El despliegue se realiza **exclusivamente mediante el agente `@ftp-deployer`**. No se usa ni crea `deploy.sh`.

### Implementación del agente

- **Archivo:** `.opencode/agents/ftp-deployer.md`
- **Especificación:** `pre-proyecto/agentica/ftp-deployer-agent-spec.md`
- **Modo:** `subagent`
- **Invocación:** `@ftp-deployer despliega la Web-App`

### Configuración del agente

Variables de entorno que el agente debe leer:

| Variable | Propósito | Valor |
|----------|-----------|-------|
| `FTP_SERVER` | Servidor FTP | `ftp.bee-viva.es` |
| `FTP_USER` | Usuario FTP | `ftp-wa@levantecofem.es` |
| `FTP_PASSWORD` | Contraseña FTP | Desde variable de entorno (`CONTRASENYA_FTP_WA`) |
| `FTP_TARGET_PATH` | Directorio target | `/home/beevivac/stg2.cofemlevante.es/` |
| `FTP_PORT` | Puerto | `21` |

### Flujo del agente

1. **Pre-validación:** Verifica directorio fuente, archivos esenciales y credenciales
2. **Preparación:** Ejecuta `composer install --no-dev --optimize-autoloader` si necesita
3. **Conexión FTP:** Conecta a `ftp.bee-viva.es:21` con FTPS explícito
4. **Transferencia:** `lftp mirror --reverse --delete ./ .` sobre `FTP_TARGET_PATH`
5. **Verificación:** Confirma archivos transferidos
6. **Informe:** Resumen estructurado con resultado

### Respuesta esperada

```
✅ Despliegue completado
📦 Origen:  raíz del repositorio (~3 MB)
🎯 Destino: /home/beevivac/stg2.cofemlevante.es/
✅ HTTP 200: https://stg2.cofemlevante.es/
```

---

## 4. Verificación post-despliegue

### Checklist inmediato

- [ ] `curl -I https://stg2.cofemlevante.es/` → HTTP 200
- [ ] `curl https://stg2.cofemlevante.es/` → "Hola mundo"
- [ ] `curl https://stg2.cofemlevante.es/hello` → "Hola mundo desde Slim"
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

## 5. Diagnóstico de errores

### Error 404

**Causas:** Ruta incorrecta, `.htaccess` faltante, front controller no encontrado.  
**Solución:** Verificar `public/.htaccess` y `public/index.php` existen en servidor.

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
nc -zv ftp.bee-viva.es 21
lftp -e "open ftp.bee-viva.es; user ftp-wa@levantecofem.es $CONTRASENYA_FTP_WA; ls; bye"
```

### Credenciales no encontradas

**Verificar:** La variable de entorno `CONTRASENYA_FTP_WA` está definida y `FTP_PASSWORD` la referencia.

---

## 6. Seguridad

| Práctica | Correcto | Incorrecto |
|----------|----------|------------|
| Almacenamiento | Variables de entorno / `.env` | Hardcodeadas en código |
| Transmisión | FTPS explícito (TLS) | FTP plano |
| Logs | Nunca mostrar contraseñas | `echo $CONTRASENYA_FTP_WA` |
| Comandos | Pasar como variable | Argumento visible en `ps` |

Permisos post-despliegue:
```bash
lftp -e "ls -la /home/beevivac/stg2.cofemlevante.es/; bye"
# Archivos: 644, Directorios: 755
```

---

## 7. Pendientes y seguimiento

### Acciones del equipo

| # | Acción | Prioridad | Responsable | Estado |
|---|--------|-----------|-------------|--------|
| 1 | Verificar credenciales FTP | Alta | Equipo | ⏳ Pendiente |
| 2 | Confirmar acceso FTP desde Codespace | Alta | Equipo | ⏳ Pendiente |
| 3 | Proporcionar acceso a logs del servidor | Media | Equipo | ⏳ Pendiente |
| 4 | Aprobar documentación de implantación | Alta | Equipo | ⏳ Pendiente |

### Acciones del desarrollador

| # | Acción | Prioridad | Estado |
|---|--------|-----------|--------|
| 1 | Verificar PHP `php -v` | Alta | ⏳ Pendiente |
| 2 | Verificar Composer `composer --version` | Alta | ⏳ Pendiente |
| 3 | Instalar lftp | Alta | ⏳ Pendiente |
| 4 | Primer despliegue | Alta | ⏳ Pendiente |

### Decisiones pendientes

| Decisión | Resolución |
|----------|------------|
| ~~¿Crear deploy.sh o solo agente?~~ | ✅ **Resuelto:** Solo agente, no crear `deploy.sh` |
| ~~¿.htaccess para reescritura?~~ | ✅ **Resuelto:** Sí, incluir `public/.htaccess` |
| ~~¿.env o GitHub Secrets?~~ | ✅ **Resuelto:** `.env` para configuración |
| ~~¿Incluir app/ y config/ en primer despliegue?~~ | ✅ **Resuelto:** Sí, estructura completa base |

### Seguimiento de Etapa 2

**Dependencias para iniciar Etapa 2:**
- [ ] Slim integrado ✅
- [ ] Despliegue FTP validado ✅
- [ ] Documentación aprobada
- [ ] Dependencias: `monolog/monolog`, `illuminate/database`, `guzzlehttp/guzzle`, `slim/csrf`

---

## 8. Referencias

| Documento | Ruta |
|-----------|------|
| Decisiones + índice | `00-INDICE-Implantacion.md` |
| Plan Etapa 1 | `10-Plan-Etapa01-Slim-FTP.md` |
| Agente ftp-deployer | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` |
| lftp docs | https://lftp.yar.ru/ |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 2.0 | 28 abr 2026 | Consolidación de despliegue + verificación + pendientes. Sustituye a 40-Despliegue v1.0, 50-Verificacion v1.0 y 60-Pendientes v1.0 | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
