# Reglas Universales de Gobernanza de Proyecto

> **Aplicación:** Estas reglas aplican a todos los agentes, colaboradores y contribuyentes del proyecto.
> **Versión:** 1.1
> **Carácter:** Contrato obligatorio e independiente de tecnología, lenguaje, framework o plataforma.
> **Fuente de verdad para valores específicos:** `inventario_recursos.md`

---

## Índice

1. [Preámbulo](#preámbulo)
2. [Regla de Consulta Obligatoria de Inventario](#regla-de-consulta-obligatoria-de-inventario)
3. [R1 — No asumir valores no documentados y convención de nombres](#r1--no-asumir-valores-no-documentados-y-convención-de-nombres)
4. [R2 — Cero hardcoding y validación de variables de entorno](#r2--cero-hardcoding-y-validación-de-variables-de-entorno)
5. [R3 — Gestión de secrets y credenciales](#r3--gestión-de-secrets-y-credenciales)
6. [R5 — Idioma y estilo](#r5--idioma-y-estilo)
7. [R8 — Configuración de despliegue](#r8--configuración-de-despliegue)
8. [R10 — Estrategia de pruebas](#r10--estrategia-de-pruebas)
9. [R11 — Calidad de código antes de commit](#r11--calidad-de-código-antes-de-commit)
10. [R12 — Convenciones de commit](#r12--convenciones-de-commit)
11. [R13 — Contratos entre servicios](#r13--contratos-entre-servicios)
12. [R14 — Variables de entorno del frontend e inventario actualizado](#r14--variables-de-entorno-del-frontend-e-inventario-actualizado)
13. [Jerarquía de Documentos de Gobernanza](#jerarquía-de-documentos-de-gobernanza)
14. [Política de Versionamiento de Documentos](#política-de-versionamiento-de-documentos)
15. [Referencias a Documentos de Gobernanza](#referencias-a-documentos-de-gobernanza)

---

## Preámbulo

Este documento establece reglas de gobernanza universales, aplicables a cualquier proyecto de software independientemente de su stack tecnológico, lenguaje de programación, framework, plataforma de despliegue o proveedor de infraestructura.

Las reglas aquí contenidas son de cumplimiento obligatorio. Su propósito es garantizar seguridad, consistencia, trazabilidad y calidad en el desarrollo y mantenimiento del proyecto.

---

## Regla de Consulta Obligatoria de Inventario

**REQUIREMENT_ID:** GOV-PRE  
**Prioridad:** Crítica

**Todo agente o colaborador debe consultar `inventario_recursos.md` antes de iniciar cualquier acción relevante que afecte recursos, configuración, variables de entorno, endpoints, contratos entre servicios o infraestructura del proyecto.**

Esta consulta previa es obligatoria para obtener una foto instantánea del estado actual del proyecto y evitar:
- Introducción de valores no documentados
- Hardcoding de recursos o configuraciones
- Inconsistencias entre lo implementado y lo documentado
- Duplicación de recursos o configuraciones

**Consecuencia:** El incumplimiento de esta regla será detectado en la siguiente auditoría de `@governance-auditor` y reportado como discrepancia.

---

## R1 — No asumir valores no documentados y convención de nombres

**REQUIREMENT_ID:** GOV-R1  
**Prioridad:** Crítica

Si existe duda sobre nombres de recursos, endpoints, contratos entre servicios, variables de entorno o cualquier valor no documentado, **se debe detener la acción, registrar el bloqueo fuera del inventario y solicitar confirmación antes de generar código**.

**Obligaciones:**
1. No inventar nombres de variables de entorno, rutas API o configuraciones de base de datos.
2. No asumir URLs, credenciales, connection strings o IDs de recursos.
3. Consultar `inventario_recursos.md` antes de referenciar cualquier recurso, endpoint o variable.
4. Validar la disponibilidad de variables de entorno en los archivos de entorno documentados.
5. Si falta un valor no documentado: detener la acción, registrar el bloqueo en documentación externa (no en inventario) y solicitar confirmación.
6. Para mantener consistencia en nombres de variables de entorno, seguir convenciones descriptivas del proyecto:
   - Bases de datos: variables descriptivas de conexión
   - Servicios externos: `[SERVICIO]_API_KEY`, `[SERVICIO]_SECRET`
   - URLs públicas o internas: variables descriptivas
   - Flags de comportamiento: `ENABLE_*`, `DEBUG_*`
   - Variables públicas (frontend): prefijo o mecanismo que el framework defina para variables públicas
7. Los nombres específicos y su propósito se registran en `inventario_recursos.md`.

---

## R2 — Cero hardcoding y validación de variables de entorno

**REQUIREMENT_ID:** GOV-R2  
**Prioridad:** Crítica

Queda prohibido codificar literales de credenciales, connection strings, URLs de servicios, IDs de base de datos, claves API o cualquier valor que pueda variar entre entornos. Toda configuración debe provenir de fuentes externas verificadas y toda variable obligatoria debe validarse antes de usarse.

**Obligaciones:**
1. Usar variables de entorno o secrets gestionados por la plataforma de despliegue.
2. En código de servidor: leer variables de entorno desde el mecanismo provisto por el runtime.
3. En código de cliente: usar únicamente variables explícitamente marcadas como públicas según la convención del framework.
4. Referenciar `inventario_recursos.md` para conocer los nombres de variables válidos y su propósito.
5. No incluir datos fijos, consultas SQL, enlaces ni configuraciones hardcoded en archivos versionados.
6. Crear validadores con la librería de validación de esquemas del stack para variables de entorno críticas.
7. Centralizar la lectura de variables en módulos específicos del proyecto.
8. Validar la presencia de variables requeridas en tiempo de inicialización, no en runtime.
9. Acceder a variables de entorno solo en código de servidor, nunca exponerlas directamente al cliente.
10. Para variables que deben llegar al frontend, marcarlas explícitamente con el prefijo o mecanismo que el framework defina para variables públicas.

---

## R3 — Gestión de secrets y credenciales

**REQUIREMENT_ID:** GOV-R3  
**Prioridad:** Crítica

Todas las claves, tokens, conexiones a bases de datos y certificados deben guardarse en almacenamiento seguro y **nunca ser versionados en el repositorio**.

**Obligaciones:**
1. En desarrollo local: usar archivos de entorno local, siempre listados en `.gitignore`.
2. En despliegue: usar secrets gestionados por la plataforma de despliegue. El agente `@ftp-deployer` leerá las credenciales de variables de entorno, nunca de archivos.
3. Connection strings de base de datos: inyectar exclusivamente mediante variables de entorno.
4. Para acceso a servicios externos: guardar tokens en variables de entorno, nunca en el código.
5. Usar archivos de plantilla de entorno (ej. `.env.example`) para documentar qué variables son requeridas, sin incluir valores reales.
6. El módulo de conexión a base de datos debe leer la conexión desde variables de entorno de forma segura.

---

## R5 — Idioma y estilo

**REQUIREMENT_ID:** GOV-R5  
**Prioridad:** Alta

| Elemento | Idioma |
|----------|--------|
| Código (variables, funciones, tipos, comentarios) | Inglés |
| Documentación del proyecto y explicaciones de diseño | Definido por el proyecto |
| Mensajes de error de APIs al cliente | Idioma del usuario final |
| Mensajes al usuario (i18n) | Sistema multidioma con locale definido por el proyecto |

**Obligaciones:**
1. Mantener consistencia en el uso de idiomas según la tabla anterior.
2. El locale por defecto para internacionalización debe estar documentado en `inventario_recursos.md`.

---

## R8 — Configuración de despliegue

**REQUIREMENT_ID:** GOV-R8  
**Prioridad:** Crítica

El despliegue debe ser reproducible y seguro, sin exponer credenciales en archivos versionados.

**Obligaciones:**
1. Localizar todas las variables de entorno en el archivo de plantilla de entorno documentado.
2. Usar secrets gestionados por la plataforma de despliegue.
3. Credenciales sensibles se inyectan desde la plataforma, no desde el repositorio.
4. Declarar todas las dependencias necesarias en el gestor de paquetes del proyecto con versiones fijas (evitar `*`).
5. Si se usa contenedor, mapear correctamente las variables de build y runtime.
6. Ejecutar el comando de build o compilación del proyecto como verificación pre-despliegue.
7. Los scripts de despliegue no deben contener credenciales literales.
8. **El único mecanismo válido de despliegue es el agente `@ftp-deployer` (definido en `.opencode/agents/ftp-deployer.md`).**
9. **Queda prohibido desplegar mediante CI/CD, FTP manual, scripts alternativos, comandos manuales u cualquier otro agente OpenCode distinto de `@ftp-deployer`.**

---

## R10 — Estrategia de pruebas

**REQUIREMENT_ID:** GOV-R10  
**Prioridad:** Alta

El proyecto debe contar con un framework de test apropiado que ejecute el código en el entorno real o emulado.

**Obligaciones:**
1. Configurar mocks y bindings en el archivo de configuración del test, no en cada caso de prueba.
2. Ejecutar tests localmente antes de hacer commit.
3. Validar que los tests pasan antes de hacer push a la rama principal o solicitar pull request.

---

## R11 — Calidad de código antes de commit

**REQUIREMENT_ID:** GOV-R11  
**Prioridad:** Alta

Ejecutar linters y análisis estático; el proyecto debe compilarse sin errores.

**Obligaciones:**
1. Resolver o silenciar advertencias relevantes en el commit que introduce nuevos archivos o dependencias.
2. Incluir ejecución de tests si el proyecto tiene estrategia de pruebas activa.

---

## R12 — Convenciones de commit

**REQUIREMENT_ID:** GOV-R12  
**Prioridad:** Media

Cada commit debe tener:

1. Un identificador proporcionado por el usuario (fecha/hora o número de ticket).
2. Descripción detallada y comprensible sin revisar el diff.
3. Registro explícito de todos los cambios: qué se modificó, archivos afectados, naturaleza del cambio (creación, modificación, eliminación, reorganización o corrección).

---

## R13 — Contratos entre servicios

**REQUIREMENT_ID:** GOV-R13  
**Prioridad:** Media

Documentar las rutas, métodos y formatos de request/response de cada endpoint consumido entre servicios.

**Obligaciones:**
1. Registrar contratos en `inventario_recursos.md`.
2. Verificar disponibilidad antes de desplegar dependencias.

---

## R14 — Variables de entorno del frontend e inventario actualizado

**REQUIREMENT_ID:** GOV-R14  
**Prioridad:** Alta

**El documento `inventario_recursos.md` debe mantenerse actualizado en todo momento y registrar únicamente variables reales y verificadas expuestas al frontend, así como recursos, agentes, endpoints, scripts y documentos existentes.**

**Obligaciones:**
1. Declarar y documentar todas las variables expuestas al frontend.
2. Validar su presencia en tiempo de ejecución en lugar de en la carga del módulo.
3. Registrar en `inventario_recursos.md` con flag de sensibilidad.
4. El inventario debe registrar solo variables reales y verificadas.
5. El inventario debe registrar recursos, agentes, endpoints, scripts y documentos existentes.
6. **Ninguna persona o agente distinto de `@governance-updater` puede modificar `.gobernanza/inventario_recursos.md` directamente.**
7. Los cambios en el inventario deben solicitarse a `@governance-updater`.
8. La consistencia del inventario debe verificarse mediante auditorías periódicas ejecutadas por `@governance-auditor`.
9. Después de pruebas y antes de commit, si hay cambios en recursos, `@governance-updater` debe actualizar `_registro_/inventario_recursos_bitaacora.md` antes de continuar.
10. El incumplimiento de esta regla será detectado en la siguiente auditoría de `@governance-auditor` y reportado como discrepancia.

---

## Jerarquía de Documentos de Gobernanza

### Niveles de Prioridad

| Nivel | Documento | Propósito | Autoridad |
|-------|-----------|-----------|-----------|
| **Nivel 1** | `reglas_universales.md` | Reglas generales aplicables a todos | Máxima autoridad |
| **Nivel 2** | Documentación de roles y agentes | Criterios operativos específicos | Autoridad sobre su dominio |
| **Nivel 3** | `inventario_recursos.md` | Fuente de verdad para valores específicos | Autoridad sobre valores específicos |
| **Nivel 3** | `documentacion_tecnica_preventiva.md` | Conocimiento técnico para prevenir errores | Autoridad sobre prevención |
| **Nivel 3** | `inventario_recursos_bitaacora.md` | Registro de cambios del inventario | Trazabilidad de modificaciones |

### Regla de Conflicto

En caso de discrepancia entre documentos:

1. **Prevalece el documento de nivel superior:**
   - Si hay conflicto entre documentación de roles y `reglas_universales.md`, prevalece `reglas_universales.md`
   - Si hay conflicto entre `inventario_recursos.md` y documentación de roles, prevalece la documentación de roles

2. **Valores específicos:**
   - Para nombres de recursos, variables de entorno, endpoints y credenciales, `inventario_recursos.md` es la fuente de verdad
   - Para comportamientos y procesos, prevalece el documento de nivel superior

3. **Resolución de conflictos:**
   - Si se detecta un conflicto, reportar según el flujo de gobernanza del proyecto
   - Se decidirá cuál es la interpretación correcta
   - Los documentos deben actualizarse para reflejar la decisión

### Orden de Lectura Recomendado

Para nuevos colaboradores o agentes:

1. **Primero:** Leer `reglas_universales.md` para entender las reglas generales
2. **Segundo:** Leer la documentación de roles específica para entender criterios operativos
3. **Tercero:** Consultar `inventario_recursos.md` para valores específicos cuando sea necesario
4. **Cuarto:** Consultar `documentacion_tecnica_preventiva.md` antes de acciones que requieran conocimiento técnico verificable
5. **Quinto:** Consultar `politica_versionamiento.md` para cambios en documentación

---

## Referencias a Documentos de Gobernanza

| Documento | Propósito |
|-----------|-----------|
| `reglas_universales.md` | Define todas las reglas universales del proyecto (este documento) |
| `inventario_recursos.md` | Fuente de verdad para recursos, variables de entorno, endpoints y configuración |
| `inventario_recursos_bitaacora.md` | Registro de cambios del inventario (`_registro_/`) |
| `documentacion_tecnica_preventiva.md` | Conocimiento técnico validado para prevenir errores comunes y fallos conocidos. Consultar antes de planificar, diseñar, desarrollar, corregir, depurar, probar o desplegar. |
| `politica_versionamiento.md` | Política de versionamiento de documentos de gobernanza |
| Agentes OpenCode | Define responsabilidades y flujos de trabajo de cada agente (`@ftp-deployer`, `@governance-updater`, `@governance-auditor`) |

---

> **Nota:** Este documento es la fuente única de verdad para reglas de gobernanza. Mantener actualizado con cambios en procesos, infraestructura o requisitos del proyecto.
