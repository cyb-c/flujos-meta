# Etapa 1: Slim + FTP — Documento de Transición

**Versión:** 3.0 (Sustituido)  
**Fecha:** 28 de abril de 2026  
**Estado:** ⚠️ **SUSTITUIDO** — Descompuesto en documentos 10-60

---

## Aviso importante

Este documento **ha sido descompuesto** en múltiples documentos especializados para mejorar la claridad y mantenibilidad de la documentación de implantación.

**No utilice este documento como referencia operativa.** Consulte los documentos de la serie 10-60 listados a continuación.

---

## Razón de la descomposición

El documento original `Etapa01_Slim-Despliegue-FTP.md` se convirtió en un **megadocumento de 700+ líneas** que mezclaba:
- Decisiones técnicas
- Alcance del proyecto
- Planificación detallada
- Procedimientos operativos
- Verificación
- Seguimiento de pendientes

Esta mezcla dificultaba:
- La búsqueda de información específica
- El mantenimiento de cada sección
- La aprobación por partes separadas
- La reutilización en otras etapas

---

## Nueva estructura documental

El contenido de este documento ha sido redistribuido en los siguientes documentos:

| Documento | Contenido principal | Estado |
|-----------|---------------------|--------|
| [`00-INDICE-Implantacion.md`](00-INDICE-Implantacion.md) | Índice general de implantación | ✅ Activo |
| [`00-decisiones-generales-implantacion.md`](00-decisiones-generales-implantacion.md) | Decisiones generales (pre-existente) | ✅ Activo |
| [`10-Decisiones-Etapa01-Slim-FTP.md`](10-Decisiones-Etapa01-Slim-FTP.md) | Decisiones específicas de Etapa 1 | ✅ Activo |
| [`20-Alcance-Etapa01-Slim-FTP.md`](20-Alcance-Etapa01-Slim-FTP.md) | Alcance incluido/excluido | ✅ Activo |
| [`30-Plan-Etapa01-Slim-FTP.md`](30-Plan-Etapa01-Slim-FTP.md) | Plan detallado de trabajo | ✅ Activo |
| [`40-Despliegue-Etapa01-Slim-FTP.md`](40-Despliegue-Etapa01-Slim-FTP.md) | Procedimiento de despliegue | ✅ Activo |
| [`50-Verificacion-Etapa01-Slim-FTP.md`](50-Verificacion-Etapa01-Slim-FTP.md) | Procedimiento de verificación | ✅ Activo |
| [`60-Pendientes-Etapa01-Slim-FTP.md`](60-Pendientes-Etapa01-Slim-FTP.md) | Seguimiento de pendientes | ✅ Activo |

---

## Mapa de contenido original → nuevos documentos

| Sección original (este documento) | Nuevo documento | Sección equivalente |
|-----------------------------------|-----------------|---------------------|
| 1. Objetivo de la etapa | `30-Plan-Etapa01-Slim-FTP.md` | 2. Objetivo de la etapa |
| 2. Contexto: Etapa 1 del desarrollo general | `30-Plan-Etapa01-Slim-FTP.md` | 2. Objetivo de la etapa |
| 3. Alcance incluido y excluido | `20-Alcance-Etapa01-Slim-FTP.md` | 2-3. Alcance |
| 4. Repositorio como base clonable | `10-Decisiones-Etapa01-Slim-FTP.md` | 6. Relación con decisiones generales |
| 5. Rutas de despliegue: sin subdirectorios fijos | `10-Decisiones-Etapa01-Slim-FTP.md` | 3-5. Rutas y configuración |
| 6. Requisitos técnicos mínimos | `30-Plan-Etapa01-Slim-FTP.md` | 3. Requisitos técnicos |
| 7. Preparación local de Slim | `30-Plan-Etapa01-Slim-FTP.md` | 4-5. Estructura y actividades |
| 8. Preparación del paquete desplegable | `40-Despliegue-Etapa01-Slim-FTP.md` | 2. Preparación del despliegue |
| 9. Estrategia de despliegue por FTP | `40-Despliegue-Etapa01-Slim-FTP.md` | 3-4. Despliegue |
| 10. Prueba "Hola mundo" | `50-Verificacion-Etapa01-Slim-FTP.md` | 3. Verificación HTTP |
| 11. Verificación posterior al despliegue | `50-Verificacion-Etapa01-Slim-FTP.md` | 4-5. Verificación de archivos y logs |
| 12. Criterios de aceptación | `30-Plan-Etapa01-Slim-FTP.md` | 6. Criterios de aceptación |
| 13. Riesgos y mitigaciones | `30-Plan-Etapa01-Slim-FTP.md` | 7. Riesgos y mitigaciones |
| 14. Datos o acciones pendientes | `60-Pendientes-Etapa01-Slim-FTP.md` | 2-3. Acciones pendientes |
| 15. Evaluación: agente o skill para Slim | `00-decisiones-generales-implantacion.md` | Sección evaluativa (no migrada completamente) |
| Anexos | Varios documentos | Referencias distribuidas |

