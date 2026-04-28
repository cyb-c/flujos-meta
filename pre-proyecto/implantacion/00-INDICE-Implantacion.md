# Índice de Documentación de Implantación

**Versión:** 1.0  
**Fecha:** 28 de abril de 2026  
**Estado:** En revisión

---

## Propósito de este índice

Este documento proporciona una visión general de la documentación de implantación del proyecto, indicando:
- Orden de lectura recomendado
- Finalidad de cada documento
- Dependencias jerárquicas entre documentos
- Estado de aprobación de cada documento

---

## Estructura documental de implantación

La documentación de implantación sigue una numeración de 10 en 10 para facilitar la inserción de nuevos documentos sin romper la numeración existente.

### Documentos de decisiones (serie 00-09)

| Documento | Finalidad | Dependencias | Estado |
|-----------|-----------|--------------|--------|
| [`00-decisiones-generales-implantacion.md`](00-decisiones-generales-implantacion.md) | Decisiones técnicas generales de implantación aplicables a todo el proyecto | `02-Comparativa-Frameworks-PHP.md`, `wa-server-info-2026-04-28-101933.json` | ✅ Aprobado |
| [`10-Decisiones-Etapa01-Slim-FTP.md`](10-Decisiones-Etapa01-Slim-FTP.md) | Decisiones específicas de Etapa 1: integración de Slim y despliegue FTP | `00-decisiones-generales-implantacion.md` | ⏳ Pendiente de aprobación |

### Documentos de alcance (serie 10-19)

| Documento | Finalidad | Dependencias | Estado |
|-----------|-----------|--------------|--------|
| [`20-Alcance-Etapa01-Slim-FTP.md`](20-Alcance-Etapa01-Slim-FTP.md) | Alcance incluido y excluido de Etapa 1 | `10-Decisiones-Etapa01-Slim-FTP.md` | ⏳ Pendiente de aprobación |

### Documentos de planificación (serie 20-29)

| Documento | Finalidad | Dependencias | Estado |
|-----------|-----------|--------------|--------|
| [`30-Plan-Etapa01-Slim-FTP.md`](30-Plan-Etapa01-Slim-FTP.md) | Plan detallado de trabajo para Etapa 1 | `10-Decisiones-Etapa01-Slim-FTP.md`, `20-Alcance-Etapa01-Slim-FTP.md` | ⏳ Pendiente de aprobación |

### Documentos operativos (serie 30-49)

| Documento | Finalidad | Dependencias | Estado |
|-----------|-----------|--------------|--------|
| [`40-Despliegue-Etapa01-Slim-FTP.md`](40-Despliegue-Etapa01-Slim-FTP.md) | Procedimiento de despliegue FTP mediante agente | `30-Plan-Etapa01-Slim-FTP.md` | ⏳ Pendiente de aprobación |

### Documentos de verificación (serie 50-59)

| Documento | Finalidad | Dependencias | Estado |
|-----------|-----------|--------------|--------|
| [`50-Verificacion-Etapa01-Slim-FTP.md`](50-Verificacion-Etapa01-Slim-FTP.md) | Procedimiento de verificación post-despliegue | `40-Despliegue-Etapa01-Slim-FTP.md` | ⏳ Pendiente de aprobación |

### Documentos de seguimiento (serie 60-69)

| Documento | Finalidad | Dependencias | Estado |
|-----------|-----------|--------------|--------|
| [`60-Pendientes-Etapa01-Slim-FTP.md`](60-Pendientes-Etapa01-Slim-FTP.md) | Acciones pendientes y responsables de Etapa 1 | `30-Plan-Etapa01-Slim-FTP.md` | ⏳ Pendiente de aprobación |

### Documentos de transición

| Documento | Finalidad | Dependencias | Estado |
|-----------|-----------|--------------|--------|
| [`Etapa01_Slim-Despliegue-FTP.md`](Etapa01_Slim-Despliegue-FTP.md) | **Documento de transición**: fue descompuesto en los documentos 10-60. Mantenido solo para trazabilidad histórica. | — | 🔄 Sustituido |

