# Índice de Documentación — pre-proyecto

Directorio raíz: `pre-proyecto/`

---

## 📁 Carpeta Raíz: `pre-proyecto/`

Documentos principales de definición y entendimiento del proyecto.

| Número | Nombre del archivo | Ruta relativa | Finalidad | Dependencias | Resumen breve |
|--------|-------------------|---------------|-----------|--------------|---------------|
| 1 | `02-Boceto_B09.md` | `pre-proyecto/02-Boceto_B09.md` | Actualizar y expandir el entendimiento del proyecto (v0.9) | `legado-obsoleto/01-Boceto_B08.md` | Versión mejorada del Boceto B08 con 34 secciones detalladas: flujo completo, estados, configuración de WA, usuarios, formulario de revisión, aprobación/rechazo, gestión de errores, log del proceso y dependencias críticas. Incluye índice de contenido estructurado. |
| 2 | `03-Boceto_B09-ACLARATIVO.md` | `pre-proyecto/03-Boceto_B09-ACLARATIVO.md` | Documentar decisiones y aclaraciones pendientes (R04) | `02-Boceto_B09.md`, `PyR/01-R01.md`, `PyR/02-R01_r.md`, `PyR/03-R02.md`, `PyR/04-R03.md` | Documento aclarativo que identifica lagunas, riesgos y dependencias antes de crear el sistema doc-first. Clasifica pendientes por prioridad (BLOQUEANTE, ALTA, MEDIA, BAJA) en áreas: negocio, producto WooCommerce, IA, documentación PDF, proceso, trazabilidad, seguridad y base de datos. |

---

## 📁 Carpeta: `pre-proyecto/Estudios/`

Análisis tecnológicos, investigaciones y especificaciones técnicas para decisiones de implementación.

La numeración de los archivos sigue el orden lógico de lectura: comienza con el análisis del framework candidato (01), continúa con la comparativa de alternativas (02), sigue con el motor de workflow (03), las investigaciones de autenticación y logging (04, 06), y sus correspondientes documentos de implementación técnica (05, 07).

