# Índice y Decisiones de Implantación

**Versión:** 3.0  
**Fecha:** 28 de abril de 2026  
**Estado:** ✅ Aprobado

---

## Índice Interno

1. [Propósito](#1-propósito)
2. [Estructura documental](#2-estructura-documental)
3. [Método de despliegue](#3-método-de-despliegue)
4. [No Composer en servidor](#4-no-composer-en-servidor)
5. [Desarrollo en Codespace](#5-desarrollo-en-codespace)
6. [No comandos en servidor](#6-no-comandos-en-servidor)
7. [Arquitectura WA / WordPress](#7-arquitectura-wa--wordpress)
8. [Slim en raíz del repositorio](#8-slim-en-raíz-del-repositorio)
9. [Rutas de despliegue](#9-rutas-de-despliegue)
10. [URL pública](#10-url-pública)
11. [Agente desplegador](#11-agente-desplegador)
12. [Reescritura de URLs](#12-reescritura-de-urls)
13. [Variables de entorno](#13-variables-de-entorno)
14. [Framework Slim 4.x](#14-framework-slim-4x)
15. [Repositorio clonable](#15-repositorio-clonable)
16. [Dependencias futuras](#16-dependencias-futuras)
17. [Elementos fuera de alcance](#17-elementos-fuera-de-alcance)
18. [Referencias](#18-referencias)

---

## 1. Propósito

Documento único que consolida:
- **Índice** de toda la documentación de implantación
- **Todas las decisiones confirmadas** (generales + Etapa 1)

Sustituye a: `00-decisiones-generales-implantacion.md` v1.0, `10-Decisiones-Etapa01-Slim-FTP.md` v1.0

---

## 2. Estructura documental

| Documento | Finalidad | Dependencias | Estado |
|-----------|-----------|--------------|--------|
| **`00-INDICE-Implantacion.md`** | Índice + decisiones confirmadas (este documento) | — | ✅ Activo |
| **`10-Plan-Etapa01-Slim-FTP.md`** | Plan de trabajo: objetivo, alcance, actividades, criterios | `00-INDICE-Implantacion.md` | ✅ Activo |
| **`20-Operaciones-Etapa01-Slim-FTP.md`** | Despliegue, verificación, diagnóstico, pendientes | `10-Plan-Etapa01-Slim-FTP.md` | ✅ Activo |
| `10-Diagnostico-Revision-Implantacion.md` | Diagnóstico de revisión | — | ℹ️ Referencia |
| `20-Verificacion-Tecnica-Context7.md` | Verificación técnica con Context7 | — | ℹ️ Referencia |
| `wa-server-info-2026-04-28-101933.json` | Datos técnicos del servidor | — | ℹ️ Referencia |
| `wp-Información de salud del sitio.txt` | Salud de WordPress | — | ℹ️ Referencia |

### Archivos archivados

Los documentos v1.0 originales se movieron a `pre-proyecto/_archivo/implantacion-legado/`:
`Etapa01_Slim-Despliegue-FTP.md`, `00-decisiones-generales-implantacion.md`, `10-Decisiones-Etapa01-Slim-FTP.md`, `20-Alcance-Etapa01-Slim-FTP.md`, `30-Plan-Etapa01-Slim-FTP.md`, `40-Despliegue-Etapa01-Slim-FTP.md`, `50-Verificacion-Etapa01-Slim-FTP.md`, `60-Pendientes-Etapa01-Slim-FTP.md`

### Jerarquía de lectura

```
00-INDICE-Implantacion.md (decisiones)
│
└── 10-Plan-Etapa01-Slim-FTP.md (plan)
    │
    └── 20-Operaciones-Etapa01-Slim-FTP.md (ejecución)
```

Orden recomendado: `00-INDICE` → `10-Plan` → `20-Operaciones`.

---

## 3. Método de despliegue

**Decisión:** FTP/FTPS explícito (FTP sobre TLS).

**Justificación:** El hosting compartido no proporciona acceso SSH/SFTP.

Los valores de configuración (servidor, puerto, usuario, ruta target) se registran en `inventario_recursos.md` — consultar antes de desplegar.

---

## 4. No Composer en servidor

**Decisión:** No se ejecutará Composer en el servidor de producción.

**Implicaciones:**
- `vendor/` se genera localmente y se sube completo
- `composer install` se ejecuta solo en Codespace
- `composer.lock` se incluye en el despliegue para trazabilidad

---

## 5. Desarrollo en Codespace

**Decisión:** Todo el desarrollo se realizará en el GitHub Codespace/workspace.

| Herramienta | Versión mínima | Propósito |
|-------------|----------------|-----------|
| PHP | 8.1+ | Ejecución de Slim |
| Composer | 2.0+ | Gestión de dependencias |
| Git | 2.0+ | Control de versiones |
| lftp | Cualquiera | Despliegue por FTP |

---

## 6. No comandos en servidor

**Decisión:** No se ejecutará ningún comando en el servidor remoto. El hosting compartido no proporciona SSH, solo transferencia de archivos.

---

## 7. Arquitectura WA / WordPress

**Decisión:** La Web-App será una aplicación PHP independiente de WordPress, usando Slim sin interferir con WP. La comunicación WA↔WP será vía endpoint REST personalizado (etapa 2+) y acceso directo a BD de WP.

Los directorios exactos de WA y WP se registran en `inventario_recursos.md`.

---

## 8. Slim en raíz del repositorio

**Decisión:** Slim se integra como framework base real del desarrollo en la **raíz del repositorio**. `pre-proyecto/` es solo para documentación.

```
raíz/
├── app/Controllers/           # Controladores
├── app/Services/              # Servicios
├── app/Middleware/            # Middleware
├── app/Config/                # Configuración
├── public/index.php           # Front controller
├── public/.htaccess           # Reescritura URLs
├── vendor/                    # Dependencias
├── config/app.php             # Config. app
├── config/database.php        # Config. BD
├── config/routes.php          # Rutas
├── composer.json
├── composer.lock
├── .env                       # NO versionado
├── .env.example               # Versionado
├── .htaccess                  # Redirección raíz → public/
└── pre-proyecto/              # SOLO documentación
```

**Estructura INCORRECTA (no usar):** Código dentro de `pre-proyecto/wa-slim/` o cualquier subdirectorio fijo.

---

## 9. Rutas de despliegue

**Decisión:** El despliegue se realiza directamente en el directorio base del dominio WA, sin crear subdirectorios fijos. La configuración debe permitir cambiar rutas sin alterar la lógica del proyecto.

Los valores específicos (dominio, directorio base) se registran en `inventario_recursos.md`.

---

## 10. URL pública

**Decisión:** La URL pública definitiva para la Web-App se define en `inventario_recursos.md`. No se usará ninguna variante con subdirectorios.

---

## 11. Agente desplegador

**Decisión:** El despliegue se realiza **exclusivamente mediante el agente `@ftp-deployer`** (`.opencode/agents/ftp-deployer.md`). No se crea ni usa `deploy.sh`. Queda prohibido CI/CD, FTP manual o cualquier otro método.

**Invocación:**
```
@ftp-deployer despliega la Web-App
```

---

## 12. Reescritura de URLs

**Decisión:** Sí usar `.htaccess` para reescritura de URLs. Se emplean dos niveles:
1. **Raíz** (`.htaccess`): Redirige todo el tráfico a `public/`
2. **`public/.htaccess`**: Redirige a `index.php` para Slim

Contenido y especificaciones en `10-Plan-Etapa01-Slim-FTP.md` §6.

---

## 13. Variables de entorno

**Decisión:** Usar archivo `.env` (no versionado) para configuración, con `.env.example` (versionado) como plantilla. Las credenciales sensibles se pasan exclusivamente por variables de entorno del sistema, nunca en `.env` versionado.

La lista completa de variables se registra en `inventario_recursos.md`.

---

## 14. Framework Slim 4.x

**Decisión:** Slim PHP 4.x como framework base. Dependencias y justificación técnica en `10-Plan-Etapa01-Slim-FTP.md` §6.

No se crea agente o skill específico para Slim. La skill `context7` (`.opencode/skills/context7/SKILL.md`) permite consultar documentación actualizada.

---

## 15. Repositorio clonable

**Decisión:** El repositorio debe servir como base clonable para otros proyectos futuros.

**Principios:**
- **Reutilizable:** Componentes genéricos, no específicos de este proyecto
- **Configurable:** Rutas, credenciales, opciones en `.env` e `inventario_recursos.md`
- **No acoplado:** Sin dependencias a rutas concretas del hosting actual
- **Documentado:** Instrucciones claras para clonar y adaptar

---

## 16. Dependencias futuras

| Dependencia | Propósito | Etapa |
|-------------|-----------|-------|
| `monolog/monolog` | Logging estructurado | 2 |
| `illuminate/database` | Eloquent ORM (acceso BD WordPress) | 2 |
| `guzzlehttp/guzzle` | Cliente HTTP (llamadas a APIs) | 2 |
| `slim/csrf` | Protección CSRF/Nonces | 2 |

Se incluirán cuando Slim esté integrado, el despliegue validado y exista necesidad real.

---

## 17. Elementos fuera de alcance

| Elemento | Etapa prevista |
|----------|----------------|
| Autenticación contra WordPress | 2+ |
| Logging estructurado (Monolog) | 2+ |
| Eloquent ORM (acceso a BD) | 2+ |
| Cliente HTTP (Guzzle) | 2+ |
| Protección CSRF | 2+ |
| Endpoint WordPress de validación | 2+ |
| Subida de PDFs | 3+ |
| Tabla personalizada en WordPress | 3+ |
| Selección de proveedor de IA | 3+ |
| CRUD de proveedores de IA | 3+ |
| Formulario de revisión | 3+ |
| Mapeo de campos WooCommerce | 4+ |
| Integración con API WooCommerce | 4+ |

**Criterio:** Cualquier funcionalidad no necesaria para integrar Slim y validar el despliegue queda excluida de Etapa 1.

---

## 18. Referencias

| Documento | Ruta |
|-----------|------|
| Inventario de recursos | `.gobernanza/inventario_recursos.md` |
| Reglas de gobernanza | `.gobernanza/reglas_universales.md` |
| Plan Etapa 1 | `10-Plan-Etapa01-Slim-FTP.md` |
| Operaciones Etapa 1 | `20-Operaciones-Etapa01-Slim-FTP.md` |
| Diagnóstico | `10-Diagnostico-Revision-Implantacion.md` |
| Verificación técnica | `20-Verificacion-Tecnica-Context7.md` |
| Info. servidor WA | `wa-server-info-2026-04-28-101933.json` |
| Agente ftp-deployer | `.opencode/agents/ftp-deployer.md` |
| Especificación agente | `pre-proyecto/agentica/ftp-deployer-agent-spec.md` |
| Slim docs | https://www.slimframework.com/docs/v4/ |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 3.0 | 28 abr 2026 | Eliminación de datos hardcodeados → referencias a inventario. Eliminación de redundancias con 10-Plan y 20-Operaciones. Corrección de ruta de skill. | OpenCode |
| 2.0 | 28 abr 2026 | Consolidación: índice + todas las decisiones en un documento | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
