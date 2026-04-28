# Inventario de Recursos y Configuración

> **Finalidad:** Fuente única de verdad para recursos del proyecto.
> **Versión:** 1.2
> **Importante:** Este documento debe mantenerse actualizado. Consultar antes de iniciar cualquier acción relevante.
> **Restricción:** Solo puede contener información real, existente y verificada.

---

## Índice

1. [Reglas de Uso](#reglas-de-uso)
2. [Leyenda de Estado](#leyenda-de-estado)
3. [Resumen del Proyecto](#1-resumen-del-proyecto)
4. [Secrets para Despliegue](#2-secrets-para-despliegue)
5. [Secrets de Desarrollo Local](#3-secrets-de-desarrollo-local)
6. [Recursos del Proyecto](#4-recursos-del-proyecto)
7. [Configuración de Despliegue](#5-configuración-de-despliegue)
8. [Variables de Entorno por Servicio](#6-variables-de-entorno-por-servicio)
9. [Integraciones Externas](#7-integraciones-externas)
10. [Contratos entre Servicios](#8-contratos-entre-servicios)
11. [Stack Tecnológico](#9-stack-tecnológico)
12. [Archivos de Configuración](#10-archivos-de-configuración)
13. [Agentes del Proyecto](#11-agentes-del-proyecto)
14. [Notas de Mantenimiento](#notas-de-mantenimiento)

---

## Reglas de Uso

1. No inventar valores.
2. No incluir secretos ni credenciales en texto plano (solo nombres, nunca valores).
3. Consultar este documento antes de ejecutar trabajo con impacto operativo.
4. Para solicitar cambios, seguir el flujo de gobernanza del proyecto.
5. **Este inventario solo puede contener información real, existente y verificada.**
6. **No puede contener vacíos pendientes, hipótesis, suposiciones, deseos, pendientes ni elementos no confirmados.**
7. Si un recurso o variable no existe o no está verificado, no debe registrarse en este documento.

---

## Leyenda de Estado

| Símbolo | Significado |
|---------|-------------|
| ✅ | Existe y está referenciado correctamente en el repositorio |
| ⚠️ | Existe pero hay discrepancia con la configuración del repositorio |
| 🔲 | Declarado en configuración pero NO creado o configurado |
| 🚫 | Servicio o recurso no habilitado |
| 🗑️ | Existe pero sin referencia en el repositorio (huérfano) |

---

## 1. Resumen del Proyecto

| Campo | Valor |
|-------|-------|
| **Nombre del proyecto** | Web-App de Automatización WooCommerce |
| **Finalidad** | Automatización de flujos de WooCommerce mediante Web-App independiente con Slim PHP |
| **Repositorio** | flujos-meta (GitHub Codespace) |
| **Entorno de trabajo** | GitHub Codespace (Linux, PHP 8.1+, Composer 2.0+, Git 2.0+, lftp) |
| **Lenguaje base** | PHP 8.1+ (servidor: 8.3.30) |
| **Stack tecnológico** | Slim 4.x, MariaDB 11.4.10, WooCommerce 10.4.4, LiteSpeed, WordPress 6.9.4 |
| **Entornos de despliegue** | Staging: stg2.cofemlevante.es |
| **Plataformas de deployment** | Hosting compartido con LiteSpeed, acceso FTP/FTPS |
| **Gestión de Secrets** | Variables de entorno del sistema (CONTRASENYA_FTP_WA) + .env (no versionado) |
| **Estructura del proyecto** | Código en raíz (Slim como framework base), pre-proyecto/ solo documentación |

---

## 2. Secrets para Despliegue

| Secret | Ubicación | Uso | Estado |
|--------|-----------|-----|--------|
| CONTRASENYA_FTP_WA | Variable de entorno del sistema (Codespace) | Contraseña FTP para usuario ftp-wa@levantecofem.es | ✅ |

> **Nota:** Los valores de secrets nunca se documentan en este archivo. Solo se registran los nombres.

---

## 3. Secrets de Desarrollo Local

### 3.1. Backend

| Variable | Uso | Sensible | Ejemplo | Estado |
|----------|-----|----------|---------|--------|
| FTP_SERVER | Servidor FTP para despliegue | No | ftp.bee-viva.es | ✅ |
| FTP_USER | Usuario FTP | No | ftp-wa@levantecofem.es | ✅ |
| FTP_PASSWORD | Contraseña FTP (vía CONTRASENYA_FTP_WA) | Sí | — | ✅ |
| FTP_TARGET_PATH | Directorio remoto de despliegue | No | /home/beevivac/stg2.cofemlevante.es/ | ✅ |
| FTP_PORT | Puerto FTP | No | 21 | ✅ |
| APP_ENV | Entorno de aplicación | No | development | ✅ |
| APP_DEBUG | Modo debug | No | true | ✅ |

### 3.2. Frontend

| Variable | Uso | Sensible | Ejemplo | Estado |
|----------|-----|----------|---------|--------|
| | | | | 🚫 |

> **Nota:** Frontend no aplica en Etapa 1. No hay variables de frontend expuestas.
> Usar archivos de plantilla de entorno (ej. `.env.example`) como plantillas versionadas sin valores reales. Los archivos de entorno local deben estar en `.gitignore`.

---

## 4. Recursos del Proyecto

### 4.1. Base de Datos

| Recurso | Proveedor | Ambiente | Connection String | Estado |
|---------|-----------|----------|-------------------|--------|
| WordPress DB | MariaDB 11.4.10 | Servidor (compartido) | No disponible (WP gestiona su BD) | ✅ |

**Esquema de Base de Datos:**
- Modelos: No hay base de datos propia en Etapa 1
- Migraciones: No aplica en Etapa 1
- Seed: No aplica en Etapa 1
- **Nota:** WordPress usa MariaDB 11.4.10 en el servidor. Extensiones disponibles: mysqli, pdo_mysql.

### 4.2. Plataforma de Despliegue

| Recurso | Valor | Estado |
|---------|-------|--------|
| **Proyecto** | Web-App WooCommerce | ✅ |
| **Plan** | Hosting compartido | ✅ |
| **Dominio** | stg2.cofemlevante.es | ✅ |
| **Servidor web** | LiteSpeed | ✅ |
| **Directorios remotos** | | |
| Directorio WA | /home/beevivac/stg2.cofemlevante.es/ | ✅ |
| Directorio WP | /home/beevivac/levantecofem_es | ✅ |
| Ruta logs WA | /home/beevivac/logs/stg2.cofemlevante.es/error.log | ✅ |

---

## 5. Configuración de Despliegue

| Campo | Valor |
|-------|-------|
| **Método primario** | FTP/FTPS explícito mediante agente @ftp-deployer |
| **Archivo de configuración** | .opencode/agents/ftp-deployer.md |
| **Autenticación** | Variables de entorno (CONTRASENYA_FTP_WA) |
| **Comando de build** | composer install --no-dev --optimize-autoloader |
| **Comando de start** | php -S localhost:8080 -t public (desarrollo) |

### 5.1. Variables de Entorno en Plataforma de Despliegue

| Variable | Tipo | Sensible | Ubicación | Estado |
|----------|------|----------|-----------|--------|
| FTP_SERVER | string | No | .env + entorno | ✅ |
| FTP_USER | string | No | .env + entorno | ✅ |
| FTP_PASSWORD | string | Sí | Variable entorno (CONTRASENYA_FTP_WA) | ✅ |
| FTP_TARGET_PATH | string | No | .env | ✅ |
| FTP_PORT | int | No | .env (default 21) | ✅ |
| APP_ENV | string | No | .env | ✅ |
| APP_DEBUG | bool | No | .env | ✅ |

---

## 6. Variables de Entorno por Servicio

### Backend

| Variable | Tipo | Sensible | Descripción | Estado |
|----------|------|----------|-------------|--------|
| FTP_SERVER | string | No | Servidor FTP para despliegue | ✅ |
| FTP_USER | string | No | Usuario FTP | ✅ |
| FTP_PASSWORD | string | Sí | Contraseña FTP (vía CONTRASENYA_FTP_WA) | ✅ |
| FTP_TARGET_PATH | string | No | Directorio remoto de despliegue | ✅ |
| FTP_PORT | int | No | Puerto FTP (21) | ✅ |
| APP_ENV | string | No | Entorno de aplicación (development/production) | ✅ |
| APP_DEBUG | bool | No | Modo debug (true en desarrollo) | ✅ |

### Frontend

| Variable | Tipo | Sensible | Descripción | Estado |
|----------|------|----------|-------------|--------|
| | | | | 🚫 |

> **Nota:** Frontend no aplica en Etapa 1. No hay variables de frontend expuestas.

---

## 7. Integraciones Externas

| Servicio | Propósito | Variables Requeridas | Estado |
|----------|-----------|---------------------|--------|
| WordPress (previsto Etapa 2+) | Endpoint REST personalizado | Por definir | 🚫 |
| WooCommerce (previsto Etapa 2+) | API de productos/pedidos | Por definir | 🚫 |

---

## 8. Contratos entre Servicios

| Servicio Origen | Servicio Destino | Endpoint | Método | Request | Response | Estado |
|-----------------|------------------|----------|--------|---------|----------|--------|
| | | | | | | 🔲 |

---

## 9. Stack Tecnológico

| Capa | Tecnología | Versión | Estado |
|------|------------|---------|--------|
| Servidor web | LiteSpeed | (servidor) | ✅ |
| PHP | PHP | 8.3.30 | ✅ |
| Framework | Slim | 4.x (^4.15) | 🔲 |
| PSR-7 | slim/psr7 | ^1.7 | 🔲 |
| Dotenv | vlucas/phpdotenv | ^5.6 | 🔲 |
| Base de datos | MariaDB | 11.4.10 | ✅ |
| CMS | WordPress | 6.9.4 | ✅ |
| E-commerce | WooCommerce | 10.4.4 | ✅ |
| Cliente FTP | lftp | (cualquiera) | ✅ |

---

## 10. Archivos de Configuración

| Archivo | Finalidad | Estado |
|---------|-----------|--------|
| composer.json | Dependencias y scripts | 🔲 |
| .env | Variables de entorno (NO versionado) | 🔲 |
| .env.example | Plantilla de variables (versionado) | ✅ |
| .htaccess (raíz) | Redirección raíz → public/ | 🔲 |
| public/.htaccess | Reescritura Slim | 🔲 |
| .gitignore | Exclusiones de versionado | ✅ |
| .opencode/agents/ftp-deployer.md | Configuración del agente desplegador | ✅ |
| opencode.json | Configuración OpenCode + agentes | ✅ |

---

## 11. Agentes del Proyecto

| Agente | Archivo | Propósito | Estado |
|--------|---------|-----------|--------|
| @ftp-deployer | .opencode/agents/ftp-deployer.md | Despliegue FTP con verificación | ✅ |
| @governance-updater | .opencode/agents/governance-updater.md | Actualización del inventario | ✅ |
| @governance-auditor | .opencode/agents/governance-auditor.md | Auditoría de consistencia | ✅ |

---

## Notas de Mantenimiento

1. **Actualización:** Este documento debe actualizarse cuando haya cambios en recursos, configuración, variables de entorno o secrets.
2. **Solicitud de cambios:** Los cambios deben solicitarse siguiendo el flujo de gobernanza del proyecto.
3. **Auditoría periódica:** La consistencia de este documento debe verificarse periódicamente.
4. **Aprobación:** Los cambios críticos requieren aprobación explícita antes de commit.
5. **Consulta previa:** Todo colaborador debe consultar este inventario antes de generar código que referencie recursos.
6. **No hardcoding:** Toda la información configurable debe quedar fuera del código.
7. **Solo información verificada:** Este inventario solo contiene información real, existente y verificada. No hay vacíos pendientes ni elementos hipotéticos.
8. **Registro de cambios:** Los cambios en este inventario se registran en `inventario_recursos_bitaacora.md`.

---

> **Nota:** Este documento es la fuente única de verdad. Mantener actualizado con cambios en infraestructura, variables y secrets.