| Número | Nombre del archivo | Ruta relativa | Finalidad | Dependencias | Resumen breve |
|--------|-------------------|---------------|-----------|--------------|---------------|
| 1 | `01-PHP-React-Framework-Analisis.md` | `pre-proyecto/Estudios/01-PHP-React-Framework-Analisis.md` | Evaluar PHP-React-Framework como base tecnológica para la WA | `02-Boceto_B09.md` | Análisis exhaustivo del framework PHP-React-Framework (mrbeandev/PHP-React-Framework). Evalúa encaje arquitectónico, stack tecnológico (PHP 8.1+, React 19, TypeScript, Vite 7), autenticación WordPress, persistencia con Eloquent ORM. Conclusión: válido con reservas (requiere tests, adaptar autenticación, extender validador). |
| 2 | `02-Comparativa-Frameworks-PHP.md` | `pre-proyecto/Estudios/02-Comparativa-Frameworks-PHP.md` | Comparar frameworks PHP como base para la WA | `01-PHP-React-Framework-Analisis.md`, `02-Boceto_B09.md` | Comparativa técnica de 5 frameworks: PHP-React-Framework (referencia), Flight PHP, Framework-X, Slim PHP, Leaf PHP. Incluye tablas comparativas, evaluación por requisitos del proyecto, riesgos y recomendación. **Recomendación: Slim PHP** (mejor equilibrio madurez/comunidad/funcionalidades). Alternativa: Flight PHP (máximo rendimiento, cero dependencias). |
| 3 | `03-Workflow-Comparativa.md` | `pre-proyecto/Estudios/03-Workflow-Comparativa.md` | Comparar herramientas de workflow para el motor de flujo del proceso | `02-Boceto_B09.md` | Evaluación de 4 herramientas: FlowCrafter, php-workflow, Pipeflow PHP, Workflow Engine Core. Comparativa de persistencia, etapas, configuración y casos de uso reales. Recomendación: Pipeflow PHP (mejor encaje global, casos reales con WordPress + IA). Workflow Engine Core descartado (versión alpha). |
| 4 | `04-Autenticacion-WordPress-Investigacion.md` | `pre-proyecto/Estudios/04-Autenticacion-WordPress-Investigacion.md` | Investigar mecanismos de autenticación de la WA contra WordPress | Ninguna | Investigación sobre validación de login desde WA externa usando sesión/cookie de WordPress. Patrones recomendados: endpoint REST mínimo `/wp-json/wa/v1/session` con `is_user_logged_in()`. Referencias a repositorios que implementan el patrón. Consideraciones técnicas: CORS, cookies cross-site, SameSite, nonces/CSRF. |
| 5 | `05-Implementacion-Autenticacion-WordPress.md` | `pre-proyecto/Estudios/05-Implementacion-Autenticacion-WordPress.md` | Especificar implementación del flujo de autenticación WA ↔ WordPress | `04-Autenticacion-WordPress-Investigacion.md` | Documento técnico detallado con código de plugin WordPress, configuración CORS, manejo de cookies SameSite, ejemplos fetch en JS/TS. Incluye 4 fases de implementación, checklist de seguridad, pruebas técnicas y código de referencia completo. Conclusión: viable con condiciones (HTTPS, CORS, nonces). |
| 6 | `06-Log-Errores-Investigacion.md` | `pre-proyecto/Estudios/06-Log-Errores-Investigacion.md` | Investigar librerías PHP para logging, manejo de errores y tracking | Ninguna | Análisis de 13 repositorios: Monolog (logging PSR-3), NormalizedException, Symfony ErrorHandler, Symfony Workflow (estados), Symfony Messenger (retries), Chevere Workflow, OpenTelemetry, Sentry, Temporal SDK. Clasificación por capacidades: logging, manejo de errores, tracking de estados, retries, observabilidad. |
| 7 | `07-Implementacion-Logging-Trazabilidad.md` | `pre-proyecto/Estudios/07-Implementacion-Logging-Trazabilidad.md` | Especificar sistema de logging, trazabilidad y registro de errores/éxitos | `06-Log-Errores-Investigacion.md` | Documento técnico detallado con arquitectura de logging (Monolog + NormalizedException + Symfony Workflow), estructura de tablas en BD, 13 estados del proceso, códigos de error estandarizados, política de retención, API de consultas y diferenciación de visibilidad usuario/admin. |
| 8 | `08-Analisis-Tecnico-Decisiones-Framework.md` | `pre-proyecto/Estudios/08-Analisis-Tecnico-Decisiones-Framework.md` | Analizar 5 cuestiones técnicas clave sobre framework, auth, tests y logging | `01-PHP-React-Framework-Analisis.md`, `02-Comparativa-Frameworks-PHP.md`, `05-Implementacion-Autenticacion-WordPress.md`, `02-Boceto_B09.md` | Análisis detallado de: (1) cómo resolver carencias de UI en Slim, (2) aplicabilidad de la autenticación WordPress a Slim, (3) corrección sobre el sistema de auth de PHP-React-Framework, (4) viabilidad de tests como contribución externa, (5) suficiencia de Slim para logging y errores según requisitos B09. **Conclusión: Slim sigue siendo la recomendación principal; ninguno de los puntos analizados revela impedimentos reales.** |

---

## 📁 Carpeta: `pre-proyecto/codespace/`

Documentación del entorno de desarrollo y herramientas del codespace.

| Número | Nombre del archivo | Ruta relativa | Finalidad | Dependencias | Resumen breve | Estado |
|--------|-------------------|---------------|-----------|--------------|---------------|--------|
| 1 | `guia-inicio-rapido-opencode.md` | `pre-proyecto/codespace/guia-inicio-rapido-opencode.md` | Guía de inicio rápido sobre OpenCode para desarrolladores nuevos | `.skills/context7/SKILL.md` | Documento en español de España que explica qué es OpenCode, cómo usar agentes, agente orquestador, skills y modelos disponibles (Qwen, DeepSeek). Incluye esquemas de implementación, comandos útiles y referencias a documentación oficial. Basado en documentación verificada de opencode.ai. | ⏳ Pendiente de incorporar a la estructura principal del proyecto |

