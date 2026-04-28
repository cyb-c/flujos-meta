# Inventario de Recursos y Configuración

> **Finalidad:** Fuente única de verdad para recursos del proyecto.
> **Versión:** 1.1
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
13. [Notas de Mantenimiento](#notas-de-mantenimiento)

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
| **Nombre del proyecto** | |
| **Finalidad** | |
| **Repositorio** | |
| **Entorno de trabajo** | |
| **Lenguaje base** | |
| **Stack tecnológico** | |
| **Entornos de despliegue** | |
| **Plataformas de deployment** | |
| **Gestión de Secrets** | |
| **Estructura del proyecto** | |

---

## 2. Secrets para Despliegue

| Secret | Ubicación | Uso | Estado |
|--------|-----------|-----|--------|
| | | | 🔲 |

> **Nota:** Los valores de secrets nunca se documentan en este archivo. Solo se registran los nombres.

---

## 3. Secrets de Desarrollo Local

### 3.1. Backend

| Variable | Uso | Sensible | Ejemplo | Estado |
|----------|-----|----------|---------|--------|
| | | | | 🔲 |

### 3.2. Frontend

| Variable | Uso | Sensible | Ejemplo | Estado |
|----------|-----|----------|---------|--------|
| | | | | 🔲 |

> **Nota:** Usar archivos de plantilla de entorno (ej. `.env.example`) como plantillas versionadas sin valores reales. Los archivos de entorno local deben estar en `.gitignore`.

---

## 4. Recursos del Proyecto

### 4.1. Base de Datos

| Recurso | Proveedor | Ambiente | Connection String | Estado |
|---------|-----------|----------|-------------------|--------|
| | | | | 🔲 |

**Esquema de Base de Datos:**
- Modelos:
- Migraciones:
- Seed:

### 4.2. Plataforma de Despliegue

| Recurso | Valor | Estado |
|---------|-------|--------|
| **Proyecto** | | 🔲 |
| **Plan** | | 🔲 |
| **Dominio** | | 🔲 |
| **Environment Variables** | | 🔲 |

---

## 5. Configuración de Despliegue

| Campo | Valor |
|-------|-------|
| **Método primario** | |
| **Archivo de configuración** | |
| **Autenticación** | |
| **Comando de build** | |
| **Comando de start** | |

### 5.1. Variables de Entorno en Plataforma de Despliegue

| Variable | Tipo | Sensible | Ubicación | Estado |
|----------|------|----------|-----------|--------|
| | | | | 🔲 |

---

## 6. Variables de Entorno por Servicio

### Backend

| Variable | Tipo | Sensible | Descripción | Estado |
|----------|------|----------|-------------|--------|
| | | | | 🔲 |

### Frontend

| Variable | Tipo | Sensible | Descripción | Estado |
|----------|------|----------|-------------|--------|
| | | | | 🔲 |

---

## 7. Integraciones Externas

| Servicio | Propósito | Variables Requeridas | Estado |
|----------|-----------|---------------------|--------|
| | | | 🔲 |

---

## 8. Contratos entre Servicios

| Servicio Origen | Servicio Destino | Endpoint | Método | Request | Response | Estado |
|-----------------|------------------|----------|--------|---------|----------|--------|
| | | | | | | 🔲 |

---

## 9. Stack Tecnológico

| Capa | Tecnología | Versión | Estado |
|------|------------|---------|--------|
| | | | 🔲 |

---

## 10. Archivos de Configuración

| Archivo | Finalidad | Estado |
|---------|-----------|--------|
| Gestor de paquetes | Dependencias y scripts | 🔲 |
| Configuración del lenguaje | Configuración del lenguaje | 🔲 |
| Configuración de despliegue | Configuración de despliegue | 🔲 |
| Plantilla de variables | Plantilla de variables | 🔲 |
| `.gitignore` | Exclusiones de versionado | 🔲 |

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