---

## Correcciones aplicadas durante la descomposición

### Errores corregidos

| Error | Corrección aplicada |
|-------|---------------------|
| Referencia a `pre-proyecto/wa-slim/` | Corregido a: proyecto en **raíz del repositorio** |
| Uso de `wa-slim/` en rutas FTP | Corregido a: despliegue directo en `/home/beevivac/stg2.cofemlevante.es/` |
| Estructura de directorios dentro de `pre-proyecto/` | Corregido a: `pre-proyecto/` es **solo para documentación** |
| Rutas hardcodeadas | Corregido a: rutas configurables vía variables de entorno |

### Decisiones de diseño confirmadas

| Decisión | Documento | Sección |
|----------|-----------|---------|
| Slim en raíz del repositorio | `10-Decisiones-Etapa01-Slim-FTP.md` | 2. Ubicación del proyecto Slim |
| Despliegue directo sin `wa-slim/` | `10-Decisiones-Etapa01-Slim-FTP.md` | 3-4. Rutas y despliegue |
| Configuración no acoplada | `10-Decisiones-Etapa01-Slim-FTP.md` | 5. Configuración de rutas |
| Agente `@ftp-deployer` para despliegue | `40-Despliegue-Etapa01-Slim-FTP.md` | 3. Despliegue mediante agente |

---

## Trazabilidad histórica

### Versiones de este documento

| Versión | Fecha | Estado | Notas |
|---------|-------|--------|-------|
| 1.0 | 28 abr 2026 | Obsoleto | Documento original `01-Plan-Implantacion-Inicial.md` |
| 2.0 | 28 abr 2026 | Obsoleto | Renombrado a `Etapa01_Slim-Despliegue-FTP.md`, contenido expandido |
| 3.0 | 28 abr 2026 | **Sustituido** | Descompuesto en documentos 10-60 |

### Documentos originales (obsoletos)

- `01-Plan-Implantacion-Inicial.md` → Renombrado a `Etapa01_Slim-Despliegue-FTP.md` (v1.0 → v2.0)
- `Etapa01_Slim-Despliegue-FTP.md` (v2.0, 706 líneas) → Descompuesto en documentos 10-60 (v3.0)

---

## Cómo usar esta documentación

### Para nuevos miembros del equipo

1. Leer `00-INDICE-Implantacion.md` — Visión general
2. Leer `00-decisiones-generales-implantacion.md` — Decisiones generales
3. Leer `10-Decisiones-Etapa01-Slim-FTP.md` — Decisiones específicas
4. Leer `30-Plan-Etapa01-Slim-FTP.md` — Plan de trabajo

### Para ejecución de Etapa 1

1. `30-Plan-Etapa01-Slim-FTP.md` — Plan general
2. `40-Despliegue-Etapa01-Slim-FTP.md` — Cómo desplegar
3. `50-Verificacion-Etapa01-Slim-FTP.md` — Cómo verificar
4. `60-Pendientes-Etapa01-Slim-FTP.md` — Seguimiento

### Para toma de decisiones

1. `00-decisiones-generales-implantacion.md` — Decisiones generales
2. `10-Decisiones-Etapa01-Slim-FTP.md` — Decisiones específicas
3. `20-Alcance-Etapa01-Slim-FTP.md` — Límites del alcance

---

## Referencias

### Índices

| Documento | Ruta |
|-----------|------|
| Índice de implantación | `00-INDICE-Implantacion.md` |
| Índice general del proyecto | `../INDICE.md` |

### Documentos activos de Etapa 1

| Documento | Ruta |
|-----------|------|
| Decisiones | `10-Decisiones-Etapa01-Slim-FTP.md` |
| Alcance | `20-Alcance-Etapa01-Slim-FTP.md` |
| Plan | `30-Plan-Etapa01-Slim-FTP.md` |
| Despliegue | `40-Despliegue-Etapa01-Slim-FTP.md` |
| Verificación | `50-Verificacion-Etapa01-Slim-FTP.md` |
| Pendientes | `60-Pendientes-Etapa01-Slim-FTP.md` |

---

*Documento mantenido solo para trazabilidad histórica*  
*Última actualización: 28 de abril de 2026*  
*Pre-proyecto — Web-App de Automatización WooCommerce*
