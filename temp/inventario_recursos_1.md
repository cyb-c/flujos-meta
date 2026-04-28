# Inventario de Recursos y Configuración

> **Finalidad:** Fuente única de verdad para recursos del proyecto, despliegue con Vercel, base de datos, variables de entorno y configuración operativa.
> **Versión:** 6.1
> **Importante:** Este archivo es gestionado exclusivamente por el agente `inventariador`. Las modificaciones directas serán rechazadas.
> **Estado Migración PostgreSQL:** Completada exitosamente

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

## Reglas de Uso

- No inventar valores.
- No incluir secretos ni credenciales en texto plano.
- **Solo el agente `inventariador` puede actualizar este archivo.**
- Todo agente debe consultarlo antes de ejecutar trabajo con impacto operativo.
- Para solicitar cambios, usa el prompt: "Necesito actualizar el inventario: [detalles]"

---

## 1. Resumen del Proyecto

| Campo | Valor |
|-------|-------|
| **Nombre del proyecto** | Prompt Database |
| **Finalidad** | Gestionar, organizar y catalogar prompts de IA con búsqueda avanzada y tracking de uso |
| **Repositorio** | https://github.com/omagallanes/p-database |
| **Entorno de trabajo** | GitHub Codespaces + VS Code |
| **Lenguaje base** | TypeScript 5.5+ |
| **Stack** | Next.js 14 (App Router) + Prisma + PostgreSQL |
| **Entornos de despliegue** | development, staging, production |
| **Plataformas de deployment** | Vercel (preferida), VPS Docker (alternativa) |
| **Gestión de Secrets** | Vercel Environment Variables + GitHub Secrets |
| **Estructura del proyecto** | Monorepo: Next.js + Prisma en raíz |

---

## ⚠️ ADVERTENCIAS CRÍTICAS

| Tipo | Proyecto INCORRECTO (NO USAR) | Proyecto CORRECTO (USAR ESTE) |
|------|-------------------------------|-------------------------------|
| **Nombre** | `p-database` | `prompt-database` |
| **ID Vercel** | `prj_WxbWnpy4HtQOpBOVLKhJBah32OqW` | `prj_cu98UkNifYkmPNO0aLxYjqCHYWO1` |
| **URL** | `p-database-swart.vercel.app` (❌ 404 - ELIMINADO) | `prompt-database-liard.vercel.app` (✅ ACTIVO) |
| **Estado** | 🗑️ Eliminado el 2026-04-25 | ✅ Activo |

**Importante:** Cualquier referencia a `p-database` o `p-database-swart.vercel.app` es OBSOLETA y debe ser corregida inmediatamente.

---

## 2. Secrets para Despliegue

| Secret | Ubicación | Uso | Estado |
|--------|-----------|-----|--------|
| `DATABASE_URL` | GitHub Secret | Vercel / Docker env | ✅ |
| `VERCEL_TOKEN` | GitHub Secret | Autenticación con Vercel CLI | 🔲 |
| `POSTGRES_PASSWORD` | GitHub Secret | Contraseña DB para Docker (si aplica) | 🔲 |
| `[AGREGAR]` | [ubicación] | [Descripción] | 🔲 |

> **Nota:** Los valores de secrets nunca se documentan en este archivo. Configurar directamente en GitHub Settings > Secrets & Variables > Actions. Para Vercel CLI, usar `vercel secret` para gestionar variables desde línea de comandos.

---

## 3. Secrets de Desarrollo Local

### 3.1. Backend (`.env.development` o `.env.local`)

| Variable | Uso | Sensible | Ejemplo | Estado |
|----------|-----|----------|---------|--------|
| `DATABASE_URL` | Connection string a PostgreSQL en dev | Sí | `postgresql://user:passw@localhost:5432/prompt_db_dev` | ✅ |
| `NODE_ENV` | Entorno de ejecución | No | `development` | ✅ |
| `NEXT_PUBLIC_BASE_URL` | URL pública de la app | No | `http://localhost:3000` | ✅ |

### 3.2. Frontend (`.env.local`)

| Variable | Uso | Sensible | Ejemplo | Estado |
|----------|-----|----------|---------|--------|
| `NEXT_PUBLIC_API_BASE` | URL base de API (frontend) | No | `http://localhost:3000/api` | ✅ |
| `NEXT_PUBLIC_APP_NAME` | Nombre de la aplicación | No | `Prompt Database` | ✅ |

> **Nota:** Usar `.env.example` como plantilla versionada (sin valores reales). Los archivos `.env.local`, `.env.development`, `.env.production` están en `.gitignore`.

---

## 4. Recursos de Base de Datos y Despliegue

### 4.1 PostgreSQL

