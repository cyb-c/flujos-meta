# Notas de Cambios — Capa 1: Reglas Universales

## Última Actualización

**Fecha:** 2026-04-28  
**Versión:** 1.1  
**Tipo:** Actualización según instrucciones específicas

---

## Archivos Originales Usados

| Archivo | Versión | Líneas | Propósito |
|---------|---------|--------|-----------|
| `temp/reglas_proyecto.md` | 5.1 | 521 | Fuente original de reglas del proyecto |
| `temp/analisis_agnosticismo_reglas.md` | 1.0 | 275 | Análisis de dependencias y propuestas de generalización |

---

## Archivos en `temp/reglas_agnosticas_capa1/`

### Archivos Modificados

| Archivo | Versión | Cambios Principales |
|---------|---------|---------------------|
| `reglas_universales.md` | 1.1 | Fusiones de reglas, eliminación de R6/R7/R9/R18, índice añadido |
| `inventario_recursos.md` | 1.1 | Eliminadas secciones 10/12/13, regla de solo información verificada, índice añadido |

### Archivos Creados

| Archivo | Versión | Propósito |
|---------|---------|-----------|
| `inventario_recursos_bitaacora.md` | 1.0 | Registro centralizado de cambios del inventario |
| `documentacion_tecnica_preventiva.md` | 1.0 | Conocimiento técnico validado para prevenir errores (extraído de R18) |

---

## Reglas Fusionadas

### Fusión 1: R1 + R16
**Resultado:** `R1 — No asumir valores no documentados y convención de nombres`

- Mantiene principio de no asumir valores
- Añade instrucción explícita: si falta valor, detener acción, registrar bloqueo fuera del inventario, solicitar confirmación
- Incorpora convenciones de nombres de R16 como obligaciones

### Fusión 2: R2 + R4
**Resultado:** `R2 — Cero hardcoding y validación de variables de entorno`

- Mantiene prohibición de hardcoding
- Añade principio: configuración debe venir de fuentes externas verificadas
- Incorpora validación de variables obligatorias antes de uso
- Todas las obligaciones de R2 y R4 consolidadas

### Fusión 3: R14 + R15
**Resultado:** `R14 — Variables de entorno del frontend e inventario actualizado`

- Mantiene obligaciones de variables de frontend
- Incorpora regla de inventario actualizado
- Exige que inventario registre solo variables reales y verificadas
- Exige registro de recursos, agentes, endpoints, scripts y documentos existentes

---

## Reglas Eliminadas como Universales

| Regla | Motivo |
|-------|--------|
| R6 — Convención de respuestas HTTP | Técnica específica, no regla universal de gobernanza |
| R7 — CORS y seguridad de orígenes | Técnica específica, no regla universal de gobernanza |
| R9 — Migraciones de esquema de base de datos | Técnica específica, no regla universal de gobernanza |
| R18 — Consulta obligatoria de documentación técnica preventiva | Extraída a documento independiente `documentacion_tecnica_preventiva.md` |

---

## Cambios en `reglas_universales.md`

### Eliminados
- R6 completa (Convención de respuestas HTTP)
- R7 completa (CORS y seguridad de orígenes)
- R9 completa (Migraciones de esquema de base de datos)
- R18 completa (como regla independiente)

### Modificados
- R1: Fusionada con R16, añadida instrucción de detener acción si falta valor
- R2: Fusionada con R4, añadida validación de variables
- R8: Añadida prohibición explícita de CI/CD y otros métodos; solo agente de despliegue válido
- R14: Fusionada con R15
- Jerarquía de Documentos: Añadidos `inventario_recursos_bitaacora.md` y `documentacion_tecnica_preventiva.md`
- Política de Versionamiento: Referencia a bitácora en lugar de historial interno
- Referencias: Añadidos nuevos documentos

### Añadidos
- Índice interno de secciones
- Referencia a `documentacion_tecnica_preventiva.md` en Orden de Lectura

