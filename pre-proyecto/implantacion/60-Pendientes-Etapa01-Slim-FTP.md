# Seguimiento de Pendientes — Etapa 1: Slim + FTP

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Estado:** Pendiente de aprobación

---

## Índice de Contenido

1. [Propósito de este documento](#1-propósito-de-este-documento)
2. [Acciones pendientes del equipo](#2-acciones-pendientes-del-equipo)
3. [Acciones pendientes del desarrollador](#3-acciones-pendientes-del-desarrollador)
4. [Incidencias de despliegue](#4-incidencias-de-despliegue)
5. [Decisiones pendientes](#5-decisiones-pendientes)
6. [Seguimiento de Etapa 2](#6-seguimiento-de-etapa-2)
7. [Relación con otros documentos](#7-relación-con-otros-documentos)
8. [Referencias](#8-referencias)

---

## 1. Propósito de este documento

Este documento registra las **acciones pendientes, incidencias y decisiones** de Etapa 1, permitiendo el seguimiento y la asignación de responsables.

### Contexto

Este documento se deriva de:
- `30-Plan-Etapa01-Slim-FTP.md` — Plan de trabajo
- `50-Verificacion-Etapa01-Slim-FTP.md` — Verificación post-despliegue

---

## 2. Acciones pendientes del equipo

### 2.1 Pendientes de alta prioridad

| # | Acción | Prioridad | Responsable | Estado | Fecha límite |
|---|--------|-----------|-------------|--------|--------------|
| 2.1.1 | Confirmar URL pública definitiva del dominio WA | Alta | Equipo | ⏳ Pendiente | Por definir |
| 2.1.2 | Verificar credenciales FTP en GitHub Secrets | Alta | Equipo | ⏳ Pendiente | Por definir |
| 2.1.3 | Confirmar acceso FTP desde Codespace | Alta | Equipo | ⏳ Pendiente | Por definir |

### 2.2 Pendientes de media prioridad

| # | Acción | Prioridad | Responsable | Estado | Fecha límite |
|---|--------|-----------|-------------|--------|--------------|
| 2.2.1 | Proporcionar acceso a logs de error del servidor | Media | Equipo | ⏳ Pendiente | Por definir |
| 2.2.2 | Confirmar si hay .htaccess existente en directorio WA | Media | Equipo | ⏳ Pendiente | Por definir |
| 2.2.3 | Definir estructura de URLs definitiva | Media | Equipo | ⏳ Pendiente | Por definir |

### 2.3 Descripción de acciones

#### 2.1.1 Confirmar URL pública definitiva del dominio WA

**Descripción:** Confirmar cuál es la URL pública accesible para el dominio `stg2.cofemlevante.es`.

**Opciones:**
- `https://stg2.cofemlevante.es/`
- `https://levantecofem.es/staging/`
- Otra

**Impacto:** Determina la URL de verificación y documentación.

#### 2.1.2 Verificar credenciales FTP en GitHub Secrets

**Descripción:** Confirmar que las credenciales FTP están configuradas correctamente en GitHub Secrets del repositorio.

**Secrets requeridos:**
- `CONTRASENYA_FTP_WA` — Contraseña para `ftp-wa@levantecofem.es`

**Verificación:** El equipo debe confirmar que los secrets existen y son correctos.

#### 2.1.3 Confirmar acceso FTP desde Codespace

**Descripción:** Verificar que el Codespace puede conectar al servidor FTP sin bloqueos de firewall.

**Test:**
```bash
nc -zv ftp.bee-viva.es 21
```

---

## 3. Acciones pendientes del desarrollador

### 3.1 Pendientes de desarrollo

| # | Acción | Prioridad | Responsable | Estado | Fecha |
|---|--------|-----------|-------------|--------|-------|
| 3.1.1 | Verificar PHP en Codespace (`php -v`) | Alta | Desarrollador | ⏳ Pendiente | — |
| 3.1.2 | Verificar Composer en Codespace (`composer --version`) | Alta | Desarrollador | ⏳ Pendiente | — |
| 3.1.3 | Instalar lftp si no disponible | Alta | Desarrollador | ⏳ Pendiente | — |
| 3.1.4 | Ejecutar primer despliegue de prueba | Alta | Desarrollador | ⏳ Pendiente | — |
| 3.1.5 | Documentar resultado del despliegue | Media | Desarrollador | ⏳ Pendiente | — |

---

## 4. Incidencias de despliegue

### 4.1 Registro de incidencias

| # | Fecha | Incidencia | Severidad | Estado | Resolución |
|---|-------|------------|-----------|--------|------------|
| — | — | Sin incidencias registradas | — | — | — |

### 4.2 Plantilla para nuevas incidencias

```markdown
#### Incidencia #[número]

**Fecha:** YYYY-MM-DD  
**Descripción:** [Describir el problema]  
**Severidad:** [Alta/Media/Baja]  
**Estado:** [Abierta/En resolución/Resuelta]  
**Resolución:** [Describir cómo se resolvió]
```

---

## 5. Decisiones pendientes

### 5.1 Decisiones técnicas

| # | Decisión | Impacto | Estado | Fecha resolución |
|---|----------|---------|--------|------------------|
| 5.1.1 | ¿Crear script deploy.sh o solo usar agente? | Procedimiento de despliegue | ⏳ Pendiente | — |
| 5.1.2 | ¿Añadir .htaccess para reescritura de URLs? | Configuración web | ⏳ Pendiente | — |

### 5.2 Decisiones de configuración

| # | Decisión | Impacto | Estado | Fecha resolución |
|---|----------|---------|--------|------------------|
| 5.2.1 | ¿Definir variables de entorno en .env o GitHub Secrets? | Gestión de configuración | ⏳ Pendiente | — |
| 5.2.2 | ¿Incluir directorios app/ y config/ en primer despliegue? | Alcance del despliegue | ⏳ Pendiente | — |

---

## 6. Seguimiento de Etapa 2

### 6.1 Dependencias para Etapa 2

Las siguientes dependencias deben completarse antes de iniciar Etapa 2:

| Dependencia | Estado en Etapa 1 | Requiere para Etapa 2 |
|-------------|-------------------|----------------------|
| Slim integrado | ⏳ Pendiente | ✅ Requerido |
| Despliegue FTP validado | ⏳ Pendiente | ✅ Requerido |
| Documentación aprobada | ⏳ Pendiente | ✅ Requerido |
| `monolog/monolog` | ❌ Fuera de alcance | ✅ Requerido |
| `illuminate/database` | ❌ Fuera de alcance | ✅ Requerido |
| `guzzlehttp/guzzle` | ❌ Fuera de alcance | ✅ Requerido |
| `slim/csrf` | ❌ Fuera de alcance | ✅ Requerido |

### 6.2 Criterios para iniciar Etapa 2

- [ ] Todos los criterios de aceptación de Etapa 1 cumplidos
- [ ] Documentación de Etapa 1 aprobada
- [ ] Equipo confirma disponibilidad para Etapa 2
- [ ] Dependencias de Etapa 2 identificadas y presupuestadas

---

## 7. Relación con otros documentos

### Documentos de los que depende

| Documento | Relación |
|-----------|----------|
| `30-Plan-Etapa01-Slim-FTP.md` | Plan de trabajo con criterios de aceptación |
| `50-Verificacion-Etapa01-Slim-FTP.md` | Verificación que puede generar incidencias |

### Jerarquía de documentos de Etapa 1

```
10-Decisiones-Etapa01-Slim-FTP.md
└── 20-Alcance-Etapa01-Slim-FTP.md
    └── 30-Plan-Etapa01-Slim-FTP.md
        ├── 40-Despliegue-Etapa01-Slim-FTP.md
        ├── 50-Verificacion-Etapa01-Slim-FTP.md
        └── 60-Pendientes-Etapa01-Slim-FTP.md (este documento)
```

---

## 8. Referencias

### Documentos de este proyecto

| Documento | Ruta |
|-----------|------|
| Plan Etapa 1 | `30-Plan-Etapa01-Slim-FTP.md` |
| Verificación Etapa 1 | `50-Verificacion-Etapa01-Slim-FTP.md` |
| Índice de implantación | `00-INDICE-Implantacion.md` |

---

## Historial de cambios

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Creación del documento (descompuesto de Etapa01_Slim-Despliegue-FTP.md) | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