---

## 📁 Carpeta: `pre-proyecto/PyR/`

Documentos de Preguntas y Respuestas para aclaración de requisitos y propuesta metodológica.

| Número | Nombre del archivo | Ruta relativa | Finalidad | Dependencias | Resumen breve |
|--------|-------------------|---------------|-----------|--------------|---------------|
| 1 | `01-R01.md` | `pre-proyecto/PyR/01-R01.md` | Analizar Boceto_B08.md y proponer estructura de Product Vision Document | `legado-obsoleto/01-Boceto_B08.md` | Análisis del Boceto B08: fortalezas (claridad de flujo, delimitación de responsabilidades, gestión de excepciones), debilidades (secciones incompletas, 47 puntos poco definidos). Propone estructura de PVD con 17 secciones. Formula 17 preguntas de aclaración sobre objetivos, WA, IA, WordPress/WooCommerce y usuarios. |
| 2 | `02-R01_r.md` | `pre-proyecto/PyR/02-R01_r.md` | Responder preguntas de aclaración del R01.md | `PyR/01-R01.md` | Respuestas oficiales del líder del proyecto a las 17 preguntas de R01. Decisiones clave: objetivo de negocio (reducir tiempo, eliminar errores, alto volumen), WA desarrollada desde cero, 100+ PDFs, plazo 18 mayo 2026, login contra WordPress, CRUD de proveedores IA, sistema doc-first según R02.md. Identifica huecos reales pendientes. |
| 3 | `03-R02.md` | `pre-proyecto/PyR/03-R02.md` | Proponer sistema doc-first estricto con 4 Contratos | `02-Boceto_B09.md`, `PyR/02-R01_r.md` | Propuesta de 4 documentos normativos: (1) Contrato funcional (qué hace el sistema, objetivos de negocio, criterios de calidad), (2) Contrato de proceso (máquina de estados, errores, trazabilidad), (3) Contrato de IA (extracción PDF, contenido WooCommerce), (4) Contrato técnico (arquitectura, integraciones). Define qué debe tratar, resolver y qué no debe contener cada contrato. |
| 4 | `04-R03.md` | `pre-proyecto/PyR/04-R03.md` | Evaluar la propuesta documental de R02.md | `PyR/03-R02.md` | Evaluación crítica de los 4 Contratos propuestos en R02. Valoración: válido en estructura pero incompleto en alcance. Identifica lagunas: objetivos cuantificables, criterios de aceptación, requisitos no funcionales, planificación, glosario, matriz de trazabilidad. Recomienda ampliar Contrato 1 con objetivos de negocio y criterios SEO/LLM. Propone documentación adicional a añadir o descartar. |

---

## 📊 Relaciones entre Documentos