---

## Cambios en `inventario_recursos.md`

### Eliminados
- Sección 10: Comandos de Desarrollo
- Sección 12: Vacíos Pendientes de Confirmación
- Sección 13: Historial de Cambios
- Referencias a CI/CD en sección 2

### Modificados
- Reglas de Uso: Añadidas reglas 5, 6, 7 (solo información real, existente y verificada)
- Notas de Mantenimiento: Añadidas reglas 7 y 8 (solo información verificada, registro en bitácora)
- Sección 10 (Archivos de Configuración): Generalizados nombres de archivos

### Añadidos
- Índice interno de secciones
- Restricción en cabecera: "Solo puede contener información real, existente y verificada"

---

## Nuevo Documento: `inventario_recursos_bitaacora.md`

**Propósito:** Registrar todos los cambios realizados en `inventario_recursos.md`

**Contenido:**
- Reglas de registro
- Historial de cambios (tabla vacía para completar)
- Plantilla de registro
- Tipos de cambio (Creación, Modificación, Eliminación, Corrección, Verificación)

**Principio:** El historial de cambios no debe estar dentro del inventario principal.

---

## Nuevo Documento: `documentacion_tecnica_preventiva.md`

**Propósito:** Contener conocimiento técnico validado para prevenir errores comunes

**Contenido:**
- Propósito del documento
- Consulta obligatoria (antes de planificar, diseñar, desarrollar, corregir, depurar, probar, desplegar)
- Responsabilidades
- Excepciones
- Secciones para: Conocimiento Técnico Validado, Errores Comunes y Soluciones, Guías de Prevención
- Relación con otros documentos

**Principio:** Este documento es complementario a `inventario_recursos.md`.

---

## Eliminación de CI/CD

### En `reglas_universales.md`
- R3: "plataforma de despliegue o CI/CD" → "plataforma de despliegue"
- R8: "plataforma de despliegue o CI/CD" → "plataforma de despliegue"
- R8: Añadida prohibición explícita de CI/CD

### En `inventario_recursos.md`
- Sección 2: "Secrets para Despliegue (CI/CD)" → "Secrets para Despliegue"

---

## Regla de Despliegue Modificada (R8)

**Nuevas obligaciones 8 y 9:**
8. **El único mecanismo válido de despliegue es el agente de despliegue del repositorio.**
9. **Queda prohibido desplegar mediante CI/CD, FTP manual, scripts alternativos, comandos manuales u otros agentes.**

---

## Puntos Pendientes de Revisión

| Punto | Estado | Notas |
|-------|--------|-------|
| Redacción contractual verificada | ✅ | Todas las reglas con lenguaje imperativo |
| Índices internos añadidos | ✅ | En los cuatro archivos |
| CI/CD eliminado completamente | ✅ | Sin referencias restantes |
| Reglas fusionadas correctamente | ✅ | R1+R16, R2+R4, R14+R15 |
| Reglas eliminadas (R6, R7, R9) | ✅ | No son reglas universales |
| R18 extraída a documento | ✅ | `documentacion_tecnica_preventiva.md` creado |
| Bitácora separada del inventario | ✅ | `inventario_recursos_bitaacora.md` creado |
| Regla de solo información verificada | ✅ | En `inventario_recursos.md` |

---

## Estructura Final de Archivos

```
temp/reglas_agnosticas_capa1/
├── reglas_universales.md           (Reglas de gobernanza, 14 reglas + jerarquía + versionamiento)
├── inventario_recursos.md          (Plantilla de inventario, 10 secciones)
├── inventario_recursos_bitaacora.md (Bitácora de cambios del inventario)
├── documentacion_tecnica_preventiva.md (Conocimiento técnico para prevenir errores)
└── notas_cambios.md                (Este archivo: trazabilidad)
```

---

*Documento generado el 2026-04-28. Subcarpeta: `temp/reglas_agnosticas_capa1/`*