| Recurso | Proveedor | Ambiente | Connection String | Estado |
|---------|-----------|----------|-------------------|--------|
| BD Producción | **Neon** (PostgreSQL a través de Vercel Postgres) | production | `DATABASE_URL` (Secret) | ✅ |
| BD Staging | Vercel Postgres o Neon | staging | `DATABASE_URL` (var local) | 🔲 |
| BD Desarrollo | PostgreSQL (recomendado) o SQLite (compatibilidad) | development | `postgresql://localhost/prompt_db_dev` | ✅ |

**Detalles del Plan Hobby:**
- **Proveedor:** Neon (PostgreSQL 14+)
- **Almacenamiento:** 512 MB límite
- **Conexiones simultáneas:** 60
- **Plan:** Hobby (Gratuito) a través de Vercel Postgres
- **Estado migración:** ✅ Completada exitosamente

**Esquema de Base de Datos:**
- Modelos: `Prompt`, `Category`, `Tag`, `PromptTag`, `User`, `Account`, `Session`, `VerificationToken`
- Migraciones: Gestionadas por Prisma (`prisma/migrations/`)
- Seed: Datos de prueba en `prisma/seed.ts`

**Modelos de Autenticación:**
| Modelo | Descripción | Campos Principales | Estado |
|--------|-------------|-------------------|--------|
| `User` | Modelo de usuario con campos para autenticación | id, name, email, emailVerified, image, password, role | ✅ |
| `Account` | Modelo para cuentas OAuth | provider, providerAccountId, tokens, etc. | ✅ |
| `Session` | Modelo para sesiones de usuario | sessionToken, userId, expires | ✅ |
| `VerificationToken` | Modelo para tokens de verificación de email | identifier, token, expires | ✅ |

### 4.2 Vercel (Plataforma de Despliegue Principal)

| Recurso | Valor | Estado |
|---------|-------|--------|
| **Proyecto** | `prompt-database` en Vercel | ✅ |
| **Plan** | Hobby (Gratuito) | ✅ |
| **Dominio** | `https://prompt-database-liard.vercel.app/` | ✅ |
| **basePath** | No configurado (raíz del dominio) | ✅ |
| **Custom Domain** | [Por definir si aplica] | 🔲 |
| **Git Integration** | GitHub (rama `main`) | ✅ |
| **Despliegue Automático (Git)** | Desactivado (`git.deploymentEnabled: { "main": false }` en vercel.json) | ✅ |
| **Flujo de Despliegue** | Manual via Vercel CLI (ver `_en-ejecucion/flujo-despliegue-controlado.md`) | ✅ |
| **Environment Variables** | Configuradas en dashboard | ✅ |
| **Serverless Functions** | Next.js API Routes | ✅ |
| **Edge Middleware** | middleware.ts implementado | ✅ |


---

## 5. Configuración de Despliegue con Vercel

| Campo | Valor |
|-------|-------|
| **Método primario** | Vercel (manual via CLI, despliegues automáticos desactivados) |
| **Archivo de configuración (Vercel)** | `vercel.json` con `git.deploymentEnabled: false` |
| **Autenticación Vercel CLI** | `VERCEL_TOKEN` (GitHub Secret) |
| **Comando despliegue (preview)** | `vercel --token $VERCEL_TOKEN` |
| **Comando despliegue (producción)** | `vercel --prod --token $VERCEL_TOKEN` |
| **Build Command** | `npm run build` |
| **Start Command** | `npm start` o `node .next/standalone/server.js` |

### 5.1 Variables de Entorno en Plataforma de Despliegue

| Variable | Tipo | Sensible | Ubicación | Estado |
|----------|------|----------|-----------|--------|
| `DATABASE_URL` | String | Sí | GitHub Secret + Vercel vars | ✅ |
| `NODE_ENV` | String | No | Vercel vars | ✅ |
| `NEXT_PUBLIC_BASE_URL` | String | No | Vercel vars | 🔲 |

> **Nota de verificación**: Variables marcadas con ✅ fueron verificadas en deployment 2026-04-25 (v6.0).

---

## 6. Variables de Entorno por Servicio

### Backend (Next.js API Routes)

| Variable | Tipo | Sensible | Descripción | Estado |
|----------|------|----------|-------------|--------|
| `DATABASE_URL` | String | Sí | Connection string a PostgreSQL | ✅ |
| `NODE_ENV` | String | No | `development` / `staging` / `production` | ✅ |
| `NEXT_PUBLIC_BASE_URL` | String | No | URL base de la aplicación | 🔲 No configurada |

**Variables de NextAuth.js:**
| Variable | Tipo | Sensible | Descripción | Estado |
|----------|------|----------|-------------|--------|
| `AUTH_SECRET` | String | Sí | Secret para firmar tokens JWT (configurar en Vercel Environment Variables) | ✅ |
| `AUTH_URL` | String | No | URL base de la aplicación (configurar en Vercel Environment Variables) | ✅ |