```
pre-proyecto/
│
├── legado-obsoleto/
│   └── 01-Boceto_B08.md ───────────────────────────────┐
│           │                                            │
│           ▼                                            │
├── 02-Boceto_B09.md ─────────────────────────────┐      │
│        │                                         │      │
│        ▼                                         │      │
├── 03-Boceto_B09-ACLARATIVO.md ◄──────────────────┼──────┘
│                                                   │
├── codespace/                                      │
│   └── guia-inicio-rapido-opencode.md ◄────────────│── pendiente
│                                                   │
├── Estudios/                                       │
│   ├── 01-PHP-React-Framework-Analisis.md ◄────────┤
│   │        │                                      │
│   │        ▼                                      │
│   ├── 02-Comparativa-Frameworks-PHP.md            │
│   ├── 03-Workflow-Comparativa.md ◄────────────────┤
│   ├── 04-Autenticacion-WordPress-Investigacion.md │
│   │        │                                      │
│   │        ▼                                      │
│   ├── 05-Implementacion-Autenticacion-WordPress.md│
│   ├── 06-Log-Errores-Investigacion.md             │
│   │        │                                      │
│   │        ▼                                      │
│   │        │                                      │
│   │        ▼                                      │
│   └── 08-Analisis-Tecnico-Decisiones-Framework.md │
│                                                   │
└── PyR/                                            │
    ├── 01-R01.md ◄────────────────────────────────┘
        │        │
            │        ▼
                ├── 02-R01_r.md
                    │        │
                        │        ▼
                            ├── 03-R02.md ◄─────────────────────────────────► Estudios/*
                                │        │
                                    │        ▼
                                        └── 04-R03.md
                                        ```

                                        ---

                                        ## 📋 Orden Recomendado de Lectura

                                        | Prioridad | Ruta | Motivo |
                                        |-----------|------|--------|
                                        | 1 | `pre-proyecto/02-Boceto_B09.md` | Entendimiento completo y actualizado del proyecto (v0.9) |
                                        | 2 | `pre-proyecto/PyR/01-R01.md` | Primer análisis crítico y preguntas de aclaración |
                                        | 3 | `pre-proyecto/PyR/02-R01_r.md` | Respuestas oficiales que definen decisiones clave |
                                        | 4 | `pre-proyecto/PyR/03-R02.md` | Propuesta metodológica doc-first para el desarrollo |
                                        | 5 | `pre-proyecto/PyR/04-R03.md` | Evaluación y refinamiento de la propuesta documental |
                                        | 6 | `pre-proyecto/03-Boceto_B09-ACLARATIVO.md` | Documento síntesis que consolida todos los pendientes |
                                        | 7 | `pre-proyecto/Estudios/01-PHP-React-Framework-Analisis.md` | Decisión tecnológica: análisis del framework candidato inicial |
                                        | 8 | `pre-proyecto/Estudios/02-Comparativa-Frameworks-PHP.md` | **Decisión tecnológica: comparativa de frameworks** (recomendación: Slim PHP) |
                                        | 9 | `pre-proyecto/Estudios/03-Workflow-Comparativa.md` | Decisión tecnológica: motor de workflow (recomendación: Pipeflow PHP) |
                                        | 10 | `pre-proyecto/Estudios/04-Autenticacion-WordPress-Investigacion.md` | Investigación previa: autenticación con WordPress |
                                        | 11 | `pre-proyecto/Estudios/05-Implementacion-Autenticacion-WordPress.md` | Implementación: flujo de autenticación WA ↔ WordPress |
                                        | 12 | `pre-proyecto/Estudios/06-Log-Errores-Investigacion.md` | Investigación previa: librerías de logging y errores |
| 13 | `pre-proyecto/Estudios/07-Implementacion-Logging-Trazabilidad.md` | Implementación: sistema de logging, trazabilidad y errores |
| 14 | `pre-proyecto/Estudios/08-Analisis-Tecnico-Decisiones-Framework.md` | **Análisis complementario**: resolución de 5 cuestiones técnicas sobre la decisión de framework |
| 15 | `pre-proyecto/codespace/guia-inicio-rapido-opencode.md` | **Nuevo desarrollador**: guía de OpenCode para el entorno de desarrollo |
                                        | — | `pre-proyecto/legado-obsoleto/01-Boceto_B08.md` | **Referencia histórica**: entendimiento inicial (v0.8), obsoleto |

                                        ---

                                        ## 🔑 Conceptos Clave

                                        | Término | Definición |
                                        |---------|------------|
                                        | **WA** | Web-App externa a WordPress que actúa como centro de control del proceso |
                                        | **WP** | WordPress: plataforma de almacenamiento y validación de usuarios |
                                        | **WooC / WooCommerce** | Destino final de creación y publicación de productos vía API |
                                        | **IA** | Múltiples ejecuciones de Inteligencia Artificial con roles diferenciados |
                                        | **doc-first** | Enfoque de desarrollo basado en documentación normativa como fuente de verdad |
                                        | **Contrato** | Documento normativo que define aspectos específicos del sistema (funcional, proceso, IA, técnico) |
                                        | **PDF → Producto** | Relación base: 1 PDF genera 1 producto WooCommerce (con excepciones) |
                                        | **OpenCode (OC)** | Agente de codificación de código abierto usado en el entorno de desarrollo |

                                        ---

                                        *Última actualización: 28 de abril de 2026*
                                        