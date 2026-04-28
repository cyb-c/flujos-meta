# T01 — Implementación de Autenticación WordPress para Web App Externa

---

## Índice de Contenido

1. [Resumen Ejecutivo](#1-resumen-ejecutivo)
2. [Descripción del Flujo de Autenticación Propuesto](#2-descripción-del-flujo-de-autenticación-propuesto)
3. [Rol de WordPress como Fuente de Verdad de la Sesión](#3-rol-de-wordpress-como-fuente-de-verdad-de-la-sesión)
4. [Rol de la Web App como Cliente que Consulta el Estado de Sesión](#4-rol-de-la-web-app-como-cliente-que-consulta-el-estado-de-sesión)
5. [Funcionamiento de la Llamada desde la Web App con `credentials: "include"`](#5-funcionamiento-de-la-llamada-desde-la-web-app-con-credentials-include)
6. [Funcionamiento del Endpoint en WordPress](#6-funcionamiento-del-endpoint-en-wordpress)
7. [Uso de `is_user_logged_in()` para Validar la Sesión](#7-uso-de-is_user_logged_in-para-validar-la-sesión)
8. [Respuestas Esperadas del Endpoint](#8-respuestas-esperadas-del-endpoint)
9. [Requisitos de Cookies](#9-requisitos-de-cookies)
10. [Requisitos de CORS](#10-requisitos-de-cors)
11. [Problemas con Dominios Distintos entre WordPress y la Web App](#11-problemas-con-dominios-distintos-entre-wordpress-y-la-web-app)
12. [Riesgos de Seguridad](#12-riesgos-de-seguridad)
13. [Limitaciones del Enfoque](#13-limitaciones-del-enfoque)
14. [Alternativas Posibles](#14-alternativas-posibles)
15. [Pruebas Técnicas Necesarias](#15-pruebas-técnicas-necesarias)
16. [Recomendación Final sobre Viabilidad](#16-recomendación-final-sobre-viabilidad)
17. [Anexo: Código de Referencia](#17-anexo-código-de-referencia)

---

## 1. Resumen Ejecutivo

Este documento describe la implementación técnica del flujo de autenticación entre la Web App (WA) externa y WordPress, según lo especificado en `pre-proyecto/Boceto_B09.md`.

**Enfoque seleccionado:** La WA no valida cookies directamente, sino que **pregunta a WordPress** y WordPress valida su propia sesión/cookie mediante un endpoint REST personalizado.

**Flujo resumido:**
1. La WA realiza una llamada HTTP a WordPress con `credentials: "include"`
2. WordPress recibe la petición con las cookies de sesión
3. WordPress ejecuta `is_user_logged_in()` para validar la sesión
4. WordPress responde `200` (autenticado) o `401` (no autenticado)
5. La WA confía en la respuesta de WordPress para conceder/denegar acceso

**Viabilidad:** ✅ **VIABLE** con condiciones técnicas específicas de configuración de cookies y CORS.

---

## 2. Descripción del Flujo de Autenticación Propuesto

### 2.1 Diagrama del Flujo

```
┌─────────────────┐                           ┌─────────────────┐
│   NAVEGADOR     │                           │   WEB APP (WA)  │
│   (Usuario)     │                           │   (Externa WP)  │
└────────┬────────┘                           └────────┬────────┘
         │                                             │
         │  1. Usuario inicia sesión en WordPress      │
         │     (wp-login.php o formulario custom)      │
         │                                             │
         │  2. WordPress establece cookies:            │
         │     - wordpress_[hash]                      │
         │     - wordpress_logged_in_[hash]            │
         │     - wp-settings-[user_id]                 │
         │                                             │
         │  3. Usuario navega a la WA                  │
         │     (misdominio.com/wa o wa.misdominio.com) │
         │                                             │
         │  4. WA carga interfaz de login              │
         │                                             │
         │  5. WA llama a endpoint WP con cookies      │
         │     fetch('https://wordpress/wp-json/       │
         │            wa/v1/session', {                │
         │       credentials: "include"                │
         │     })                                      │
         │                                             │
         ▼                                             ▼
┌─────────────────────────────────────────────────────────────┐
│                    WORDPRESS (Servidor)                     │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │  Endpoint: /wp-json/wa/v1/session                     │ │
│  │  Callback: permission_callback => is_user_logged_in   │ │
│  │                                                       │ │
│  │  Si is_user_logged_in() === true:                     │ │
│  │    → HTTP 200 { logged_in: true, user_id: 123 }       │ │
│  │  Si is_user_logged_in() === false:                    │ │
│  │    → HTTP 401 { logged_in: false }                    │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
         │                                             │
         │  6. WordPress responde con 200 o 401        │
         │                                             │
         │  7. WA procesa respuesta:                   │
         │     - 200 → Usuario autenticado, mostrar WA │
         │     - 401 → Mostrar formulario login WP     │
         │                                             │
         ▼                                             ▼
```

### 2.2 Secuencia de Operaciones

| Paso | Actor | Acción | Resultado Esperado |
| ---- | ----- | ------ | ------------------ |
| 1 | Usuario | Inicia sesión en WordPress | Cookies establecidas en navegador |
| 2 | Navegador | Almacena cookies de WordPress | Cookies disponibles para dominio WP |
| 3 | Usuario | Navega a la URL de la WA | WA se carga en navegador |
| 4 | WA | Renderiza interfaz inicial | UI de carga/login visible |
| 5 | WA (JS) | Ejecuta `fetch()` a endpoint WP con `credentials: "include"` | Petición HTTP con cookies enviadas |
| 6 | WordPress | Recibe petición, valida cookies | `is_user_logged_in()` ejecutado |
| 7 | WordPress | Responde HTTP 200 o 401 | Body JSON con estado de sesión |
| 8 | WA (JS) | Procesa respuesta | Decide mostrar WA o formulario login |
| 9 | Usuario | Interactúa con WA según estado | Acceso concedido o denegado |

---

## 3. Rol de WordPress como Fuente de Verdad de la Sesión

### 3.1 Responsabilidades de WordPress

WordPress actúa como **autoridad única** para validar la autenticación del usuario:

| Responsabilidad | Descripción |
| --------------- | ----------- |
| **Validar cookies de sesión** | WordPress verifica si las cookies recibidas son válidas y no han expirado |
| **Ejecutar `is_user_logged_in()`** | Función core que determina si el usuario actual tiene sesión activa |
| **Responder estado de autenticación** | Devuelve HTTP 200 (autenticado) o 401 (no autenticado) |
| **Proporcionar datos del usuario** | Opcionalmente devuelve user_id, roles, capacidades |
| **Gestionar expiración de sesión** | WordPress controla cuándo expira la sesión del usuario |

### 3.2 Funciones Core de WordPress Involucradas

| Función | Archivo Core | Propósito |
| ------- | ------------ | --------- |
| `is_user_logged_in()` | `wp-includes/pluggable.php` | Determina si el visitante actual está logueado |
| `wp_get_current_user()` | `wp-includes/pluggable.php` | Obtiene el objeto WP_User del usuario actual |
| `wp_validate_auth_cookie()` | `wp-includes/pluggable.php` | Valida cookie de autenticación, devuelve user_id |
| `wp_validate_logged_in_cookie()` | `wp-includes/pluggable.php` | Valida específicamente la cookie `logged_in` |

### 3.3 Por Qué WordPress Debe Validar (No la WA)

| Razón | Explicación |
| ----- | ----------- |
| **Seguridad** | WordPress conoce el formato interno de sus cookies, hashes, y tokens de sesión |
| **Mantenibilidad** | Si WordPress cambia el formato de cookies, solo WordPress necesita actualizarse |
| **Consistencia** | La misma lógica de autenticación se usa para WP admin, REST API, y WA |
| **No reinventar** | Evita duplicar lógica de validación de cookies en la WA |
| **Gestión de sesiones** | WordPress gestiona expiración, logout, y regeneración de sesiones |

---

## 4. Rol de la Web App como Cliente que Consulta el Estado de Sesión

### 4.1 Responsabilidades de la Web App

| Responsabilidad | Descripción |
| --------------- | ----------- |
| **Iniciar petición de validación** | La WA debe llamar al endpoint de WordPress para verificar sesión |
| **Enviar cookies correctamente** | Usar `credentials: "include"` en fetch para enviar cookies |
| **Interpretar respuesta** | Procesar HTTP 200 (éxito) o 401 (no autorizado) |
| **Gestionar estado de autenticación** | Mantener estado interno de si el usuario está autenticado |
| **Redirigir a login si es necesario** | Si 401, mostrar opción de login en WordPress |
| **Cerrar sesión** | Para logout, llamar a endpoint de logout o redirigir a `wp-login.php?action=logout` |

### 4.2 Flujo de Autenticación en la WA

```javascript
// Ejemplo simplificado de flujo en WA
async function verificarSesionWordPress() {
  try {
    const respuesta = await fetch('https://wordpress.com/wp-json/wa/v1/session', {
      method: 'GET',
      credentials: 'include',  // CRÍTICO: envía cookies
      headers: {
        'Accept': 'application/json'
      }
    });
    
    if (respuesta.status === 200) {
      const datos = await respuesta.json();
      // Usuario autenticado
      return {
        autenticado: true,
        userId: datos.user_id,
        roles: datos.roles
      };
    } else if (respuesta.status === 401) {
      // No autenticado
      return { autenticado: false };
    }
  } catch (error) {
    // Error de red o CORS
    console.error('Error verificando sesión:', error);
    return { autenticado: false, error: true };
  }
}
```

### 4.3 Gestión de Estado en la WA

| Estado | Descripción | Acción de la WA |
| ------ | ----------- | --------------- |
| **Verificando** | Llamada a WordPress en curso | Mostrar spinner/loading |
| **Autenticado** | WordPress respondió 200 | Mostrar interfaz de la WA |
| **No Autenticado** | WordPress respondió 401 | Mostrar botón "Iniciar sesión en WordPress" |
| **Error** | Fallo de red o CORS | Mostrar mensaje de error, reintentar |

---

## 5. Funcionamiento de la Llamada desde la Web App con `credentials: "include"`

### 5.1 La Opción `credentials` en Fetch API

La opción `credentials` controla si el navegador envía cookies en peticiones cross-origin:

| Valor | Comportamiento | Caso de Uso |
| ----- | -------------- | ----------- |
| `"same-origin"` | Envía cookies solo si el destino es el mismo origen | Por defecto en fetch |
| `"include"` | Envía cookies siempre, incluso cross-origin | **Necesario para este flujo** |
| `"omit"` | Nunca envía cookies | APIs públicas sin autenticación |

### 5.2 Sintaxis Correcta

```javascript
// ✅ CORRECTO: Envía cookies incluso cross-origin
fetch('https://wordpress.com/wp-json/wa/v1/session', {
  method: 'GET',
  credentials: 'include',  // ← CRÍTICO
  headers: {
    'Accept': 'application/json'
  }
});

// ❌ INCORRECTO: No envía cookies cross-origin (comportamiento por defecto)
fetch('https://wordpress.com/wp-json/wa/v1/session');

// ❌ INCORRECTO: Omite cookies explícitamente
fetch('https://wordpress.com/wp-json/wa/v1/session', {
  credentials: 'omit'
});
```

### 5.3 Comportamiento del Navegador

Cuando `credentials: "include"` se usa:

1. **El navegador busca cookies** que coincidan con el dominio de destino
2. **Verifica políticas de cookies:**
   - `Domain`: ¿La cookie es válida para este dominio?
   - `Path`: ¿La cookie es válida para este path?
   - `Secure`: ¿La petición es HTTPS? (requerido si Secure está seteado)
   - `SameSite`: ¿La petición es cross-site? (afecta envío de cookies)
3. **Envía cookies en header `Cookie`** de la petición HTTP
4. **Respuesta puede establecer nuevas cookies** en header `Set-Cookie`

### 5.4 Headers de Petición y Respuesta

**Petición desde WA a WordPress:**
```http
GET /wp-json/wa/v1/session HTTP/1.1
Host: wordpress.com
Cookie: wordpress_logged_in_abc123=usuario%7C1234567890%7Chash; wp-settings-1=setting1
Origin: https://wa.dominio.com
Referer: https://wa.dominio.com/
```

**Respuesta de WordPress (éxito):**
```http
HTTP/1.1 200 OK
Content-Type: application/json
Access-Control-Allow-Origin: https://wa.dominio.com
Access-Control-Allow-Credentials: true
Set-Cookie: wordpress_logged_in_abc123=...; expires=...; path=/; Secure; SameSite=None

{"logged_in": true, "user_id": 123, "roles": ["administrator"]}
```

**Respuesta de WordPress (no autenticado):**
```http
HTTP/1.1 401 Unauthorized
Content-Type: application/json
Access-Control-Allow-Origin: https://wa.dominio.com
Access-Control-Allow-Credentials: true

{"logged_in": false}
```

---

## 6. Funcionamiento del Endpoint en WordPress

### 6.1 Registro del Endpoint REST

El endpoint debe registrarse en WordPress usando `register_rest_route()`:

```php
<?php
/**
 * Plugin Name: WA Session Endpoint
 * Description: Endpoint para validar sesión de Web App externa
 * Version: 1.0.0
 */

// Evitar acceso directo
if (!defined('ABSPATH')) {
    exit;
}

// Registrar endpoint REST
add_action('rest_api_init', function() {
    register_rest_route('wa/v1', '/session', [
        'methods' => 'GET',
        'callback' => 'wa_validar_sesion_callback',
        'permission_callback' => '__return_true',  // Permitir acceso, validamos dentro
    ]);
});

// Callback del endpoint
function wa_validar_sesion_callback(WP_REST_Request $request) {
    // Validar si usuario está logueado
    if (is_user_logged_in()) {
        $usuario = wp_get_current_user();
        
        return new WP_REST_Response([
            'logged_in' => true,
            'user_id' => $usuario->ID,
            'user_login' => $usuario->user_login,
            'roles' => $usuario->roles,
        ], 200);
    }
    
    // No autenticado
    return new WP_REST_Response([
        'logged_in' => false,
    ], 401);
}
```

### 6.2 Ubicación del Código

| Opción | Descripción | Ventaja | Desventaja |
| ------ | ----------- | ------- | ---------- |
| **Plugin personalizado** | Crear plugin dedicado para endpoint | Aislado, activable/desactivable | Requiere gestión de plugin |
| **functions.php del tema** | Añadir código al tema activo | Rápido de implementar | Se pierde al cambiar tema |
| **Plugin de funcionalidad** | Plugin específico para customizaciones | Mejor práctica para código custom | Requiere crear plugin |

**Recomendación:** Usar **plugin personalizado** para aislar la funcionalidad.

### 6.3 Estructura del Plugin Recomendada

```
wp-content/plugins/wa-session-endpoint/
├── wa-session-endpoint.php      # Archivo principal del plugin
├── includes/
│   ├── class-wa-session-rest.php   # Clase del endpoint REST
│   └── functions.php               # Funciones helper
└── README.md
```

---

## 7. Uso de `is_user_logged_in()` para Validar la Sesión

### 7.1 Qué Hace `is_user_logged_in()`

```php
/**
 * Determina si el visitante actual está logueado.
 * 
 * @return bool True si el usuario está logueado, false si no.
 */
function is_user_logged_in() {
    $user = wp_get_current_user();
    return $user->exists();
}
```

**Fuente:** `wp-includes/pluggable.php` (WordPress Core)

### 7.2 Cómo Funciona Internamente

```
is_user_logged_in()
    ↓
wp_get_current_user()
    ↓
wp_get_current_user() inicializa usuario desde:
    - Cookie de sesión (wordpress_logged_in_[hash])
    - Filtros de autenticación
    ↓
wp_validate_auth_cookie() valida la cookie:
    - Verifica formato
    - Verifica expiración
    - Verifica hash y token
    ↓
Si válida: devuelve WP_User con user_id
Si inválida: devuelve WP_User sin ID (exists() = false)
    ↓
is_user_logged_in() retorna true/false
```

### 7.3 Cuándo se Ejecuta en el Ciclo de WordPress

| Momento | ¿`is_user_logged_in()` disponible? | Notas |
| ------- | ---------------------------------- | ----- |
| **Antes de `plugins_loaded`** | ⚠️ Parcial | Cookies pueden no estar procesadas |
| **Después de `plugins_loaded`** | ✅ Sí | Cookies validadas por WordPress |
| **En hook `rest_api_init`** | ✅ Sí | Momento correcto para registro REST |
| **En callback REST** | ✅ Sí | Cookies ya validadas, usuario disponible |
| **En `init` hook** | ✅ Sí | WordPress completamente cargado |

### 7.4 Ejemplo de Uso en Endpoint

```php
function wa_validar_sesion_callback(WP_REST_Request $request) {
    // is_user_logged_in() ya puede usarse aquí
    // WordPress ya procesó las cookies
    
    if (is_user_logged_in()) {
        // Usuario autenticado
        $usuario = wp_get_current_user();
        
        // Datos disponibles:
        // - $usuario->ID (user_id)
        // - $usuario->user_login
        // - $usuario->roles
        // - $usuario->capabilities
        // - $usuario->user_email
        // - etc.
        
        return new WP_REST_Response([
            'logged_in' => true,
            'user_id' => $usuario->ID,
            'user_login' => $usuario->user_login,
            'roles' => $usuario->roles,
            // No devolver email ni datos sensibles sin necesidad
        ], 200);
    }
    
    return new WP_REST_Response([
        'logged_in' => false,
    ], 401);
}
```

---

## 8. Respuestas Esperadas del Endpoint

### 8.1 Respuesta Exitosa (HTTP 200)

**Código de estado:** `200 OK`

**Body JSON:**
```json
{
  "logged_in": true,
  "user_id": 123,
  "user_login": "admin",
  "roles": ["administrator"]
}
```

**Headers:**
```http
Content-Type: application/json
Access-Control-Allow-Origin: https://wa.dominio.com
Access-Control-Allow-Credentials: true
```

### 8.2 Respuesta No Autenticado (HTTP 401)

**Código de estado:** `401 Unauthorized`

**Body JSON:**
```json
{
  "logged_in": false
}
```

**Headers:**
```http
Content-Type: application/json
Access-Control-Allow-Origin: https://wa.dominio.com
Access-Control-Allow-Credentials: true
```

### 8.3 Respuesta de Error (HTTP 500)

**Código de estado:** `500 Internal Server Error`

**Body JSON:**
```json
{
  "error": "internal_error",
  "message": "Error procesando la solicitud"
}
```

### 8.4 Tabla de Respuestas

| Estado HTTP | Significado | Acción de la WA |
| ----------- | ----------- | --------------- |
| `200 OK` | Usuario autenticado | Conceder acceso a la WA |
| `401 Unauthorized` | No autenticado | Mostrar login o redirigir a WordPress |
| `403 Forbidden` | Autenticado pero sin permisos | Mostrar mensaje de permisos insuficientes |
| `500 Internal Server Error` | Error en WordPress | Mostrar error, reintentar más tarde |
| `0` (Error de red) | CORS, red, o WordPress caído | Mostrar error de conexión |

---

## 9. Requisitos de Cookies

### 9.1 Cookies de WordPress

WordPress establece las siguientes cookies al iniciar sesión:

| Cookie | Propósito | Duración |
| ------ | --------- | -------- |
| `wordpress_[hash]` | Cookie de autenticación principal | 2 días (por defecto) |
| `wordpress_logged_in_[hash]` | Indica que el usuario está logueado | 2 días (por defecto) |
| `wp-settings-{user_id}` | Preferencias de usuario | 1 año |
| `wp-settings-time-{user_id}` | Timestamp de preferencias | 1 año |

**Nota:** `[hash]` es un hash único generado por WordPress basado en claves de seguridad.

### 9.2 Atributos de Cookies Críticos

| Atributo | Valor Recomendado | Razón |
| -------- | ----------------- | ----- |
| **Domain** | `.midominio.com` (con punto) | Permite subdominios compartidos |
| **Path** | `/` | Cookie disponible en todo el sitio |
| **Secure** | `true` (solo HTTPS) | Requerido para SameSite=None |
| **HttpOnly** | `true` | Previene acceso JavaScript (seguridad) |
| **SameSite** | `None` (cross-origin) o `Lax` (mismo sitio) | Controla envío cross-site |

### 9.3 Configuración SameSite

| Escenario | Valor SameSite | Comportamiento |
| --------- | -------------- | -------------- |
| **WA y WP mismo dominio** | `Lax` (por defecto) | Cookies se envían en navegación normal |
| **WA y WP subdominios distintos** | `None` + `Secure` | Cookies se envían cross-subdomain |
| **WA y WP dominios distintos** | `None` + `Secure` | Cookies se envían cross-domain (con CORS) |

### 9.4 Configuración para Subdominios

Si WA está en `wa.midominio.com` y WP en `midominio.com`:

```php
// En wp-config.php de WordPress
define('COOKIE_DOMAIN', '.midominio.com');  // ← Nota el punto al inicio
define('COOKIEPATH', '/');
define('SITECOOKIEPATH', '/');
```

**Efecto:** Las cookies serán válidas para todos los subdominios de `midominio.com`.

### 9.5 Configuración para Dominios Distintos

Si WA está en `wa-externa.com` y WP en `midominio.com`:

**Opción A: SameSite=None + Secure**
```php
// En functions.php o plugin personalizado
add_filter('secure_auth_cookie', '__return_true');
add_filter('auth_cookie_samesite', function() {
    return 'None';
});
```

**Requisitos:**
- ✅ HTTPS obligatorio en ambos dominios
- ✅ CORS configurado correctamente en WordPress
- ✅ Navegadores modernos soportan SameSite=None

**Opción B: Proxy de autenticación**
- WA no llama directamente a WP
- WA llama a endpoint proxy en mismo dominio
- Proxy reenvía a WP con cookies

---

## 10. Requisitos de CORS

### 10.1 Qué es CORS

**CORS (Cross-Origin Resource Sharing)** es un mecanismo de seguridad que controla si recursos de un origen pueden ser accedidos desde otro origen.

### 10.2 Headers CORS Necesarios en WordPress

| Header | Valor | Propósito |
| ------ | ----- | --------- |
| `Access-Control-Allow-Origin` | `https://wa.dominio.com` | Permite origen específico de la WA |
| `Access-Control-Allow-Credentials` | `true` | Permite envío de credenciales (cookies) |
| `Access-Control-Allow-Methods` | `GET, POST, OPTIONS` | Métodos HTTP permitidos |
| `Access-Control-Allow-Headers` | `Content-Type, Authorization` | Headers permitidos en petición |

### 10.3 Configuración CORS en WordPress

```php
// En plugin de endpoint REST
add_action('rest_api_init', function() {
    // Registrar endpoint
    register_rest_route('wa/v1', '/session', [
        'methods' => 'GET',
        'callback' => 'wa_validar_sesion_callback',
        'permission_callback' => '__return_true',
    ]);
});

// Añadir headers CORS a respuestas REST
add_filter('rest_pre_serve_request', function($value, $server, $request) {
    $origin = $request->get_header('Origin');
    
    // Lista blanca de orígenes permitidos
    $origenes_permitidos = [
        'https://wa.dominio.com',
        'https://wa-externa.com'
    ];
    
    if (in_array($origin, $origenes_permitidos)) {
        header('Access-Control-Allow-Origin: ' . $origin);
        header('Access-Control-Allow-Credentials: true');
        header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, Authorization');
    }
    
    return $value;
}, 10, 3);

// Manejar preflight OPTIONS
add_action('rest_api_init', function() {
    register_rest_route('wa/v1', '/session', [
        'methods' => 'OPTIONS',
        'callback' => function() {
            return new WP_REST_Response(null, 200);
        },
        'permission_callback' => '__return_true',
    ]);
});
```

### 10.4 Petición Preflight (OPTIONS)

El navegador puede enviar una petición `OPTIONS` antes de la petición real:

```http
OPTIONS /wp-json/wa/v1/session HTTP/1.1
Host: wordpress.com
Origin: https://wa.dominio.com
Access-Control-Request-Method: GET
Access-Control-Request-Headers: Content-Type
```

WordPress debe responder:
```http
HTTP/1.1 200 OK
Access-Control-Allow-Origin: https://wa.dominio.com
Access-Control-Allow-Credentials: true
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type
```

---

## 11. Problemas con Dominios Distintos entre WordPress y la Web App

### 11.1 Escenarios Posibles

| Escenario | WA | WordPress | Viabilidad | Complejidad |
| --------- | -- | --------- | ---------- | ----------- |
| **Mismo dominio** | `midominio.com/wa` | `midominio.com` | ✅ Alta | Baja |
| **Subdominios** | `wa.midominio.com` | `midominio.com` | ✅ Alta | Media (COOKIE_DOMAIN) |
| **Dominios distintos** | `wa-externa.com` | `midominio.com` | ⚠️ Media | Alta (CORS + SameSite) |
| **Dominios distintos + HTTP** | `http://wa-externa.com` | `https://midominio.com` | ❌ Baja | Muy alta (no recomendado) |

### 11.2 Problemas Comunes y Soluciones

| Problema | Causa | Solución |
| -------- | ----- | -------- |
| **Cookies no se envían** | SameSite=Lax por defecto | Configurar SameSite=None + Secure |
| **CORS bloquea petición** | Header Access-Control-Allow-Origin faltante | Configurar CORS en WordPress |
| **Cookies no se reciben** | Dominio de cookie no coincide | Configurar COOKIE_DOMAIN en wp-config.php |
| **Error de mixed content** | WA en HTTP, WP en HTTPS | Usar HTTPS en ambos dominios |
| **Navegador bloquea cookies third-party** | Política del navegador | Usar mismo dominio o subdominios |

### 11.3 Configuración para Subdominios (Recomendado)

**wp-config.php en WordPress:**
```php
// Permitir cookies en todos los subdominios
define('COOKIE_DOMAIN', '.midominio.com');  // ← Punto al inicio es CRÍTICO
define('COOKIEPATH', '/');
define('SITECOOKIEPATH', '/');
define('COOKIEHASH', '');  // WordPress generará hash automáticamente
```

**WA en `wa.midominio.com`:**
```javascript
fetch('https://midominio.com/wp-json/wa/v1/session', {
    credentials: 'include',
    headers: {
        'Accept': 'application/json'
    }
});
```

### 11.4 Configuración para Dominios Distintos (Complejo)

**WordPress (midominio.com):**
```php
// Forzar SameSite=None para cookies de autenticación
add_filter('secure_auth_cookie', '__return_true');
add_filter('auth_cookie_samesite', function() {
    return 'None';
});

// CORS para dominio específico de WA
add_filter('rest_pre_serve_request', function($value, $server, $request) {
    $origin = $request->get_header('Origin');
    if ($origin === 'https://wa-externa.com') {
        header('Access-Control-Allow-Origin: ' . $origin);
        header('Access-Control-Allow-Credentials: true');
    }
    return $value;
}, 10, 3);
```

**WA (wa-externa.com):**
```javascript
fetch('https://midominio.com/wp-json/wa/v1/session', {
    credentials: 'include',  // ← Requiere CORS + SameSite=None
    headers: {
        'Accept': 'application/json'
    }
});
```

---

## 12. Riesgos de Seguridad

### 12.1 Riesgos Identificados

| Riesgo | Probabilidad | Impacto | Mitigación |
| ------ | ------------ | ------- | ---------- |
| **CSRF (Cross-Site Request Forgery)** | Media | Alto | Usar nonces para acciones que modifiquen datos |
| **XSS (Cross-Site Scripting)** | Media | Alto | Sanitizar outputs, usar esc_html(), esc_url() |
| **Cookie hijacking** | Baja | Crítico | HTTPS obligatorio, HttpOnly, Secure flags |
| **Session fixation** | Baja | Alto | Regenerar session ID tras login |
| **CORS misconfiguration** | Media | Alto | Lista blanca estricta de orígenes, no usar `*` |
| **Información de usuario expuesta** | Media | Medio | Devolver solo datos necesarios (user_id, roles) |

### 12.2 Nonces para Acciones que Modifican Datos

Para operaciones GET (como validar sesión), nonces no son estrictamente necesarios. Pero para POST/PUT/DELETE:

```php
// En WordPress, generar nonce
$nonce = wp_create_nonce('wa_session_nonce');

// En WA, enviar nonce en header
fetch('https://wordpress.com/wp-json/wa/v1/accion', {
    method: 'POST',
    credentials: 'include',
    headers: {
        'Content-Type': 'application/json',
        'X-WP-Nonce': nonce  // ← Nonce en header
    },
    body: JSON.stringify(datos)
});

// En WordPress, verificar nonce
register_rest_route('wa/v1', '/accion', [
    'methods' => 'POST',
    'callback' => function($request) {
        $nonce = $request->get_header('X-WP-Nonce');
        if (!wp_verify_nonce($nonce, 'wa_session_nonce')) {
            return new WP_Error('invalid_nonce', 'Nonce inválido', ['status' => 403]);
        }
        // Procesar acción...
    },
    'permission_callback' => 'is_user_logged_in',
]);
```

### 12.3 Lista de Verificación de Seguridad

- [ ] HTTPS obligatorio en WordPress y WA
- [ ] Cookies con flag Secure
- [ ] Cookies con flag HttpOnly
- [ ] SameSite configurado apropiadamente
- [ ] CORS con lista blanca de orígenes (no `*`)
- [ ] Nonces para acciones que modifican datos
- [ ] Sanitización de outputs en WordPress
- [ ] No devolver datos sensibles (email, password hash)
- [ ] Rate limiting en endpoint REST
- [ ] Logging de intentos de acceso fallidos

---

## 13. Limitaciones del Enfoque

### 13.1 Limitaciones Técnicas

| Limitación | Descripción | Impacto |
| ---------- | ----------- | ------- |
| **Dependencia de cookies** | Requiere que navegador acepte cookies | Navegadores con cookies bloqueadas no funcionan |
| **Políticas de navegadores** | Chrome/Firefox/Safari tienen políticas distintas de SameSite | Comportamiento puede variar entre navegadores |
| **Requiere HTTPS** | SameSite=None requiere Secure flag | No funciona en HTTP (excepto localhost) |
| **Dominios distintos complejos** | Configuración CORS + SameSite es compleja | Mayor superficie de error |
| **Sin autenticación server-to-server** | Solo funciona con navegador involucrado | APIs backend no pueden usar este método |

### 13.2 Limitaciones Funcionales

| Limitación | Descripción |
| ---------- | ----------- |
| **Sesión expira** | Cookies de WordPress expiran (2 días por defecto) |
| **Logout en WP afecta WA** | Si usuario hace logout en WordPress, WA también pierde sesión |
| **No hay SSO real** | Es validación de sesión, no Single Sign-On completo |
| **Depende de WordPress disponible** | Si WordPress cae, WA no puede validar usuarios |

### 13.3 Limitaciones de Navegadores

| Navegador | Política SameSite | Impacto |
| --------- | ----------------- | ------- |
| **Chrome 80+** | SameSite=Lax por defecto | Requiere SameSite=None explícito para cross-site |
| **Firefox 80+** | SameSite=Lax por defecto | Similar a Chrome |
| **Safari 13+** | ITP (Intelligent Tracking Prevention) | Puede bloquear cookies third-party después de 24h |
| **Safari 14+** | ETP (Enhanced Tracking Prevention) | Restricciones adicionales a cookies cross-site |

---

## 14. Alternativas Posibles

### 14.1 Alternativa 1: JWT (JSON Web Tokens)

**Flujo:**
1. Usuario login en WordPress
2. WordPress genera JWT y lo devuelve
3. WA almacena JWT (localStorage)
4. WA envía JWT en header `Authorization: Bearer {token}`
5. WordPress valida JWT en cada petición

**Ventajas:**
- ✅ No depende de cookies
- ✅ Funciona mejor cross-domain
- ✅ Stateless (WordPress no necesita guardar sesión)

**Desventajas:**
- ❌ Requiere plugin JWT en WordPress
- ❌ JWT almacenado en localStorage es vulnerable a XSS
- ❌ Más complejo de implementar

**Plugins disponibles:**
- `enonic/wp-jwt`
- `wp-rest-jwt-authentication`

### 14.2 Alternativa 2: Application Passwords (WordPress 5.6+)

**Flujo:**
1. Usuario genera Application Password en WordPress
2. WA usa username + application password
3. WA envía en header `Authorization: Basic base64(username:password)`

**Ventajas:**
- ✅ Nativo en WordPress 5.6+
- ✅ Seguro (passwords con propósito específico)
- ✅ Revocable individualmente

**Desventajas:**
- ❌ Requiere acción manual del usuario (generar password)
- ❌ No es transparente para el usuario
- ❌ No es adecuado para usuarios no técnicos

### 14.3 Alternativa 3: Proxy de Autenticación

**Flujo:**
1. WA tiene endpoint propio `/api/auth/check`
2. WA llama a su propio endpoint (same-origin)
3. Proxy llama a WordPress server-to-server
4. Proxy devuelve resultado a WA

**Ventajas:**
- ✅ Sin problemas de CORS
- ✅ Sin problemas de cookies cross-origin
- ✅ Control total sobre autenticación

**Desventajas:**
- ❌ Más complejidad (proxy adicional)
- ❌ Proxy debe gestionar somehow las credenciales
- ❌ Latencia añadida

### 14.4 Alternativa 4: OAuth 2.0 / OpenID Connect

**Flujo:**
1. WA redirige usuario a WordPress para login
2. WordPress autentica y redirige a WA con código
3. WA intercambia código por token de acceso
4. WA usa token para peticiones posteriores

**Ventajas:**
- ✅ Estándar industrial
- ✅ Seguro y robusto
- ✅ Soporte para múltiples aplicaciones

**Desventajas:**
- ❌ Complejidad alta de implementación
- ❌ Requiere plugin OAuth en WordPress
- ❌ Overkill para caso de uso simple

### 14.5 Tabla Comparativa

| Alternativa | Complejidad | Seguridad | Cross-Domain | Recomendado para |
| ----------- | ----------- | --------- | ------------ | ---------------- |
| **Cookies + REST (este doc)** | Baja | Media-Alta | ⚠️ Complejo | WA y WP mismo dominio/subdominios |
| **JWT** | Media | Media | ✅ Bueno | Dominios distintos, APIs |
| **Application Passwords** | Baja | Alta | ✅ Bueno | Integraciones backend, no usuarios finales |
| **Proxy** | Media | Alta | ✅ Bueno | Cuando CORS es problemático |
| **OAuth 2.0** | Alta | Alta | ✅ Excelente | Múltiples aplicaciones, SSO real |

---

## 15. Pruebas Técnicas Necesarias

### 15.1 Checklist de Pruebas

| # | Prueba | Escenario | Resultado Esperado |
| - | ------ | --------- | ------------------ |
| 1 | Login en WordPress | Usuario inicia sesión en WordPress | Cookies establecidas |
| 2 | Navegar a WA | Usuario va a WA después de login | WA detecta sesión automáticamente |
| 3 | Endpoint REST 200 | WA llama a `/wp-json/wa/v1/session` con sesión válida | HTTP 200 + user_id |
| 4 | Endpoint REST 401 | WA llama sin sesión o con sesión expirada | HTTP 401 |
| 5 | CORS mismo origen | WA y WP mismo dominio | Petición funciona sin CORS especial |
| 6 | CORS subdominios | WA en `wa.dominio.com`, WP en `dominio.com` | Petición funciona con CORS configurado |
| 7 | CORS dominios distintos | WA en `wa-externa.com`, WP en `dominio.com` | Petición funciona con CORS + SameSite=None |
| 8 | Logout en WordPress | Usuario hace logout en WordPress | WA detecta sesión inválida en siguiente petición |
| 9 | Expiración de sesión | Esperar 2 días (o forzar expiración) | WA detecta sesión expirada |
| 10 | Navegador incógnito | WA en ventana incógnito | Sesión no detectada (cookies no persistentes) |
| 11 | HTTPS requerido | Intentar con HTTP | Cookies Secure no se envían |
| 12 | CSRF con nonce | POST sin nonce | WordPress rechaza petición (403) |

### 15.2 Script de Prueba (WA)

```javascript
// test-auth.js - Script para probar autenticación desde WA

async function testAuth() {
    console.log('=== Prueba de Autenticación WordPress ===');
    
    // Prueba 1: Verificar sesión
    console.log('1. Verificando sesión...');
    const respuesta = await fetch('https://wordpress.com/wp-json/wa/v1/session', {
        credentials: 'include',
        headers: {
            'Accept': 'application/json'
        }
    });
    
    console.log('   Status:', respuesta.status);
    console.log('   Headers CORS:', respuesta.headers.get('Access-Control-Allow-Origin'));
    console.log('   Headers Credentials:', respuesta.headers.get('Access-Control-Allow-Credentials'));
    
    const datos = await respuesta.json();
    console.log('   Body:', datos);
    
    if (respuesta.status === 200) {
        console.log('   ✅ Usuario autenticado:', datos.user_login);
    } else if (respuesta.status === 401) {
        console.log('   ❌ No autenticado');
    } else {
        console.log('   ⚠️ Estado inesperado:', respuesta.status);
    }
    
    // Prueba 2: Verificar cookies enviadas
    console.log('2. Verificando cookies...');
    // Nota: No podemos ver cookies directamente por seguridad
    // Pero si la petición funcionó, las cookies se enviaron
    
    console.log('=== Fin de Prueba ===');
}

// Ejecutar prueba
testAuth();
```

### 15.3 Herramientas de Depuración

| Herramienta | Uso |
| ----------- | --- |
| **Chrome DevTools → Network** | Ver peticiones, headers, cookies enviadas/recibidas |
| **Chrome DevTools → Application → Cookies** | Ver cookies almacenadas por dominio |
| **curl** | Probar endpoint REST manualmente |
| **Postman** | Probar endpoint con diferentes configuraciones |
| **WordPress Debug Bar** | Ver queries, hooks, errores en WordPress |

---

## 16. Recomendación Final sobre Viabilidad

### 16.1 Viabilidad General

| Criterio | Evaluación | Justificación |
| -------- | ---------- | ------------- |
| **Viabilidad técnica** | ✅ **ALTA** | La tecnología existe y está probada |
| **Complejidad de implementación** | ✅ **BAJA-MEDIA** | Endpoint simple, CORS requiere atención |
| **Seguridad** | ✅ **ADECUADA** | Con HTTPS + CORS + nonces es seguro |
| **Mantenibilidad** | ✅ **ALTA** | Código simple, dependiente de WordPress core |
| **Compatibilidad navegadores** | ✅ **ALTA** | Todos navegadores modernos soportan fetch + credentials |

### 16.2 Condiciones para Éxito

El enfoque es **VIABLE** bajo las siguientes condiciones:

1. ✅ **HTTPS obligatorio** en WordPress y Web App
2. ✅ **Mismo dominio o subdominios** preferiblemente (evita complejidad cross-domain)
3. ✅ **CORS configurado correctamente** con lista blanca de orígenes
4. ✅ **Cookies SameSite configuradas** apropiadamente para el escenario
5. ✅ **Nonces para acciones que modifican datos** (POST, PUT, DELETE)
6. ✅ **Plugin personalizado en WordPress** para endpoint REST (no hardcodear en tema)
7. ✅ **Logging de intentos fallidos** para detectar problemas de autenticación

### 16.3 Recomendación de Implementación

**Fase 1: Prototipo (1-2 días)**
- [ ] Crear plugin básico con endpoint `/wp-json/wa/v1/session`
- [ ] Implementar callback que usa `is_user_logged_in()`
- [ ] Probar desde mismo dominio (sin CORS complejo)

**Fase 2: CORS y Subdominios (2-3 días)**
- [ ] Configurar CORS para origen de WA
- [ ] Configurar `COOKIE_DOMAIN` si usa subdominios
- [ ] Probar desde subdominio de WA

**Fase 3: Dominios Distintos (si necesario, 3-5 días)**
- [ ] Configurar SameSite=None + Secure
- [ ] Configurar CORS estricto con lista blanca
- [ ] Probar exhaustivamente en múltiples navegadores

**Fase 4: Seguridad y Producción (2-3 días)**
- [ ] Implementar nonces para acciones POST/PUT/DELETE
- [ ] Añadir rate limiting al endpoint
- [ ] Configurar logging de intentos fallidos
- [ ] Revisión de seguridad del código

### 16.4 Decisión Recomendada

**PROCEDER** con el enfoque de **cookies + endpoint REST personalizado** porque:

1. ✅ Es el enfoque **más simple** que cumple los requisitos
2. ✅ **No requiere plugins adicionales** en WordPress (solo código custom)
3. ✅ **Mantiene WordPress como fuente de verdad** de autenticación
4. ✅ **Compatible con Boceto_B09.md** que especifica este enfoque
5. ✅ **Baja complejidad** comparado con JWT, OAuth, u otras alternativas

**Reservar alternativas** (JWT, OAuth) solo si:
- Dominios distintos causan problemas insuperables
- Se requiere autenticación server-to-server en el futuro
- Se necesita SSO real con múltiples aplicaciones

---

## 17. Anexo: Código de Referencia

### 17.1 Plugin Completo para Endpoint REST

```php
<?php
/**
 * Plugin Name: WA Session Endpoint
 * Plugin URI: https://midominio.com
 * Description: Endpoint REST para validar sesión de Web App externa
 * Version: 1.0.0
 * Author: Tu Nombre
 * License: GPL v2 or later
 * Text Domain: wa-session-endpoint
 */

// Evitar acceso directo
if (!defined('ABSPATH')) {
    exit;
}

// Registrar endpoint REST
add_action('rest_api_init', 'wa_register_session_endpoint');

function wa_register_session_endpoint() {
    register_rest_route('wa/v1', '/session', [
        'methods' => 'GET',
        'callback' => 'wa_validar_sesion_callback',
        'permission_callback' => '__return_true',
    ]);
    
    // Endpoint para preflight OPTIONS
    register_rest_route('wa/v1', '/session', [
        'methods' => 'OPTIONS',
        'callback' => 'wa_options_callback',
        'permission_callback' => '__return_true',
    ]);
}

// Callback del endpoint
function wa_validar_sesion_callback(WP_REST_Request $request) {
    if (is_user_logged_in()) {
        $usuario = wp_get_current_user();
        
        return new WP_REST_Response([
            'logged_in' => true,
            'user_id' => $usuario->ID,
            'user_login' => $usuario->user_login,
            'roles' => $usuario->roles,
        ], 200);
    }
    
    return new WP_REST_Response([
        'logged_in' => false,
    ], 401);
}

// Callback para preflight OPTIONS
function wa_options_callback(WP_REST_Request $request) {
    return new WP_REST_Response(null, 200);
}

// Añadir headers CORS
add_filter('rest_pre_serve_request', 'wa_cors_headers', 10, 3);

function wa_cors_headers($value, $server, $request) {
    $origin = $request->get_header('Origin');
    
    // Lista blanca de orígenes permitidos
    $origenes_permitidos = [
        'https://wa.midominio.com',
        'https://wa-externa.com',
    ];
    
    if (in_array($origin, $origenes_permitidos)) {
        header('Access-Control-Allow-Origin: ' . esc_url($origin));
        header('Access-Control-Allow-Credentials: true');
        header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
        header('Access-Control-Allow-Headers: Content-Type, Authorization, X-WP-Nonce');
    }
    
    return $value;
}
```

### 17.2 Configuración wp-config.php para Subdominios

```php
/**
 * Configuración de cookies para subdominios
 * Colocar ANTES de "That's all, stop editing!"
 */

// Permitir cookies en todos los subdominios
define('COOKIE_DOMAIN', '.midominio.com');  // ← Punto al inicio es CRÍTICO
define('COOKIEPATH', '/');
define('SITECOOKIEPATH', '/');

// Forzar HTTPS para cookies (requerido para SameSite=None)
define('FORCE_SSL_ADMIN', true);
```

### 17.3 Funciones.php para SameSite=None

```php
/**
 * Configurar SameSite=None para cookies de autenticación
 * Usar solo si WA y WordPress están en dominios distintos
 * Colocar en functions.php del tema o plugin personalizado
 */

// Forzar flag Secure en cookies
add_filter('secure_auth_cookie', '__return_true');
add_filter('auth_cookie_samesite', function() {
    return 'None';
});

// Alternativa: hook directo en setcookie
add_action('set_auth_cookie', function($auth_cookie, $expire, $expiration, $user_id, $scheme, $token) {
    // Modificar cookie para SameSite=None
    // Esto es más complejo y generalmente no es necesario
}, 10, 6);
```

### 17.4 Fetch desde Web App (JavaScript/TypeScript)

```typescript
// services/auth.ts

interface AuthStatus {
    authenticated: boolean;
    userId?: number;
    userLogin?: string;
    roles?: string[];
    error?: boolean;
}

export async function verificarSesionWordPress(): Promise<AuthStatus> {
    try {
        const respuesta = await fetch('https://wordpress.com/wp-json/wa/v1/session', {
            method: 'GET',
            credentials: 'include',  // CRÍTICO: envía cookies
            headers: {
                'Accept': 'application/json',
            },
        });
        
        if (respuesta.status === 200) {
            const datos = await respuesta.json();
            return {
                authenticated: true,
                userId: datos.user_id,
                userLogin: datos.user_login,
                roles: datos.roles,
            };
        } else if (respuesta.status === 401) {
            return {
                authenticated: false,
            };
        } else {
            console.error('Estado HTTP inesperado:', respuesta.status);
            return {
                authenticated: false,
                error: true,
            };
        }
    } catch (error) {
        console.error('Error verificando sesión:', error);
        return {
            authenticated: false,
            error: true,
        };
    }
}

export async function logoutWordPress(): Promise<void> {
    // Redirigir a logout de WordPress
    window.location.href = 'https://wordpress.com/wp-login.php?action=logout&_wpnonce=' + 
        obtenerNonceLogout();
}
```

---

*Documento generado como referencia técnica para implementación de autenticación WordPress en Web App externa*

*Fuentes:*
- *`pre-proyecto/Boceto_B09.md`*
- *`pre-proyecto/Estudios/04-Autenticacion-WordPress-Investigacion.md`*
- *WordPress Developer Resources: `is_user_logged_in()`, REST API Authentication*
- *MDN Web Docs: `credentials`, SameSite cookies, CORS*