---

## Orden de lectura recomendado

### Para nuevos miembros del equipo

1. `00-decisiones-generales-implantacion.md` — Decisiones técnicas generales
2. `10-Decisiones-Etapa01-Slim-FTP.md` — Decisiones específicas de Etapa 1
3. `20-Alcance-Etapa01-Slim-FTP.md` — Qué está incluido/excluido
4. `30-Plan-Etapa01-Slim-FTP.md` — Plan de trabajo
5. `40-Despliegue-Etapa01-Slim-FTP.md` — Cómo desplegar
6. `50-Verificacion-Etapa01-Slim-FTP.md` — Cómo verificar
7. `60-Pendientes-Etapa01-Slim-FTP.md` — Qué falta por hacer

### Para ejecución de Etapa 1

1. `30-Plan-Etapa01-Slim-FTP.md` — Plan general
2. `40-Despliegue-Etapa01-Slim-FTP.md` — Procedimiento de despliegue
3. `50-Verificacion-Etapa01-Slim-FTP.md` — Verificación
4. `60-Pendientes-Etapa01-Slim-FTP.md` — Seguimiento

### Para toma de decisiones

1. `00-decisiones-generales-implantacion.md` — Decisiones generales
2. `10-Decisiones-Etapa01-Slim-FTP.md` — Decisiones específicas
3. `20-Alcance-Etapa01-Slim-FTP.md` — Límites del alcance

---

## Relación jerárquica entre documentos

```
00-decisiones-generales-implantacion.md (decisiones generales)
│
└── 10-Decisiones-Etapa01-Slim-FTP.md (decisiones específicas Etapa 1)
    │
    ├── 20-Alcance-Etapa01-Slim-FTP.md (qué se hace/no se hace)
    │
    ├── 30-Plan-Etapa01-Slim-FTP.md (plan de trabajo)
    │   │
    │   ├── 40-Despliegue-Etapa01-Slim-FTP.md (cómo desplegar)
    │   │   │
    │   │   └── 50-Verificacion-Etapa01-Slim-FTP.md (cómo verificar)
    │   │
    │   └── 60-Pendientes-Etapa01-Slim-FTP.md (seguimiento)
```

---

## Documentos de referencia externa

Estos documentos no son de implantación pero son necesarios para comprender el contexto:

| Documento | Ruta | Relación con implantación |
|-----------|------|---------------------------|
| Comparativa de Frameworks | `../Estudios/02-Comparativa-Frameworks-PHP.md` | Justificación de Slim |
| Análisis Técnico de Decisiones | `../Estudios/08-Analisis-Tecnico-Decisiones-Framework.md` | Análisis complementario |
| Información del servidor WA | `wa-server-info-2026-04-28-101933.json` | Datos técnicos del servidor |
| Información de salud WP | `wp-Información de salud del sitio.txt` | Contexto de WordPress |
| Boceto del proyecto | `../02-Boceto_B09.md` | Visión general del proyecto |

---

## Convenciones de nombres

| Patrón | Significado | Ejemplo |
|--------|-------------|---------|
| `00-*.md` | Decisiones generales | `00-decisiones-generales-implantacion.md` |
| `10-Decisiones-*.md` | Decisiones específicas | `10-Decisiones-Etapa01-Slim-FTP.md` |
| `20-Alcance-*.md` | Alcance | `20-Alcance-Etapa01-Slim-FTP.md` |
| `30-Plan-*.md` | Planificación | `30-Plan-Etapa01-Slim-FTP.md` |
| `40-Despliegue-*.md` | Procedimiento de despliegue | `40-Despliegue-Etapa01-Slim-FTP.md` |
| `50-Verificacion-*.md` | Procedimiento de verificación | `50-Verificacion-Etapa01-Slim-FTP.md` |
| `60-Pendientes-*.md` | Seguimiento | `60-Pendientes-Etapa01-Slim-FTP.md` |

---

## Historial de cambios de este índice

| Versión | Fecha | Cambio | Autor |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Creación del índice | Equipo de desarrollo |

---

*Documento generado el 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