### Frontend (Next.js Pages/Components)

| Variable | Tipo | Sensible | Descripción | Estado |
|----------|------|----------|-------------|--------|
| `NEXT_PUBLIC_API_BASE` | String | No | URL base de API (si está separada) | 🔲 |
| `NEXT_PUBLIC_APP_NAME` | String | No | Nombre de la aplicación | ✅ |

> **Nota de verificación**: Variables marcadas con ✅ fueron verificadas en deployment 2026-04-25 (v6.0). Para actualizar fecha de verificación, editar esta nota.

---

## 7. Integraciones Externas (Opcionales/Futuras)

---

## 8. Contratos entre Servicios

| Servicio Origen | Servicio Destino | Endpoint | Método | Request | Response | Estado |
|-----------------|------------------|----------|--------|---------|----------|--------|
| Frontend | Backend | `/api/auth/[...nextauth]` | GET/POST | Auth request | Auth response | ✅ |
| Frontend | Backend | `/api/auth/register` | POST | User data | User created | ✅ |
| Frontend | Backend | `/api/users` | GET | - | Users list (admin) | ✅ |
| Frontend | Backend | `/api/users` | PUT | User update | Updated user (admin) | ✅ |
| Frontend | Backend | `/api/users/[id]` | DELETE | - | Deleted user (admin) | ✅ |
| Frontend | Backend | `/api/prompts` | POST | Prompt data | Created prompt (auth) | ✅ |
| Frontend | Backend | `/api/prompts/[id]` | PUT | Prompt data | Updated prompt (auth+owner) | ✅ |
| Frontend | Backend | `/api/prompts/[id]` | DELETE | - | Deleted prompt (auth+owner) | ✅ |
| Frontend | Backend | `/api/categories` | POST | Category data | Created category (auth) | ✅ |
| Frontend | Backend | `/api/categories/[id]` | PUT | Category data | Updated category (auth+admin) | ✅ |
| Frontend | Backend | `/api/categories/[id]` | DELETE | - | Deleted category (auth+admin) | ✅ |
| Frontend | Backend | `/api/tags` | POST | Tag data | Created tag (auth) | ✅ |
| Frontend | Backend | `/api/tags/[id]` | PUT | Tag data | Updated tag (auth+admin) | ✅ |
| Frontend | Backend | `/api/tags/[id]` | DELETE | - | Deleted tag (auth+admin) | ✅ |
| Frontend | Backend | `/api/platforms` | GET | - | Platforms list | ✅ |
| Frontend | Backend | `/api/platforms` | POST | Platform data | Created platform (auth) | ✅ |
| Frontend | Backend | `/api/user/preferences` | GET | - | User view preference | ✅ |
| Frontend | Backend | `/api/user/preferences` | PATCH | View preference | Updated preference (auth) | ✅ |
| Frontend | Backend | `/api/export/prompts` | GET | - | Export JSON v2.0 con relaciones N:M (auth + filtrado por userId) | ✅ |
| Frontend | Backend | `/api/import/prompts` | POST | JSON v1.0 o v2.0 | Import prompts con upsert + relaciones N:M (auth + asignación por userId) | ✅ |
| Frontend | Backend | `/api/platforms` | POST | Platform name | Created platform con normalización (trim + uppercase) + upsert por slug (auth) | ✅ |
| Frontend | Backend | `/api/client-projects` | POST | ClientProject name | Created clientProject con normalización (trim + uppercase) + upsert por slug (auth) | ✅ |
| Frontend | Backend | `/api/use-cases` | POST | UseCase name | Created useCase con normalización (trim + uppercase) + upsert por slug (auth) | ✅ |
| Frontend | Backend | `/api/model-hints` | POST | ModelHint name | Created modelHint con normalización (trim + uppercase) + upsert por slug (auth) | ✅ |

---

## 9. Stack Tecnológico

| Capa | Tecnología | Versión | Estado |
|------|------------|---------|--------|
| Lenguaje | TypeScript | ^5.5.4 | ✅ |
| Framework (Full-Stack) | Next.js | ^14.2.35 | ✅ |
| Frontend | React | ^18.3.1 | ✅ |
| ORM | Prisma | ^5.19.1 | ✅ |
| Base de Datos | PostgreSQL | 14+ | ✅ |
| Styling | Tailwind CSS | ^3.4.7 | ✅ |
| UI Components | shadcn/ui | - | ✅ |
| Iconos | Lucide React | ^0.427.0 | ✅ |
| Validación | Zod | ^3.23.8 | ✅ |
| Testing | Jest | ^29.7.0 | ✅ |
| Testing Library | @testing-library/react | ^16.0.0 | ✅ |
| Runtime | Node.js | 20.x | ✅ |
| Package Manager | npm | 10.x | ✅ |
| Container | Docker | - | ✅ |
| Reverse Proxy | nginx / Traefik | - | 🔲 |

