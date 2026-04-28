# T02 — Sistema de Logging, Trazabilidad y Registro de Errores/Éxitos

---

## Índice de Contenido

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Requisitos del Sistema según Boceto_B09.md](#2-requisitos-del-sistema-según-boceto_b09md)
3. [Arquitectura Propuesta del Sistema de Logs](#3-arquitectura-propuesta-del-sistema-de-logs)
4. [Componentes del Sistema de Logging](#4-componentes-del-sistema-de-logging)
5. [Estructura de los Registros de Log](#5-estructura-de-los-registros-de-log)
6. [Niveles de Log y Categorización](#6-niveles-de-log-y-categorización)
7. [Trazabilidad de Ejecución](#7-trazabilidad-de-ejecución)
8. [Registro de Errores y Éxitos](#8-registro-de-errores-y-éxitos)
9. [Almacenamiento y Persistencia](#9-almacenamiento-y-persistencia)
10. [Visibilidad: Usuario vs Admin](#10-visibilidad-usuario-vs-admin)
11. [Herramientas y Librerías Recomendadas](#11-herramientas-y-librerías-recomendadas)
12. [Integración con el Flujo del Proyecto](#12-integración-con-el-flujo-del-proyecto)
13. [Referencia de Errores para el Usuario](#13-referencia-de-errores-para-el-usuario)
14. [Consultas y Análisis de Logs](#14-consultas-y-análisis-de-logs)
15. [Riesgos y Limitaciones](#15-riesgos-y-limitaciones)
16. [Recomendaciones de Implementación](#16-recomendaciones-de-implementación)

---

## 1. Resumen Ejecutivo

Este documento describe el diseño e integración de un sistema de logging, trazabilidad de ejecución y registro de errores y éxitos para el proyecto de automatización de productos WooCommerce descrito en `pre-proyecto/Boceto_B09.md`.

**Propósito del sistema:**
- Registrar la trayectoria completa de cada proceso desde inicio hasta fin
- Permitir reconstruir qué se hizo, cuándo, qué pasos se completaron, qué errores aparecieron
- Diferenciar visibilidad entre usuario operativo (limitada) y admin (completa)
- Conservar logs históricos para auditoría y diagnóstico
- Proporcionar referencias de error comprensibles para usuarios no técnicos

**Enfoque recomendado:** Sistema híbrido que combina:
- **Logging estructurado** (tipo Monolog) para registros técnicos
- **Tracking de estados** (tipo Symfony Workflow) para trayectoria de ejecución
- **Manejo de errores** (tipo NormalizedException) para consistencia en registros
- **Almacenamiento dual**: archivos para logs técnicos + base de datos para trazabilidad consultable

---

## 2. Requisitos del Sistema según Boceto_B09.md

### 2.1 Requisitos Funcionales

| Requisito | Descripción | Fuente B09 |
| --------- | ----------- | ---------- |
| **Log desde inicio a fin** | El log debe guardarse desde el clic en "Procesar Producto" paso a paso hasta el final | Sección 32 |
| **Trayectoria completa** | El log debe conservar la trayectoria tanto en éxito como en error | Sección 32 |
| **Identidad del usuario** | El log histórico debe registrar la identidad del usuario que ejecutó el proceso | Sección 32 |
| **Solo admin ve log completo** | Solo el admin podrá consultar el log completo; el usuario operativo no ve el log técnico | Sección 29 |
| **Usuario ve estado actual** | Al usuario solo se le muestra el nombre del paso/stage que empieza a procesarse | Sección 29 |
| **Referencia de error** | Si surge un error, el usuario verá un mensaje estándar + una referencia asociada al error o al log completo | Sección 29 |
| **Registro de errores siempre** | El error no debe desaparecer ni quedar oculto: debe registrarse siempre | Sección 31 |
| **Conservar según resultado** | Log se conserva en todos los casos; archivos se borran o conservan según resultado | Sección 31-32 |

### 2.2 Datos que el Log Debe Incluir

Según Boceto_B09.md sección 32, el log debe incluir:

| Dato | Descripción |
| ---- | ----------- |
| Usuario que ejecuta el proceso | Identidad del usuario (login, nombre visible, ID interno - por definir) |
| PDF procesado | Nombre del archivo PDF procesado |
| Pasos/estados recorridos | Secuencia de pasos ejecutados |
| Errores, si los hay | Detalles de errores encontrados |
| Resultado final | Éxito, rechazo, cancelación, fallo |
| Descarte si hubo rechazo | Indicación de descarte por parte del usuario |
| Cancelación | Diferenciada del rechazo/desaprobación |
| Error de guardado en WP/media | Si falló después de aprobación |
| Error API-WooCommerce | Si falló después de aprobación |

### 2.3 Qué debe permitir reconstruir el log

Según Boceto_B09.md sección 32:

- Qué se hizo
- Cuándo se hizo
- Qué pasos se completaron
- Qué errores aparecieron
- Qué reintentos se realizaron, si los hubo
- Dónde se detuvo el proceso, si falló
- Si terminó correctamente
- Qué resultado final tuvo

---

## 3. Arquitectura Propuesta del Sistema de Logs

### 3.1 Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           SISTEMA DE LOGGING                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐                   │
│  │   Componente │    │   Componente │    │   Componente │                   │
│  │   Logger     │    │   Tracker    │    │   Error      │                   │
│  │   (Monolog)  │    │   (Estados)  │    │   Handler    │                   │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘                   │
│         │                   │                   │                            │
│         └───────────────────┼───────────────────┘                            │
│                             │                                                │
│                    ┌────────▼────────┐                                       │
│                    │   Formateador   │                                       │
│                    │   de Logs       │                                       │
│                    └────────┬────────┘                                       │
│                             │                                                │
│         ┌───────────────────┼───────────────────┐                           │
│         │                   │                   │                            │
│         ▼                   ▼                   ▼                            │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐                       │
│  │   Archivo   │    │   Base de   │    │   Servicios │                       │
│  │   de Logs   │    │   Datos     │    │   Externos  │                       │
│  │   (.log)    │    │   (MySQL)   │    │   (Sentry)  │                       │
│  └─────────────┘    └─────────────┘    └─────────────┘                       │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Capas del Sistema

| Capa | Responsabilidad | Herramienta Sugerida |
| ---- | --------------- | -------------------- |
| **Captura** | Interceptar eventos, errores, cambios de estado | Error handlers + Instrumentación manual |
| **Formateo** | Estructurar datos para almacenamiento consistente | Formatters personalizados |
| **Enrutamiento** | Dirigir logs a diferentes destinos según nivel/tipo | Handlers de Monolog |
| **Almacenamiento** | Persistir logs en archivos y/o base de datos | Archivos + MySQL |
| **Consulta** | Permitir búsqueda, filtrado y análisis de logs | Consultas SQL + interfaces |

### 3.3 Flujo de Registro

```
Evento/Error → Captura → Enriquecimiento → Formateo → Enrutamiento → Almacenamiento
                    │            │              │            │
                    │            │              │            ├─→ Archivo técnico
                    │            │              ├─→ Nivel log
                    │            ├─→ Contexto (user_id, pipeline_id, step)
                    │            └─→ Timestamp
                    └─→ Tipo (info, warning, error, success)
```

---

## 4. Componentes del Sistema de Logging

### 4.1 Logger (Registro de Eventos)

**Propósito:** Registrar eventos puntuales durante la ejecución del proceso.

**Características requeridas:**
- Soporte para niveles de log (debug, info, warning, error, critical)
- Contexto enriquecido (user_id, pipeline_id, step, attempt)
- Múltiples handlers (archivo, database, external services)
- Formateo estructurado (JSON preferiblemente para análisis)

**Implementación recomendada:** Monolog (`monolog/monolog`)

**Justificación según `log-errores-traking.md`:**
- ID 1: "Implementa PSR-3, usa niveles PSR-3, soporta canales, stacks de handlers, procesadores, contexto y múltiples salidas"
- "Puede aportar logging estructurable por `pipeline_id`, etapa, job, intento y resultado usando contexto, procesadores y formatters"

**Ejemplo de configuración:**
```php
use Monolog\Logger;
use Monolog\Handler\StreamHandler;
use Monolog\Handler\DatabaseHandler;
use Monolog\Processor\UidProcessor;
use Monolog\Processor\IntrospectionProcessor;

$logger = new Logger('pipeline-processor');

// Handler para archivo (todos los niveles)
$fileHandler = new StreamHandler(
    '/var/log/pipeline/process-' . date('Y-m-d') . '.log',
    Logger::DEBUG
);

// Handler para base de datos (solo errores y críticos)
$dbHandler = new DatabaseHandler(
    $pdo,
    'pipeline_logs',
    Logger::ERROR
);

$logger->pushHandler($fileHandler);
$logger->pushHandler($dbHandler);

// Procesadores para contexto automático
$logger->pushProcessor(new UidProcessor());
$logger->pushProcessor(new IntrospectionProcessor());
```

### 4.2 Tracker (Seguimiento de Estados)

**Propósito:** Registrar la trayectoria de ejecución paso a paso.

**Características requeridas:**
- Registro de cada paso ejecutado
- Estados intermedios (pending, running, completed, failed, skipped, cancelled)
- Timestamp de cada transición
- Capacidad de consultar estado actual y histórico

**Implementación recomendada:** Sistema personalizado inspirado en Symfony Workflow

**Justificación según `log-errores-traking.md`:**
- ID 8 (Symfony Workflow): "Proporciona workflow y finite state machine; define procesos con lugares y transiciones"
- "Puede modelar estados del pipeline como lugares/transiciones: `pending`, `running`, `completed`, `failed`, `skipped`, `cancelled`"

**Estructura de tabla de tracking:**
```sql
CREATE TABLE pipeline_execution_tracking (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    execution_id VARCHAR(100) NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    pdf_nombre VARCHAR(255) NOT NULL,
    paso_nombre VARCHAR(100) NOT NULL,
    estado_anterior VARCHAR(50),
    estado_actual VARCHAR(50) NOT NULL,
    timestamp_inicio DATETIME,
    timestamp_fin DATETIME,
    duracion_segundos DECIMAL(10,3),
    resultado JSON,
    error_mensaje TEXT,
    error_codigo VARCHAR(50),
    reintentos INT DEFAULT 0,
    metadata JSON,
    INDEX idx_execution_id (execution_id),
    INDEX idx_user_id (user_id),
    INDEX idx_timestamp (timestamp_inicio)
);
```

### 4.3 Error Handler (Manejo de Errores)

**Propósito:** Capturar, normalizar y registrar errores de forma consistente.

**Características requeridas:**
- Captura de excepciones y errores PHP
- Normalización de mensajes de error
- Contexto separado del mensaje (para logging PSR-3)
- Integración con logger

**Implementación recomendada:** Wikimedia NormalizedException + Symfony ErrorHandler

**Justificación según `log-errores-traking.md`:**
- ID 2 (NormalizedException): "Define una interfaz y trait para excepciones PSR-3-friendly, con mensaje normalizado y contexto separado para logging"
- ID 3 (Symfony ErrorHandler): "Proporciona herramientas para gestionar errores y debugging; permite registrar ErrorHandler y envolver llamadas"

**Ejemplo de excepción normalizada:**
```php
use Wikimedia\NormalizedException\NormalizedExceptionTrait;

class PipelineExecutionException extends Exception implements \Wikimedia\NormalizedException\NormalizedExceptionInterface
{
    use NormalizedExceptionTrait;
    
    private string $errorCode;
    private string $stepName;
    private int $attempt;
    
    public function __construct(
        string $message,
        string $errorCode,
        string $stepName,
        int $attempt = 1,
        ?Throwable $previous = null
    ) {
        parent::__construct($message, 0, $previous);
        $this->errorCode = $errorCode;
        $this->stepName = $stepName;
        $this->attempt = $attempt;
        
        // Contexto separado para logging PSR-3
        $this->setNormalizedContext([
            'error_code' => $errorCode,
            'step_name' => $stepName,
            'attempt' => $attempt,
            'execution_id' => $executionId,
        ]);
    }
}
```

---

## 5. Estructura de los Registros de Log

### 5.1 Formato de Log Estandarizado

Cada entrada de log debe seguir esta estructura:

```json
{
  "timestamp": "2026-04-27T10:30:45.123Z",
  "level": "info|warning|error|critical|debug|success",
  "execution_id": "exec_abc123def456",
  "user_id": 123,
  "user_login": "admin",
  "pdf_nombre": "producto-incendios-001.pdf",
  "paso": "extraccion_texto",
  "estado_anterior": "pending",
  "estado_actual": "running",
  "mensaje": "Iniciando extracción de texto del PDF",
  "contexto": {
    "duracion_estimada_ms": 5000,
    "tamano_pdf_bytes": 1048576,
    "intentos_previos": 0
  },
  "error": null,
  "metadata": {
    "server": "prod-01",
    "php_version": "8.3.0",
    "memory_usage_mb": 45.2
  }
}
```

### 5.2 Campos Obligatorios

| Campo | Tipo | Descripción | Ejemplo |
| ----- | ---- | ----------- | ------- |
| `timestamp` | ISO 8601 | Fecha y hora del evento | `2026-04-27T10:30:45.123Z` |
| `level` | string | Nivel de severidad | `info`, `error`, `success` |
| `execution_id` | string | Identificador único del proceso | `exec_abc123` |
| `user_id` | int | ID del usuario que ejecuta | `123` |
| `paso` | string | Nombre del paso/stage | `extraccion_texto` |
| `estado_actual` | string | Estado después del evento | `running`, `completed` |
| `mensaje` | string | Descripción legible del evento | "Iniciando extracción" |

### 5.3 Campos Condicionales

| Campo | Cuándo incluir | Descripción |
| ----- | -------------- | ----------- |
| `error.codigo` | Solo en errores | Código de error estandarizado |
| `error.mensaje` | Solo en errores | Mensaje de error detallado |
| `error.stack_trace` | Solo en errores críticos | Stack trace completo |
| `contexto.reintentos` | Cuando hay reintento | Número de intentos realizados |
| `contexto.duracion_ms` | Al completar paso | Duración real del paso |
| `metadata.*` | Opcional | Información adicional de diagnóstico |

---

## 6. Niveles de Log y Categorización

### 6.1 Niveles de Log (PSR-3)

| Nivel | Cuándo usar | Ejemplo en proyecto |
| ----- | ----------- | ------------------- |
| **DEBUG** | Información detallada para debugging | "Contenido crudo extraído del PDF: 15000 caracteres" |
| **INFO** | Eventos normales de ejecución | "Inicio del proceso para PDF producto-001.pdf" |
| **NOTICE** | Eventos normales pero significativos | "Usuario aprobó formulario de revisión" |
| **WARNING** | Situaciones anómalas que no detienen el proceso | "Extracción de texto incompleta (85% del contenido)" |
| **ERROR** | Errores que afectan funcionalidad pero se pueden manejar | "Fallo en llamada a API de IA, reintentando (intento 2/3)" |
| **CRITICAL** | Errores críticos que requieren atención inmediata | "Fallo en guardado a base de datos después de 3 reintentos" |
| **ALERT** | Condiciones que requieren acción inmediata | "Servicio de IA no disponible por timeout múltiple" |
| **EMERGENCY** | Sistema inutilizable | "Base de datos inaccesible" |
| **SUCCESS** | (No PSR-3, pero útil) | "Producto creado exitosamente en WooCommerce" |

### 6.2 Categorías de Eventos

| Categoría | Descripción | Ejemplos |
| --------- | ----------- | -------- |
| **Inicio/Fin** | Eventos de comienzo y conclusión de proceso | `proceso_iniciado`, `proceso_completado`, `proceso_fallido` |
| **Transición de Estado** | Cambios de estado entre pasos | `estado_cambiado: pending → running` |
| **Ejecución de Paso** | Ejecución individual de cada stage | `step_ejecutado: extraccion_texto` |
| **Error** | Fallos de cualquier tipo | `error_extraccion`, `error_api_ia`, `error_api_woocommerce` |
| **Reintento** | Intentos posteriores tras fallo | `reintento_ejecutado: intento 2/3` |
| **Decisión Usuario** | Acciones del usuario | `usuario_aprobo`, `usuario_rechazo`, `usuario_cancelo` |
| **Integración** | Eventos de sistemas externos | `wordpress_guardado_ok`, `woocommerce_producto_creado` |

### 6.3 Códigos de Error Estandarizados

| Código | Categoría | Descripción | Acción recomendada |
| ------ | --------- | ----------- | ------------------ |
| `PDF_001` | Extracción | PDF no legible o corrupto | Solicitar nuevo PDF al usuario |
| `PDF_002` | Extracción | PDF ya procesado anteriormente | Mostrar advertencia, bloquear proceso |
| `IA_001` | IA | Timeout en llamada a API de IA | Reintentar con backoff |
| `IA_002` | IA | Respuesta inválida de IA | Registrar, notificar admin |
| `IA_003` | IA | Límite de tasa excedido | Esperar, reintentar más tarde |
| `WP_001` | WordPress | Fallo en guardado de texto | Reintentar, si persiste notificar admin |
| `WP_002` | WordPress | Fallo en guardado de media | Reintentar, verificar permisos |
| `WC_001` | WooCommerce | API no disponible | Reintentar con backoff exponencial |
| `WC_002` | WooCommerce | Datos inválidos para producto | Validar datos, notificar admin |
| `WC_003` | WooCommerce | Producto ya existe | Registrar, decidir si actualizar o saltar |
| `SYS_001` | Sistema | Error de base de datos | Notificar admin inmediatamente |
| `SYS_002` | Sistema | Espacio en disco insuficiente | Alerta crítica, detener procesos |
| `USR_001` | Usuario | Usuario canceló proceso | Registrar cancelación, limpiar recursos |
| `USR_002` | Usuario | Usuario rechazó resultado | Registrar rechazo, limpiar recursos |

---

## 7. Trazabilidad de Ejecución

### 7.1 Identificador Único de Ejecución

Cada proceso debe tener un identificador único que permita correlacionar todos los logs:

```php
// Generar execution_id al inicio del proceso
$executionId = 'exec_' . bin2hex(random_bytes(8));
// Ejemplo: exec_a1b2c3d4e5f6g7h8
```

**Características del execution_id:**
- Único globalmente
- Incluye prefijo identificable (`exec_`)
- Fácil de buscar en logs y base de datos
- Puede incluirse en mensajes de error al usuario

### 7.2 Estados del Proceso

Según Boceto_B09.md y el flujo documentado:

| Estado | Descripción | Cuándo se alcanza |
| ------ | ----------- | ----------------- |
| `pending` | Proceso creado, esperando inicio | Al hacer clic en "Procesar Producto" |
| `running` | Proceso en ejecución | Después de iniciar, antes de completar |
| `extracting` | Extrayendo texto del PDF | Durante extracción de contenido |
| `processing_ia` | Procesando con IA | Durante ejecuciones de IA |
| `awaiting_review` | Esperando revisión del usuario | Cuando resultados de IA están listos |
| `approved` | Usuario aprobó resultados | Después de aprobación del usuario |
| `rejected` | Usuario rechazó resultados | Después de rechazo del usuario |
| `cancelled` | Usuario canceló proceso | Durante ejecución, antes de revisión |
| `publishing` | Publicando en WooCommerce | Después de aprobación, durante API call |
| `completed` | Proceso completado exitosamente | Después de publicación exitosa en WooCommerce |
| `failed` | Proceso falló | Después de error no recuperable |
| `blocked` | Proceso bloqueado post-aprobación | Después de fallo en API WooCommerce (requiere admin) |

### 7.3 Diagrama de Transiciones de Estado

```
┌─────────┐
│ pending │
└────┬────┘
     │ usuario hace clic "Procesar Producto"
     ▼
┌─────────┐
│ running │
└────┬────┘
     │
     ├──────────────────┬──────────────────┐
     ▼                  ▼                  ▼
┌──────────┐    ┌──────────────┐    ┌──────────┐
│extracting│    │ processing_ia│    │ awaiting │
└────┬─────┘    └──────┬───────┘    │ _review  │
     │                 │             └────┬─────┘
     └────────┬────────┘                  │
              │                           ├─────────┬──────────┬─────────┐
              │                           ▼         ▼          ▼         ▼
              │                    ┌─────────┐ ┌────────┐ ┌────────┐ ┌────────┐
              │                    │ approved│ │rejected│ │cancelled│ │ pending│
              │                    └────┬────┘ └────────┘ └────────┘ └────────┘
              │                         │
              │                         ▼
              │                  ┌───────────┐
              │                  │ publishing│
              │                  └─────┬─────┘
              │                        │
              │           ┌────────────┼────────────┐
              │           ▼            ▼            ▼
              │    ┌──────────┐ ┌──────────┐ ┌──────────┐
              │    │completed │ │  failed  │ │ blocked  │
              │    └──────────┘ └──────────┘ └──────────┘
              │
              └─────────────────────────────────────┐
                                                    ▼
                                             ┌──────────┐
                                             │  failed  │
                                             └──────────┘
```

### 7.4 Registro de Cada Transición

Cada transición de estado debe registrarse:

```php
function registrarTransicionEstado(
    string $executionId,
    int $userId,
    string $pasoAnterior,
    string $pasoActual,
    string $estadoAnterior,
    string $estadoActual,
    ?array $metadata = null
): void {
    global $wpdb;
    
    $wpdb->insert(
        'pipeline_execution_tracking',
        [
            'execution_id' => $executionId,
            'user_id' => $userId,
            'paso_nombre' => $pasoActual,
            'estado_anterior' => $estadoAnterior,
            'estado_actual' => $estadoActual,
            'timestamp_inicio' => current_time('mysql'),
            'metadata' => json_encode($metadata ?? []),
        ]
    );
}
```

---

## 8. Registro de Errores y Éxitos

### 8.1 Registro de Errores

**Requisito de Boceto_B09.md sección 31:** "El error no debe desaparecer ni quedar oculto: debe registrarse siempre."

**Estructura de registro de error:**
```json
{
  "timestamp": "2026-04-27T10:35:22.456Z",
  "level": "error",
  "execution_id": "exec_abc123def456",
  "user_id": 123,
  "paso": "api_woocommerce",
  "estado_actual": "failed",
  "mensaje": "Fallo al crear producto en WooCommerce",
  "error": {
    "codigo": "WC_002",
    "mensaje": "Datos inválidos para producto: campo 'precio' requerido",
    "tipo": "PipelineExecutionException",
    "archivo": "/app/Controllers/WooCommerceController.php",
    "linea": 145,
    "stack_trace": "..."
  },
  "contexto": {
    "intentos": 1,
    "max_reintentos": 3,
    "producto_datos": {...}
  },
  "accion_recomendada": "Revisar datos de producto, reintentar o contactar admin"
}
```

### 8.2 Registro de Éxitos

**Estructura de registro de éxito:**
```json
{
  "timestamp": "2026-04-27T10:40:15.789Z",
  "level": "success",
  "execution_id": "exec_abc123def456",
  "user_id": 123,
  "paso": "api_woocommerce",
  "estado_actual": "completed",
  "mensaje": "Producto creado exitosamente en WooCommerce",
  "resultado": {
    "producto_id": 456,
    "producto_url": "https://tienda.com/producto/nuevo-producto",
    "sku": "PROD-001"
  },
  "contexto": {
    "duracion_total_segundos": 45.5,
    "pasos_ejecutados": 8,
    "pasos_fallidos": 0
  }
}
```

### 8.3 Errores por Tipo de Resultado

Según Boceto_B09.md sección 31:

| Resultado | Qué registrar en log |
| --------- | -------------------- |
| **Éxito en WooCommerce** | Log completo con resultado, producto_id, URL pública |
| **Fallo post-aprobación** | Log con error de API, archivos se mantienen en subcarpeta |
| **Rechazo del usuario** | Log con indicación de descarte por usuario, archivos se borran |
| **Cancelación** | Log diferenciado de rechazo, archivos se borran salvo log |
| **Fallo pre-aprobación** | Log con error, mensaje estándar al usuario |

---

## 9. Almacenamiento y Persistencia

### 9.1 Estrategia de Almacenamiento Dual

| Destino | Qué almacenar | Ventajas | Desventajas |
| ------- | ------------- | -------- | ----------- |
| **Archivos de texto** | Logs técnicos completos (todos los niveles) | Rápido, fácil de rotar, bajo costo | Difícil de consultar, sin estructura |
| **Base de datos (MySQL)** | Tracking de estados, errores, éxitos (nivel INFO+) | Consultable, estructurada, relacionable | Más lento, costo de almacenamiento |
| **Servicios externos (opcional)** | Errores críticos para monitoreo (Sentry) | Alertas, dashboards, integración | Costo, dependencia externa |

### 9.2 Estructura de Tabla de Logs en Base de Datos

```sql
CREATE TABLE pipeline_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    execution_id VARCHAR(100) NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    user_login VARCHAR(60),
    pdf_nombre VARCHAR(255) NOT NULL,
    timestamp DATETIME NOT NULL,
    nivel VARCHAR(20) NOT NULL,
    paso VARCHAR(100),
    estado_anterior VARCHAR(50),
    estado_actual VARCHAR(50),
    mensaje TEXT NOT NULL,
    error_codigo VARCHAR(50),
    error_mensaje TEXT,
    error_stack_trace TEXT,
    contexto JSON,
    metadata JSON,
    INDEX idx_execution_id (execution_id),
    INDEX idx_user_id (user_id),
    INDEX idx_timestamp (timestamp),
    INDEX idx_nivel (nivel),
    INDEX idx_estado (estado_actual),
    INDEX idx_error_codigo (error_codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 9.3 Política de Retención

| Tipo de log | Retención recomendada | Justificación |
| ----------- | --------------------- | ------------- |
| **Logs DEBUG** | 7 días | Solo para debugging inmediato |
| **Logs INFO** | 30 días | Trazabilidad operativa |
| **Logs WARNING** | 90 días | Análisis de tendencias |
| **Logs ERROR+** | 1 año | Auditoría, diagnóstico |
| **Logs de éxito completado** | 1 año | Trazabilidad de productos publicados |
| **Logs de procesos fallidos** | 1 año | Diagnóstico, mejora continua |

**Nota:** Boceto_B09.md no especifica política de retención. Esto queda como **pendiente para definir con el desarrollador** (sección 34.5).

### 9.4 Rotación de Logs

Para archivos de log:

```php
// Configuración recomendada de rotación
$rotationConfig = [
    'max_file_size_mb' => 100,      // Rotar cuando archivo alcanza 100MB
    'max_files' => 30,              // Mantener máximo 30 archivos rotados
    'compression' => 'gzip',        // Comprimir archivos antiguos
    'rotation_period' => 'daily',   // Rotar diariamente como mínimo
];
```

---

## 10. Visibilidad: Usuario vs Admin

### 10.1 Diferenciación de Visibilidad

Según Boceto_B09.md sección 29:

| Perfil | Qué ve | Qué no ve |
| ------ | ------ | --------- |
| **Usuario operativo** | Estado/paso actual, mensajes estándar, referencia de error | Log técnico completo, detalles de error, histórico |
| **Admin** | Histórico/log completo del proceso, todos los detalles | - |

### 10.2 Interfaz de Usuario para Logs

**Para usuario operativo:**
```
┌─────────────────────────────────────────────────────────────┐
│  Proceso: producto-incendios-001.pdf                        │
│  Estado: Procesando con IA...                               │
│                                                             │
│  Progreso:                                                  │
│  ✓ Login completado                                         │
│  ✓ PDF subido                                               │
│  ✓ Extracción de texto completada                           │
│  → Procesando con IA (paso actual)                          │
│  ○ Esperando revisión                                       │
│  ○ Publicando en WooCommerce                                │
│                                                             │
│  [Cancelar proceso]                                         │
└─────────────────────────────────────────────────────────────┘
```

**Para admin (vista de log completo):**
```
┌─────────────────────────────────────────────────────────────┐
│  Log Completo - exec_abc123def456                           │
│  Usuario: admin                                             │
│  PDF: producto-incendios-001.pdf                            │
│  Inicio: 2026-04-27 10:30:00                                │
│  Fin: 2026-04-27 10:35:45                                   │
│  Estado: completed                                          │
│                                                             │
│  [10:30:00.123] INFO  - Proceso iniciado                    │
│  [10:30:01.456] INFO  - PDF subido exitosamente             │
│  [10:30:02.789] INFO  - Extracción de texto iniciada        │
│  [10:30:15.012] INFO  - Texto extraído: 15000 caracteres    │
│  [10:30:16.345] INFO  - Procesando con IA (rol: extractor)  │
│  [10:32:45.678] INFO  - IA completó extracción              │
│  [10:32:46.901] INFO  - Usuario aprobó revisión             │
│  [10:32:47.234] INFO  - Guardando texto en WordPress        │
│  [10:32:48.567] INFO  - Guardando imágenes en media library │
│  [10:35:22.890] INFO  - Producto creado en WooCommerce #456 │
│  [10:35:45.123] SUCCESS - Proceso completado exitosamente   │
│                                                             │
│  [Descargar log completo] [Ver archivos asociados]          │
└─────────────────────────────────────────────────────────────┘
```

### 10.3 Referencia de Error para Usuario

Según Boceto_B09.md sección 29: "si surge un error, el usuario verá: un mensaje estándar; una referencia asociada al error o al log completo."

**Formato de referencia recomendado:**
```
┌─────────────────────────────────────────────────────────────┐
│  ⚠️ Error en el proceso                                     │
│                                                             │
│  Ha ocurrido un error durante el procesamiento.             │
│  Por favor, contacte al administrador del sistema           │
│  proporcionando la siguiente referencia:                    │
│                                                             │
│  Referencia: ERR-exec_abc123-20260427-103522                │
│                                                             │
│  [Volver al inicio]                                         │
└─────────────────────────────────────────────────────────────┘
```

**Estructura de referencia:**
- Prefijo: `ERR-` (indica error)
- Execution ID parcial: `exec_abc123` (para identificar proceso)
- Fecha: `20260427` (YYYYMMDD)
- Hora: `103522` (HHMMSS)

Esta referencia permite al admin buscar directamente el log en base de datos o archivos.

---

## 11. Herramientas y Librerías Recomendadas

Basado en `pre-proyecto/log-errores-traking.md`:

### 11.1 Logging (Principal Recomendación)

| Herramienta | Composer | Licencia | Por qué |
| ----------- | -------- | -------- | ------- |
| **Monolog** | `monolog/monolog` | MIT | Implementa PSR-3, múltiples handlers, contexto, formatters |

**Justificación:** ID 1 en `log-errores-traking.md`: "Puede aportar logging estructurable por `pipeline_id`, etapa, job, intento y resultado usando contexto, procesadores y formatters"

### 11.2 Manejo de Errores

| Herramienta | Composer | Licencia | Por qué |
| ----------- | -------- | -------- | ------- |
| **NormalizedException** | `wikimedia/normalized-exception` | MIT | Excepciones PSR-3-friendly con contexto separado |
| **Symfony ErrorHandler** | `symfony/error-handler` | MIT | Conversión/captura de errores PHP |

**Justificación:** 
- ID 2: "Puede servir para estandarizar excepciones de etapas del pipeline y registrar errores con contexto consistente"
- ID 3: "Puede centralizar la conversión/captura de errores PHP durante la ejecución"

### 11.3 Tracking de Estados (Opcional)

| Herramienta | Composer | Licencia | Por qué |
| ----------- | -------- | -------- | ------- |
| **Symfony Workflow** | `symfony/workflow` | MIT | Modelar estados como lugares/transiciones |

**Justificación:** ID 8: "Puede modelar estados del pipeline como lugares/transiciones: `pending`, `running`, `completed`, `failed`, `skipped`, `cancelled`"

**Limitación:** "Logging y manejo de errores: no verificado como capacidad principal"

### 11.4 Servicios Externos (Opcional)

| Herramienta | Composer | Licencia | Por qué |
| ----------- | -------- | -------- | ------- |
| **Sentry** | `sentry/sentry` | MIT | Tracking de errores con contexto, alertas |

**Justificación:** ID 12: "Puede capturar excepciones de etapas y adjuntar contexto como pipeline, job, step o attempt para análisis externo"

**Requisito:** "Requiere backend/DSN de Sentry para ser útil"

### 11.5 Stack Recomendado

```
Núcleo (obligatorio):
├── Monolog (logging)
└── NormalizedException (errores consistentes)

Opcional (según necesidades):
├── Symfony Workflow (si se quiere modelado formal de estados)
├── Sentry (si se quiere monitoreo externo de errores)
└── OpenTelemetry (si se quiere observabilidad distribuida)
```

---

## 12. Integración con el Flujo del Proyecto

### 12.1 Puntos de Instrumentación

Según el flujo de Boceto_B09.md sección 14, estos son los puntos donde se debe registrar log:

| Paso | Qué registrar | Nivel |
| ---- | ------------- | ----- |
| 1. Login del usuario | User login, session start | INFO |
| 2. Clic en "Procesar Producto" | execution_id generado, proceso iniciado | INFO |
| 3. Formulario para subir PDF | Formulario mostrado | DEBUG |
| 4. PDF subido | Nombre PDF, tamaño, validación | INFO |
| 5. Obtener nombre del archivo | Nombre normalizado | DEBUG |
| 6. Crear subcarpeta | Ruta de subcarpeta creada | INFO |
| 7. Guardar PDF en subcarpeta | Ruta completa, checksum | INFO |
| 8. Procesar PDF para obtener texto | Inicio extracción | INFO |
| 9. Guardar .TXT UTF-8 BOM | Tamaño texto, encoding | INFO |
| 10. Pasar .TXT a IA | Inicio procesamiento IA | INFO |
| 11. Ejecuciones de IA (cada rol) | Inicio/fin por rol, resultados | INFO |
| 12. Formulario de revisión | Usuario accede, ve resultados | INFO |
| 13. Usuario aprueba/rechaza/cancela | Decisión del usuario | NOTICE |
| 14. Guardar texto en WordPress | Inicio/fin guardado | INFO |
| 15. Guardar imágenes en media | Inicio/fin, IDs de media | INFO |
| 16. API WooCommerce | Inicio/fin, producto_id creado | INFO |
| 17. Resultado final | Éxito/fallo, URL producto o error | SUCCESS/ERROR |

### 12.2 Ejemplo de Instrumentación en Código

```php
class PipelineProcessor {
    private LoggerInterface $logger;
    private TrackingService $tracking;
    
    public function procesarPDF(string $pdfPath, int $userId): ExecutionResult {
        $executionId = $this->generarExecutionId();
        
        // Registrar inicio
        $this->logger->info('Proceso iniciado', [
            'execution_id' => $executionId,
            'user_id' => $userId,
            'pdf_path' => $pdfPath,
        ]);
        
        $this->tracking->registrarInicio($executionId, $userId, $pdfPath);
        
        try {
            // Paso 1: Extraer texto
            $this->tracking->cambiarEstado($executionId, 'extracting');
            $texto = $this->extraerTexto($pdfPath, $executionId);
            
            // Paso 2: Procesar con IA
            $this->tracking->cambiarEstado($executionId, 'processing_ia');
            $resultadosIA = $this->procesarConIA($texto, $executionId);
            
            // Paso 3: Esperar aprobación
            $this->tracking->cambiarEstado($executionId, 'awaiting_review');
            $aprobacion = $this->esperarAprobacion($executionId, $resultadosIA);
            
            if (!$aprobacion->aprobado) {
                $this->tracking->cambiarEstado($executionId, 'rejected');
                $this->logger->notice('Usuario rechazó resultados', [
                    'execution_id' => $executionId,
                    'razon' => $aprobacion->razon,
                ]);
                return ExecutionResult::rejected($executionId);
            }
            
            // Paso 4: Publicar en WooCommerce
            $this->tracking->cambiarEstado($executionId, 'publishing');
            $producto = $this->publicarEnWooCommerce($aprobacion->datos, $executionId);
            
            // Éxito
            $this->tracking->cambiarEstado($executionId, 'completed');
            $this->logger->success('Proceso completado exitosamente', [
                'execution_id' => $executionId,
                'producto_id' => $producto->id,
                'producto_url' => $producto->url,
            ]);
            
            return ExecutionResult::success($executionId, $producto);
            
        } catch (PipelineExecutionException $e) {
            // Error manejado
            $this->tracking->cambiarEstado($executionId, 'failed');
            $this->logger->error('Error en ejecución', [
                'execution_id' => $executionId,
                'error_codigo' => $e->getErrorCode(),
                'paso' => $e->getStepName(),
                'mensaje' => $e->getNormalizedMessage(),
                'contexto' => $e->getNormalizedContext(),
            ]);
            
            return ExecutionResult::failed($executionId, $e);
            
        } catch (Throwable $e) {
            // Error no esperado
            $this->tracking->cambiarEstado($executionId, 'failed');
            $this->logger->critical('Error crítico no esperado', [
                'execution_id' => $executionId,
                'exception' => get_class($e),
                'mensaje' => $e->getMessage(),
                'stack_trace' => $e->getTraceAsString(),
            ]);
            
            return ExecutionResult::failed($executionId, $e);
        }
    }
}
```

---

## 13. Referencia de Errores para el Usuario

### 13.1 Formato de Referencia

Según Boceto_B09.md sección 29, el usuario debe ver "una referencia asociada al error o al log completo".

**Formato recomendado:**
```
ERR-{execution_id_parcial}-{fecha}-{hora}
```

**Ejemplo:** `ERR-exec_abc123-20260427-103522`

### 13.2 Mensajes Estándar para Usuario

Según Boceto_B09.md sección 31:

| Situación | Mensaje estándar |
| --------- | ---------------- |
| **Fallo genérico** | "Error en el proceso. Avise al admin del sistema. Referencia: {referencia}" |
| **Fallo post-aprobación** | "Error al publicar en WooCommerce. Avise al admin del sistema. Referencia: {referencia}" |
| **Fallo de guardado WP** | "Error al guardar datos. Avise al admin del sistema. Referencia: {referencia}" |
| **Timeout** | "El proceso tardó demasiado. Intente nuevamente o avise al admin. Referencia: {referencia}" |

### 13.3 Búsqueda de Referencia por Admin

El admin debe poder buscar logs por referencia:

```sql
SELECT * FROM pipeline_logs 
WHERE execution_id LIKE '%abc123%'
  AND DATE(timestamp) = '2026-04-27'
ORDER BY timestamp ASC;
```

---

## 14. Consultas y Análisis de Logs

### 14.1 Consultas Comunes para Admin

**Ver todos los procesos de un usuario:**
```sql
SELECT execution_id, pdf_nombre, estado_actual, timestamp, resultado
FROM pipeline_logs
WHERE user_id = 123
  AND paso = 'proceso_iniciado'
ORDER BY timestamp DESC
LIMIT 50;
```

**Ver procesos fallidos hoy:**
```sql
SELECT execution_id, user_login, pdf_nombre, error_mensaje, timestamp
FROM pipeline_logs
WHERE estado_actual = 'failed'
  AND DATE(timestamp) = CURDATE()
ORDER BY timestamp DESC;
```

**Ver errores por código:**
```sql
SELECT error_codigo, COUNT(*) as cantidad, MAX(timestamp) as ultimo
FROM pipeline_logs
WHERE error_codigo IS NOT NULL
GROUP BY error_codigo
ORDER BY cantidad DESC;
```

**Ver duración promedio por paso:**
```sql
SELECT paso_nombre, 
       AVG(TIMESTAMPDIFF(SECOND, timestamp_inicio, timestamp_fin)) as duracion_promedio_seg,
       COUNT(*) as ejecuciones
FROM pipeline_execution_tracking
WHERE estado_actual = 'completed'
GROUP BY paso_nombre
ORDER BY ejecuciones DESC;
```

### 14.2 Métricas Derivadas de Logs

| Métrica | Cómo calcular | Utilidad |
| ------- | ------------- | -------- |
| **Tasa de éxito** | `(completed / total) * 100` | Calidad del proceso |
| **Tasa de error por paso** | `(errores en paso / total ejecuciones paso) * 100` | Identificar pasos problemáticos |
| **Duración promedio** | `AVG(timestamp_fin - timestamp_inicio)` | Performance del proceso |
| **Errores por usuario** | `COUNT(error) GROUP BY user_id` | Identificar problemas de uso |
| **Errores por tipo** | `COUNT(error) GROUP BY error_codigo` | Priorizar fixes |

---

## 15. Riesgos y Limitaciones

### 15.1 Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
| ------ | ------------ | ------- | ---------- |
| **Logs crecen indefinidamente** | Alta | Espacio en disco | Rotación automática, política de retención |
| **Base de datos de logs lenta** | Media | Performance consultas | Índices adecuados, particionamiento por fecha |
| **Información sensible en logs** | Media | Seguridad | No loggear passwords, tokens, datos personales |
| **Performance impactado por logging** | Baja | Velocidad proceso | Logging asíncrono, buffers |
| **Pérdida de logs si falla DB** | Baja | Trazabilidad | Logging dual (archivo + DB) |

### 15.2 Limitaciones del Enfoque

| Limitación | Descripción |
| ---------- | ----------- |
| **No es un APM completo** | No reemplaza herramientas de Application Performance Monitoring |
| **No hay correlación automática** | Requiere execution_id manual para correlacionar logs |
| **No hay alertas automáticas** | Requiere integración con servicios externos para alertas |
| **Retención no especificada en B09** | Boceto_B09.md no define política de retención (pendiente sección 34.5) |

### 15.3 Información No Disponible en Fuentes

| Información | Estado | Acción requerida |
| ----------- | ------ | ---------------- |
| **Política de retención de logs** | ❓ No especificada en B09 | Definir con desarrollador (sección 34.5) |
| **Ubicación exacta de logs** | ❓ No especificada en B09 | Definir con desarrollador |
| **Formato de referencia de error** | ❓ No especificado en B09 | Definir con desarrollador |
| **Identificador exacto de usuario** | ❓ No especificado en B09 (sección 32) | Definir: login, ID, nombre visible |

---

## 16. Recomendaciones de Implementación

### 16.1 Priorización

| Prioridad | Componente | Justificación |
| --------- | ---------- | ------------- |
| **1 (Crítica)** | Logger básico (Monolog) | Sin logging no hay trazabilidad |
| **2 (Crítica)** | Tracking de estados | Necesario para reconstruir trayectoria |
| **3 (Crítica)** | Error Handler consistente | Errores deben registrarse siempre |
| **4 (Alta)** | Almacenamiento en DB | Permite consultas y análisis |
| **5 (Alta)** | Referencia de error para usuario | Requisito de B09 sección 29 |
| **6 (Media)** | Rotación de logs | Evita crecimiento indefinido |
| **7 (Media)** | Integración con Sentry | Mejora diagnóstico de errores |
| **8 (Baja)** | OpenTelemetry | Observabilidad avanzada (opcional) |

### 16.2 Plan de Implementación

**Fase 1: Núcleo (3-5 días)**
- [ ] Instalar Monolog
- [ ] Configurar logger básico con handler de archivo
- [ ] Instrumentar puntos clave del flujo (inicio, fin, errores)
- [ ] Implementar execution_id

**Fase 2: Tracking (5-7 días)**
- [ ] Crear tabla de tracking en MySQL
- [ ] Implementar servicio de tracking de estados
- [ ] Instrumentar transiciones de estado
- [ ] Crear vista de admin para ver logs

**Fase 3: Errores (3-5 días)**
- [ ] Implementar NormalizedException
- [ ] Definir códigos de error estandarizados
- [ ] Implementar referencia de error para usuario
- [ ] Crear mensajes estándar de error

**Fase 4: Consultas y Análisis (3-5 días)**
- [ ] Crear vistas de consulta para admin
- [ ] Implementar búsqueda por referencia
- [ ] Crear métricas básicas (tasa de éxito, duración)
- [ ] Configurar rotación de logs

### 16.3 Decisiones Pendientes

Según Boceto_B09.md, estas decisiones quedan para el desarrollador:

| Decisión | Sección B09 | Impacto en logging |
| -------- | ----------- | ------------------ |
| **Ubicación exacta del log** | 34.5 | Define configuración de paths |
| **Formato de referencia de error** | 34.5 | Define cómo usuario reporta errores |
| **Identificador de usuario en log** | 32 | Define campo user_id/user_login |
| **Política de retención** | No especificada | Define cuánto espacio necesitará |
| **Qué detalle del log es visible** | 34.5 | Define filtros de visibilidad |

---

*Documento generado como referencia técnica para implementación del sistema de logging, trazabilidad y registro de errores/éxitos del proyecto*

*Fuentes:*
- *`pre-proyecto/Boceto_B09.md` (secciones 29, 31, 32, 34.5)*
- *`pre-proyecto/log-errores-traking.md` (hallazgos de herramientas)*
