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

Análisis tecnológicos e investigaciones para decisiones de implementación.

| Número | Nombre del archivo | Ruta relativa | Finalidad | Dependencias | Resumen breve |
|--------|-------------------|---------------|-----------|--------------|---------------|
| 1 | `01-A01-PHP-React-Framework-Analisis.md` | `pre-proyecto/Estudios/01-A01-PHP-React-Framework-Analisis.md` | Evaluar PHP-React-Framework como base tecnológica para la WA | `02-Boceto_B09.md` | Análisis exhaustivo del framework PHP-React-Framework (mrbeandev/PHP-React-Framework). Evalúa encaje arquitectónico, stack tecnológico (PHP 8.1+, React 19, TypeScript, Vite 7), autenticación WordPress, persistencia con Eloquent ORM. Conclusión: válido con reservas (requiere tests, adaptar autenticación, extender validador). |
| 2 | `02-A02-Workflow-Comparativa.md` | `pre-proyecto/Estudios/02-A02-Workflow-Comparativa.md` | Comparar herramientas de workflow para el motor de flujo del proceso | `02-Boceto_B09.md` | Evaluación de 4 herramientas: FlowCrafter, php-workflow, Pipeflow PHP, Workflow Engine Core. Comparativa de persistencia, etapas, configuración y casos de uso reales. Recomendación: Pipeflow PHP (mejor encaje global, casos reales con WordPress + IA). Workflow Engine Core descartado (versión alpha). |
| 3 | `03-Login-externo-WordPress.md` | `pre-proyecto/Estudios/03-Login-externo-WordPress.md` | Investigar mecanismos de autenticación de la WA contra WordPress | Ninguna | Investigación sobre validación de login desde WA externa usando sesión/cookie de WordPress. Patrones recomendados: endpoint REST mínimo `/wp-json/wa/v1/session` con `is_user_logged_in()`. Referencias a repositorios que implementan el patrón. Consideraciones técnicas: CORS, cookies cross-site, SameSite, nonces/CSRF. |
| 4 | `04-log-errores-traking.md` | `pre-proyecto/Estudios/04-log-errores-traking.md` | Investigar librerías PHP para logging, manejo de errores y tracking | Ninguna | Análisis de 13 repositorios: Monolog (logging PSR-3), NormalizedException, Symfony ErrorHandler, Symfony Workflow (estados), Symfony Messenger (retries), Chevere Workflow, OpenTelemetry, Sentry, Temporal SDK. Clasificación por capacidades: logging, manejo de errores, tracking de estados, retries, observabilidad. |

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
┌─────────────────────────────────────────────────────────────────────────┐
│                         FLUJO DE DEPENDENCIAS                           │
└─────────────────────────────────────────────────────────────────────────┘

pre-proyecto/
│
├── legado-obsoleto/
│   └── 01-Boceto_B08.md ─────────────────────────────────┐
│           │                                              │
│           ▼                                              │
├── 02-Boceto_B09.md ───────────────────────────────┐      │
│        │                                          │      │
│        ▼                                          │      │
├── 03-Boceto_B09-ACLARATIVO.md ◄───────────────────┼──────┘
│                                                   │
│                                                   │
├── Estudios/                                        │
│   ├── 01-A01-PHP-React-Framework-Analisis.md ◄────┤
│   ├── 02-A02-Workflow-Comparativa.md ◄────────────┤
│   ├── 03-Login-externo-WordPress.md               │
│   └── 04-log-errores-traking.md                   │
│                                                   │
│                                                   │
└── PyR/                                             │
    ├── 01-R01.md ◄─────────────────────────────────┘
    │        │
    │        ▼
    ├── 02-R01_r.md
    │        │
    │        ▼
    ├── 03-R02.md ◄──────────────────────────────────► Estudios/*
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
| 7 | `pre-proyecto/Estudios/01-A01-PHP-React-Framework-Analisis.md` | Decisión tecnológica: framework para la WA |
| 8 | `pre-proyecto/Estudios/02-A02-Workflow-Comparativa.md` | Decisión tecnológica: motor de workflow |
| 9 | `pre-proyecto/Estudios/03-Login-externo-WordPress.md` | Implementación: autenticación con WordPress |
| 10 | `pre-proyecto/Estudios/04-log-errores-traking.md` | Implementación: sistema de logging y errores |
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

---

*Última actualización: 28 de abril de 2026*