### Dependencias de Autenticación

| Dependencia | Versión | Propósito | Estado |
|-------------|---------|-----------|--------|
| `next-auth` | ^5.0.0-beta.31 | Auth.js v5 (NextAuth.js v5) | ✅ |
| `@auth/prisma-adapter` | ^2.11.2 | Adapter de Prisma para NextAuth.js | ✅ |
| `bcryptjs` | ^3.0.3 | Librería para hashing de contraseñas | ✅ |
| `@types/bcryptjs` | ^2.4.6 | Tipos TypeScript para bcryptjs | ✅ |

### Dependencias de Testing

| Dependencia | Versión | Propósito | Estado |
|-------------|---------|-----------|--------|
| `jest` | ^29.7.0 | Framework de testing | ✅ |
| `@testing-library/react` | ^16.0.0 | Testing de componentes React | ✅ |
| `@testing-library/jest-dom` | ^6.4.2 | Matchers de Jest para DOM | ✅ |
| `@testing-library/user-event` | ^14.5.2 | Simulación de eventos de usuario | ✅ |
| `jest-environment-jsdom` | ^29.7.0 | Entorno JS DOM para Jest | ✅ |
| `@types/jest` | ^29.5.12 | Tipos TypeScript para Jest | ✅ |

---

## 10. Archivos de Configuración

| Archivo | Finalidad | Estado |
|---------|-----------|--------|
| `package.json` | Dependencias y scripts npm (incluye postinstall para Prisma) | ✅ |
| `tsconfig.json` | Configuración TypeScript | ✅ |
| `next.config.js` | Configuración Next.js | ✅ |
| `jest.config.js` | Configuración Jest | ✅ |
| `tailwind.config.ts` | Configuración Tailwind CSS | ✅ |
| `prisma/schema.prisma` | Esquema de base de datos (Prisma) | ✅ |
| `prisma/seed.ts` | Script de seed de datos | ✅ |
| `prisma/migrations/` | Migraciones de BD numeradas | ✅ |
| `prisma/migrations/20260418101204_init_postgresql/` | Migración inicial PostgreSQL | ✅ |
| `_en-ejecucion/fase5-validacion-local-report.md` | Reporte de validación local PostgreSQL | ✅ |
| `_en-ejecucion/fase6-despliegue-vercel-report.md` | Reporte de despliegue en Vercel | ✅ |
| `_en-ejecucion/fase7-validacion-produccion-report.md` | Reporte de validación en producción | ✅ |
| `_en-ejecucion/fase8-limpieza-documentacion-report.md` | Reporte de limpieza y documentación | ✅ |
| `_en-ejecucion/flujo-despliegue-controlado.md` | Flujo de despliegue controlado (despliegues manuales) | ✅ |
| `_pre-prompt/limpieza-historial-git-y-control-despliegues.md` | Documento previo de limpieza de historial Git | ✅ |
| `.env.example` | Plantilla de variables (documentación) | ✅ |
| `.env` | Variables de entorno actualizadas con PostgreSQL | ✅ |
| `.env.backup` | Backup del archivo .env original (SQLite) | ✅ |
| `.env.development` | Variables de desarrollo (git ignored) | ✅ |
| `.env.production` | Variables de producción (git ignored) | ✅ |
| `Dockerfile` | Configuración Docker | ✅ |
| `docker-compose.yml` | Orquestación Docker | ✅ |
| `docker-compose.dev.yml` | Docker para desarrollo | ✅ |
| `nginx.conf` | Configuración nginx (si aplica) | 🔲 |
| `.gitignore` | Exclusiones de versionado | ✅ |
| `vercel.json` | Configuración Vercel (despliegues automáticos desactivados) | ✅ |

**Configuración de Autenticación:**
| Archivo | Finalidad | Estado |
|---------|-----------|--------|
| `lib/auth.ts` | Configuración de NextAuth.js con Prisma adapter, Credentials provider, JWT session strategy | ✅ |
| `middleware.ts` | Middleware para protección de rutas | ✅ |
| `types/next-auth.d.ts` | Tipos TypeScript extendidos para NextAuth | ✅ |

---

> **Nota:** Este documento es la fuente única de verdad. Mantener actualizado con cambios en infraestructura, variables y secretos.
>
> **Última actualización**: 2026-04-25 (Mejoras Opcionales v6.1 + Correcciones de Consistencia v6.0 + Sprint F4-SF4.1-S1)  
> **Versión**: 6.1 