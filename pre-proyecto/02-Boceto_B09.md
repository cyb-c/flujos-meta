# Boceto de entendimiento del proyecto — Versión 0.9

---

## Índice de Contenido

1. [Naturaleza general del proyecto](#1-naturaleza-general-del-proyecto)
2. [Tipo de documentos de origen](#2-tipo-de-documentos-de-origen)
3. [Objetivos y alcance del proyecto](#3-objetivos-y-alcance-del-proyecto)
4. [Extracción de contenido desde los PDFs](#4-extracción-de-contenido-desde-los-pdfs)
5. [Decisión tecnológica para extracción de PDF](#5-decisión-tecnológica-para-extracción-de-pdf)
6. [Uso de IA dentro del proceso](#6-uso-de-ia-dentro-del-proceso)
7. [Relación con WordPress](#7-relación-con-wordpress)
8. [Relación con WooCommerce](#8-relación-con-woocommerce)
9. [Web-App externa a WordPress](#9-web-app-externa-a-wordpress)
10. [Configuración de la WA](#10-configuración-de-la-wa)
11. [Usuarios y administración en la WA](#11-usuarios-y-administración-en-la-wa)
12. [Usuario del proceso](#12-usuario-del-proceso)
13. [Relación PDF ↔ producto](#13-relación-pdf--producto)
14. [Flujo general comprendido](#14-flujo-general-comprendido)
15. [Tramo previo a la intervención posterior de IA](#15-tramo-previo-a-la-intervención-posterior-de-ia)
16. [Subcarpeta del proceso y nombre del PDF](#16-subcarpeta-del-proceso-y-nombre-del-pdf)
17. [Control por nombre de PDF ya procesado](#17-control-por-nombre-de-pdf-ya-procesado)
18. [Formulario de revisión en la WA](#18-formulario-de-revisión-en-la-wa)
19. [Subida manual de imágenes durante la revisión](#19-subida-manual-de-imágenes-durante-la-revisión)
20. [Aprobación y envío a API-WooC](#20-aprobación-y-envío-a-api-wooc)
21. [Desaprobación, rechazo y descarte](#21-desaprobación-rechazo-y-descarte)
22. [Cancelación antes de revisión/aprobación](#22-cancelación-antes-de-revisiónaprobación)
23. [Fallo de API WooCommerce tras aprobación](#23-fallo-de-api-woocommerce-tras-aprobación)
24. [Papel del admin ante fallo API-WooCommerce o tramo final](#24-papel-del-admin-ante-fallo-api-woocommerce-o-tramo-final)
25. [Mensaje final tras creación correcta en WooCommerce](#25-mensaje-final-tras-creación-correcta-en-woocommerce)
26. [Tipo de información implicada](#26-tipo-de-información-implicada)
27. [Elementos y herramientas que intervienen](#27-elementos-y-herramientas-que-intervienen)
28. [Estados y avance visible para el usuario](#28-estados-y-avance-visible-para-el-usuario)
29. [Log y visibilidad para usuario/admin](#29-log-y-visibilidad-para-usuarioadmin)
30. [Dependencias críticas identificadas](#30-dependencias-críticas-identificadas)
31. [Errores o problemas del proceso](#31-errores-o-problemas-del-proceso)
32. [Log completo del proceso](#32-log-completo-del-proceso)
33. [Puntos todavía poco definidos](#33-puntos-todavía-poco-definidos)
34. [Pendientes para definir con el desarrollador](#34-pendientes-para-definir-con-el-desarrollador)
    - [34.1 Formulario de revisión](#341-formulario-de-revisión)
    - [34.2 Multiplicidad de productos/modelos](#342-multiplicidad-de-productosmodelos)
    - [34.3 Estados, pasos y avance del proceso](#343-estados-pasos-y-avance-del-proceso)
    - [34.4 Control de errores](#344-control-de-errores)
    - [34.5 Log del proceso](#345-log-del-proceso)
    - [34.6 Subcarpeta del PDF y artefactos internos](#346-subcarpeta-del-pdf-y-artefactos-internos)
    - [34.7 Papel del admin ante incidencias](#347-papel-del-admin-ante-incidencias)
    - [34.8 Extracción del PDF](#348-extracción-del-pdf)
    - [34.9 WordPress, media y API-WooCommerce](#349-wordpress-media-y-api-woocommerce)

---

### 1. Naturaleza general del proyecto

* El proyecto gira en torno a un **proceso automatizado y repetitivo** para transformar información contenida en PDFs en productos publicables en WooCommerce.

* El usuario sube un PDF y activa un flujo que:

  * lee el contenido del PDF;
  * extrae toda la información textual del PDF;
  * pasa esa información a diferentes ejecuciones de IA;
  * genera resultados intermedios dependientes del texto extraído;
  * utiliza esos resultados para crear productos en WooCommerce;
  * deja una **revisión manual final** antes de aprobar la publicación.

* El proyecto no se entiende solo como un flujo entre PDFs, IA, WordPress y WooCommerce. Se trata de un web-app (WA) **externa a WordPress** actúa como centro de control.

* WordPress conserva un papel de almacenamiento, integración.

* WooCommerce es el destino de creación y publicación directa de productos (mediante API-WooCommerce).

* La IA interviene en la interpretación y generación de resultados a partir del contenido extraído del PDF.

* La **WA debe estar configurada previamente por usuario admin**.

* La WA concentra la interacción humana: login, inicio del proceso (clic botón), seguimiento de estados del proceso 100% automatizado, luego revisión humana del resultado del flujo con opciones para: corrección, aprobación, rechazo.

* Opción de cancelación durante el proceso si el usuario así lo indica.

* Logout WA.

* El final exitoso del proceso no se produce con la aprobación del usuario, sino cuando, tras esa aprobación, la API de WooCommerce guarda o crea correctamente el producto sin fallo.

* El usuario puede desaprobar o rechazar durante la revisión (formulario de revisión) y antes de la llamada a WooCommerce.

* Si el usuario aprueba y API-WooCommerce crea correctamente el producto, el usuario ve un mensaje final de éxito y un enlace a la **vista pública del producto**, que debe abrirse en una nueva pestaña o ventana mediante `target="_blank"`.

* La aprobación en la WA equivale a la **autorización final de publicación pública**.

* La revisión (formulario de revisión) en la WA es la única revisión humana previa a la publicación pública.

* Una vez publicado el producto mediante API-WooC, el flujo de la WA termina y el usuario puede procesar otro PDF o logout.

* El enlace final a la vista pública confirma que el producto ya está publicado y visible en la web.

* La WA no contempla mantenimiento posterior del producto publicado.

* El mantenimiento posterior del producto publicado se delega en la gestión directa que pueda hacerse desde WordPress/WooCommerce fuera de la WA.

* El admin debe entenderse, a nivel funcional, como un perfil con **pleno acceso a todo** dentro del ámbito de la WA y del proceso.

* Ese pleno acceso del admin incluye consultar, supervisar, configurar y disponer de funciones operativas adicionales no detalladas en este boceto.

* Las funciones adicionales concretas del admin, así como otros parámetros de configuración de la WA, no proceden en este momento y quedan como tarea del desarrollador.

* El proceso está orientado a terminar creando/publicando **un solo producto por ejecución del flujo**.

* Si la IA detecta más de un producto dentro de un PDF o si puede tener varios modelos, el usuario debe tomar una decisión sobre qué hacer; esa casuística queda como caso especial pendiente para el desarrollador.

* La representación concreta de varios productos/modelos queda pendiente para el desarrollador.

* **Objetivos de negocio del proyecto:**

  * **Reducir tiempo** de publicación de productos en WooCommerce.
  * **Eliminar errores** manuales en la creación de fichas de producto.
  * **Procesar un alto volumen** de documentos técnicos (más de 100 archivos PDF).
  * **Poner a disposición del público** toda la gama de productos con información veraz, detallada y completa.
  * **Generar redacción fácil de entender** por los visitantes de las fichas de productos en WooCommerce.
  * **Mejorar el posicionamiento** en buscadores y LLM mediante redacciones orientadas a SEO.

* **Plazo de implementación:** 18 de mayo de 2026.

---

### 2. Tipo de documentos de origen

| Aspecto             | Entendimiento actual                                                                   |
| ------------------- | -------------------------------------------------------------------------------------- |
| Formato             | Archivos PDF                                                                           |
| Volumen             | Más de 100 archivos                                                                    |
| Contenido           | Productos de protección, control y alarma de incendios                                 |
| Naturaleza probable | Documentación técnica, fichas de producto, catálogos o documentos comerciales/técnicos |
| Complejidad         | Pueden contener texto, imágenes y tablas                                               |

* No procede definir ahora qué tipos exactos de PDF se procesarán principalmente.

* Queda fuera de esta fase y se tratará con el desarrollador, por ejemplo:

  * fichas individuales;
  * catálogos;
  * manuales;
  * escaneados;
  * documentos digitales;
  * documentos mixtos.

* **Volumen objetivo de procesamiento:** existen **más de 100 archivos PDF**, pero no se define un volumen objetivo por día, semana o mes. El objetivo es procesar la totalidad del volumen existente.

* En el boceto debe mantenerse como aspecto pendiente, sin profundizar en esta fase.

---

### 3. Objetivos y alcance del proyecto

* **Objetivo operativo:** ejecutar un proceso automatizado y repetitivo para transformar documentación técnica en PDF en productos publicables en WooCommerce.

* **Objetivos de negocio:**

  | Objetivo | Descripción |
  | ------ | ----------- |
  | Reducir tiempo | Disminuir el tiempo requerido para publicar fichas de producto en WooCommerce |
  | Eliminar errores | Minimizar errores manuales en la creación de contenido de producto |
  | Procesar alto volumen | Capacidad para transformar más de 100 documentos técnicos |
  | Información veraz | Garantizar que la información publicada sea detallada, completa y verificable |
  | Legibilidad | Redacción fácil de entender por los visitantes de la web |
  | Posicionamiento | Contenido orientado a mejorar SEO en buscadores tradicionales y LLM |

* **Alcance de la WA:**

  * La WA es externa a WordPress y actúa como centro de control del proceso.
  * La WA se aloja en el mismo servidor que WordPress.
  * La WA debe ser desarrollada desde cero.
  * El framework para la WA se decidirá como una de las primeras decisiones técnicas.
  * Se considerará en primer lugar una base tecnológica PHP-React o alternativa a determinar.
  * La WA concentra toda la interacción operativa del usuario.

* **Límites del sistema:**

  * La WA no mantiene productos ya publicados.
  * La WA no edita ni elimina productos existentes en WooCommerce.
  * La WA no sincroniza catálogos existentes.
  * El mantenimiento posterior se delega en WordPress/WooCommerce fuera de la WA.

* **Plazo de implementación:** 18 de mayo de 2026.

---

### 4. Extracción de contenido desde los PDFs

* Los PDFs deben ser leídos para extraer:

  * texto;
  * imágenes;
  * tablas convertidas o representadas en modo texto.

* La IA es una opción para esta extracción, pero no necesariamente la única.

* Pueden coexistir métodos distintos para obtener el contenido del PDF, siempre que el resultado sea usable por los pasos posteriores.

* El foco no está únicamente en “leer PDFs”, sino en generar una base textual suficientemente útil para alimentar procesos posteriores.

* Existe una decisión pendiente importante:

  * usar un lector/extractor de contenido PDF basado en PHP;
  * usar IA para la extracción de contenido del PDF;
  * o determinar otra combinación posible más adelante.

* Esta decisión afecta al inicio del flujo, antes de que el texto esté disponible para los roles posteriores de IA.

* La decisión no se resuelve todavía, pero debe quedar reflejada como una bifurcación o aspecto pendiente del proyecto.

* Antes de que intervenga la IA, debe existir un tramo inicial del proceso orientado a:

  * login del usuario en la WA;
  * inicio del proceso mediante el botón **"Procesar Producto"**;
  * formulario para subir PDF;
  * subida del PDF;
  * obtención del nombre del archivo;
  * creación de una subcarpeta con el nombre del archivo dentro de `DIR_ALMACEN_PDF` (Ruta donde almacenar todos los PDFs);
  * almacenamiento del PDF en esa subcarpeta;
  * procesamiento del PDF para obtener el texto.

* En ese punto sigue pendiente decidir si el texto del PDF se obtiene mediante IA o mediante extensión/librería PHP.

* El texto PDF debe guardarse en un archivo `.TXT` con codificación **UTF-8 BOM** dentro de la subcarpeta del PDF, justo después de obtenerlo.

* Ese archivo `.TXT` será el archivo que se pasará a la IA para los procesos posteriores.

* Condiciona directamente la calidad de los resultados generados por la IA.

* No se guarda en WordPress antes de la aprobación del usuario (previo a API-WooCommerce).

* Se guarda el texto PDF en WordPress tras la aprobación, como parte del tramo final de publicación.

* Su guardado queda relacionado con WordPress.

---

### 5. Decisión tecnológica para extracción de PDF

* Queda pendiente decidir el método concreto para extraer el contenido textual de los PDFs.

* Las alternativas consideradas son:

  | Alternativa | Descripción |
  | ----------- | ----------- |
  | Lector/extractor PHP | Uso de librerías o extensiones de PHP para extracción directa |
  | IA para extracción | Uso de servicios de IA con capacidad de procesamiento de PDF |
  | Combinación | Enfoque híbrido que combine ambos métodos según el tipo de PDF |

* Esta decisión es una de las primeras que debe tomar el desarrollador al iniciar la implementación.

* La decisión afecta directamente:

  * al inicio del flujo de procesamiento;
  * a la calidad del texto extraído;
  * a la fiabilidad de los resultados posteriores de IA;
  * al coste operativo del proceso;
  * a la velocidad de extracción.

* El criterio de selección debe basarse en:

  * calidad de extracción para documentos técnicos con tablas;
  * capacidad de manejar PDFs escaneados vs digitales;
  * consistencia de resultados;
  * coste por documento procesado;
  * integración con la arquitectura WA definida.

* Esta decisión se documentará en el Contrato Técnico de Arquitectura e Integraciones (`PyR/03-R02.md`).

---

### 6. Uso de IA dentro del proceso

* La IA no aparece como un único paso, sino como una serie de **ejecuciones diferenciadas**.

* Cada ejecución mediante IA-API usa un **rol diferente**.

* Cada rol orientado a un trabajo específico sobre el texto extraído.

* Los resultados de cada paso pueden ser independientes en función, pero todos dependen del contenido inicial del Texto PDF.

* La IA se utiliza como mecanismo de transformación, interpretación o generación de información útil para construir el producto final.

* La IA también participa en la **identificación de la unidad comercial/producto**, ya que será quien determine, a partir del texto extraído del PDF, si el contenido corresponde a:
  * un solo producto;
  * un producto con varios modelos;
  * varios productos.

* La IA será quien, a partir del texto extraído del PDF:
  * interprete la estructura del contenido;
  * determine cuántos productos hay;
  * determine si existen modelos dentro de un mismo producto;
  * genere resultados acordes con esa interpretación.

* **Documento de IA:** está pendiente de ser creado un documento dedicado específicamente a la IA, que deberá incluir:
  * roles concretos a usar en cada prompt;
  * parámetros de entrada de cada ejecución;
  * salida del resultado de cada rol;
  * dependencias entre cada una de las ejecuciones de IA.

* **Proveedores de IA:** no hay un proveedor de IA seleccionado o presupuestado. La configuración de la WA debe incluir:
  * un CRUD para que el administrador pueda añadir proveedores de IA;
  * registro de APIs de cada proveedor;
  * configuración de límites de uso o consumo por proveedor;
  * capacidad de seleccionar un proveedor por defecto entre los disponibles;
  * una función PHP o clase encargada de ejecutar prompts de IA que se adapte a distintos proveedores.

* **Tipo de ejecuciones de IA:** las ejecuciones diferenciadas implican llamadas separadas a la API con roles diferentes:
  * algunos resultados alimentan pasos posteriores (parámetros de entrada para siguientes ejecuciones);
  * otros análisis son independientes, usando solo como entrada el texto del PDF.

* Aunque el detalle queda fuera de este boceto, sí queda una comprensión general:
| Tipo de relación entre procesos IA                           | Existe en el proyecto |
| ------------------------------------------------------------ | --------------------- |
| Un resultado alimenta al siguiente                           | Sí, en algunos casos  |
| Varios análisis independientes sobre el mismo texto extraído | Sí, también existe    |

* Los bloques/resultados generados por los distintos roles de IA no quedan ocultos para el usuario: se presentarán en la WA dentro de un formulario de revisión.

* El usuario podrá ver todos los bloques/resultados generados por los distintos roles de IA.

* El diseño concreto del formulario de revisión se definirá con el desarrollador, fuera de este boceto.

* El formulario de revisión será el espacio donde el usuario pueda revisar, corregir, completar y finalmente aprobar o desaprobar el contenido antes de la API-WooC.

* Los bloques o resultados de IA dentro del formulario de revisión serán parcialmente editables y en otros solo informativos (no editables).

* Que bloques son editables/informativos corresponde al trabajo posterior con el desarrollador.

---

### 7. Relación con WordPress

* WordPress actúa como parte del entorno donde se guarda y gestiona información.

* Con la incorporación de la WA, WordPress deja de entenderse como el entorno principal de trabajo del usuario.

* La experiencia operativa del usuario ocurre principalmente en la WA, mientras que WordPress mantiene un papel de almacenamiento, integración o soporte del flujo.

* El papel principal de WordPress queda mejor acotado:
  * guardar el texto original extraído del PDF como registro/base para el proceso, pero tras la aprobación;
  * conservar ese texto posteriormente para otros usos fuera de este proyecto;
  * recibir imágenes como archivos/media antes de que sus enlaces se pasen a API-WooC.

* WordPress no debe entenderse aquí como el centro operativo del flujo ni como el lugar donde el usuario trabaja.

* El guardado en WordPress del texto PDF, el guardado de imágenes como media y la API-WooC forman parte de un único tramo final de publicación.

* Ese tramo final se activa solo cuando el usuario aprueba el formulario en la WA.

* Si el usuario cancela o desaprueba antes de la aprobación, el texto PDF no se guarda en WordPress.

* El detalle de la relación entre texto, PDF, imágenes, archivos/media de WordPress y API-WooC se hablará con el desarrollador.

* De momento, en el marco de este boceto, WordPress guarda el texto extraído aprobado, aunque el guardado exacto queda como tarea del desarrollador.

* WordPress también debe conservar alguna referencia funcional al PDF, al proceso y/o al producto publicado.

* Las imágenes extraídas o subidas por el usuario en el formulario de revisión, también deben guardarse en WordPress tras la aprobación en la biblioteca de medios de WP (BMWP), aunque el detalle técnico se defina con el desarrollador.

* Dichas imágenes serán añadidas posteriormente al producto en WooC mediante API-WooCommerce, de ahí la necesidad de la BMWP, aunque el detalle técnico se defina con el desarrollador.

* **Situación de WordPress:** existe ya una instalación de WordPress con WooCommerce en producción. La WA se incorporará a ese servidor.

* **Tabla específica en WordPress:** debe crearse una tabla específica en WordPress para guardar el texto extraído del PDF. Esta tabla debe quedar referenciada al producto que se crea con la API de WooCommerce. La estructura de esta tabla se definirá con el desarrollador.

---

### 8. Relación con WooCommerce

* WooCommerce recibe los resultados procesados para crear productos mediante API.

* El proyecto debe entenderse como un flujo para **crear nuevos productos** en WooC.

* No se contempla la actualización de productos existentes desde la WA.

* La conexión con WooCommerce se orienta a creación inicial y publicación directa, no a mantenimiento o sincronización posterior de catálogo existente desde la WA.

* Solo cuando el usuario aprueba el resultado en la WA se ejecuta la API para agregar el producto a WooCommerce.

* Esto confirma que la publicación o creación efectiva en WooCommerce no se dispara automáticamente tras la IA, sino tras una acción humana explícita en la WA.

* El rechazo del usuario ocurre siempre antes de cualquier llamada a WooCommerce.

* Si el usuario rechaza, desaprueba o cancela antes de aprobar, no se ejecuta la API-WooC.

* Si el usuario aprueba, todo el contenido del formulario (incluyendo imágenes extraídas del PDF o subidas por el usuario al formulario de revisión) se toma como contenido final para la API-WooC.

* El final correcto del proceso se produce solo cuando la API-WooC crea o guarda correctamente el producto en WooCommerce sin fallo.

* Cuando la API-WooC crea correctamente el producto:

  * el producto queda **publicado directamente en la web**;
  * no queda como borrador;
  * no queda en estado pendiente;
  * no requiere una revisión posterior dentro de WooCommerce para publicarse.

* La revisión válida y decisiva es la que ocurre antes, dentro de la WA.

* Tras la creación correcta en WooCommerce:

  * el usuario ve un mensaje final de éxito;
  * se muestra un enlace al producto creado en WooCommerce;
  * el enlace debe apuntar a la **vista pública del producto**;
  * el enlace debe abrir en una nueva pestaña o ventana mediante `target="_blank"`.
  
* **Situación de WooCommerce:** existe ya una instalación de WordPress con WooCommerce en producción.

* **Campos personalizados de producto:** los campos personalizados ya existen y están definidos en el WooCommerce en producción. Sin embargo, está pendiente la definición detallada de dichos campos para que la salida generada por la IA quede encajada y relacionada con los campos en WooCommerce de forma automática. Esta definición se tratará con el desarrollador.

### 9. Web-App externa a WordPress

Se incorpora un elemento clave al proyecto: una **web-app externa a WordPress** (WA), que pasa a ser el entorno principal donde el usuario trabaja el proceso.

La WA no se entiende como una simple pantalla auxiliar, sino como el espacio donde el usuario:

* accede mediante login;
* inicia procesos de PDFs;
* visualiza el avance;
* puede cancelar el proceso;
* revisa los resultados;
* corrige o completa información;
* aprueba o rechaza;
* provoca, al aprobar, la creación/publicación del producto en WooCommerce mediante API;
* el usuario repite la secuencia botón / PDF / revisión / aprobación o rechazo tantas veces como sea necesario;
* cierra sesión mediante logout.

Esto cambia la comprensión del flujo: WordPress y WooCommerce siguen siendo piezas importantes, pero la experiencia operativa del usuario ocurre principalmente en la WA.

* La WA debe estar configurada por admin antes de que el usuario pueda trabajar el proceso.

* La WA debe permitir que el usuario pulse botón **"Procesar Producto"** para iniciar el ciclo de trabajo asociado a un PDF.

* La WA debe presentar un formulario para subir el PDF.

* La WA debe mostrar al usuario el avance del proceso de forma acotada y simple.

* La WA debe presentar los resultados de IA en un formulario de revisión.

* La WA debe permitir que el usuario corrija información dentro del formulario.

* La WA debe permitir que el usuario suba imágenes manualmente durante la revisión.

* La WA debe permitir que el usuario apruebe o desapruebe el resultado.

* La WA debe permitir que el usuario cancele el proceso antes de llegar a la revisión/aprobación.

* La WA debe mostrar un botón permanente de cancelación mientras se ejecutan los procesos.

* El botón de cancelación se mantiene mientras se ejecutan todos los procesos.

* El proceso se entiende como un bloque sin intervención del usuario hasta el final, salvo por la posibilidad de pulsar el botón de cancelación.

* El usuario solo interviene de forma sustantiva al final, en el formulario de revisión, pero puede cancelar cuando quiera mientras el proceso se ejecuta.

* Si el usuario cancela antes de la revisión/aprobación, se debe pedir confirmación.

* Si el usuario confirma la cancelación:

  * se corta el proceso;
  * se borra todo el contenido en la subcarpeta del PDF;
  * Se mantiene y se debe guardar el log;
  * no se ejecuta API-WooC;
  * se redirige al formulario de carga de PDF;
  * el ciclo queda listo para empezar de nuevo con otro PDF.

* La WA debe ejecutar la API-WooC solo si el usuario aprueba.

* La WA debe mostrar mensaje final de éxito y enlace a la **vista pública del producto** si la creación en WooCommerce termina correctamente.

* La WA debe mostrar un mensaje estándar de error si se produce un fallo que impida continuar o si falla el tramo final de publicación.

* La WA crea/publica productos, pero no modifica ni elimina productos ya publicados.

* El mantenimiento posterior del producto publicado no forma parte del alcance de la WA.

* **Desarrollo de la WA:** debe desarrollarse desde cero.

* **Ubicación de la WA:** se aloja en el mismo servidor que WordPress.

* **Framework de la WA:** una de las primeras decisiones será establecer el framework para la WA. Se considerará en primer lugar una base tecnológica PHP-React o alternativa a determinar con base en criterios de lo mejor para el proyecto.

* **Restricciones tecnológicas:** la decisión sobre el framework y motor de flujo de proceso se tomará con base en criterios de lo mejor para el proyecto, considerando la integración de login de usuario con WordPress, y un sistema de registro (log), seguimiento de pasos y estados, y registro de errores.

---

### 10. Configuración de la WA

Antes de que el usuario pueda trabajar el proceso, la **WA debe estar configurada**.

Datos de configuración identificados:

| Configuración WA  | Descripción                                            |
| ----------------- | ------------------------------------------------------ |
| `DIR_ALMACEN_PDF` | base en el servidor donde se guardan los PDFs subidos y las subcarpetas creadas para cada proceso/PDF |

* **Configuración de proveedores de IA:** el administrador debe tener un CRUD en la configuración de la WA para:
  * añadir proveedores de IA;
  * registrar APIs de cada proveedor;
  * configurar límites de uso o consumo por proveedor;
  * seleccionar un proveedor por defecto entre los disponibles.

* **Función de ejecución de IA:** debe crearse una función PHP o clase que sea la encargada de ejecutar prompts de IA y adaptarse a distintos proveedores.

* **Otros parámetros de configuración:** quedan como tarea del desarrollador definir qué otros parámetros de configuración de la WA existirán además de `DIR_ALMACEN_PDF`.

---

### 11. Usuarios y administración en la WA

La WA contempla dos niveles básicos de uso:

| Tipo de usuario | Papel entendido                                                  |
| --------------- | ---------------------------------------------------------------- |
| Admin           | Controla todos datos/configuración que solo él puede modificar |
| Usuario         | Hace login y trabaja en el proceso operativo de PDFs             |

Aspectos relevantes:

* No existe una gestión de usuarios dentro de la WA.

* Los usuarios existen solo en WP

* El login a la WA se hará verificando contra WP.

* Para que **la WA pregunte a WordPress** y WordPress valide su propia sesión/cookie. En la WA se hace una llamada con cookies (`credentials: "include"`); en WP, un endpoint responde `200` si `is_user_logged_in()` es true y `401` si no. WordPress ya trae cookie authentication para REST, pero en REST hay que cuidar nonces/CSRF si vas a hacer acciones que modifiquen datos.

* Queda abierta la posibilidad de que la WA tenga otras funciones reservadas al admin.

* El admin tiene pleno acceso a todo.

* Para que un usuario sea Admin en WA debe tener el rol de Admin en WP.

* **Usuarios de la WA:** los usuarios existen solo en WordPress. El login a la WA se valida contra WordPress.

* **Requisito de rol:** cualquier usuario de WordPress con rol superior a "suscriptor" puede ser usuario de la WA.

* **Admin de la WA:** para que un usuario sea administrador en la WA, debe tener el rol de administrador en WordPress.

### 12. Usuario del proceso

* El usuario que:

  * sube el PDF;
  * ejecuta el proceso;
  * puede cancelar el proceso;
  * revisa el resultado;
  * corrige o completa datos;
  * aprueba o rechaza;
  * decide la publicación mediante su aprobación;

  es la misma persona.

Esto simplifica el mapa de actores: hay un **usuario operador/revisor/publicador** concentrando todo el control humano del flujo.

Cualquier usuario en WP con rol superior a "suscriptor" puede ser usuario de WA y solo debe validar el login en WP.

* En el contexto de la WA, este usuario operativo:

  * hace login;
  * trabaja en el proceso;
  * pulsa **"Procesar Producto"**;
  * visualiza el avance;
  * puede cancelar mientras se ejecutan los procesos;
  * revisa resultados;
  * edita o corrige cuando procede;
  * aprueba o rechaza;
  * puede cerrar sesión mediante logout.

* El usuario operativo tiene un alcance limitado dentro de la WA.

Su interacción se reduce a:

* subir el PDF;
* arrancar el proceso;
* cancelar si decide hacerlo antes de la revisión/aprobación;
* revisar el resultado;
* aprobar o rechazar;
* finalizar con API-WooCommerce si aprueba.

No ve:

* histórico;
* log completo;
* trazabilidad técnica;
* gestión posterior de procesos bloqueados;
* información adicional fuera del flujo operativo inmediato.

Si ocurre un fallo, recibe únicamente el mensaje estándar correspondiente, pero no queda planteado que consulte historiales o estados posteriores.

* **Auditoría y trazabilidad:** sí debe existir un registro (log) completo del proceso. El usuario que sube, ejecuta, revisa, corrige, aprueba o rechaza es la misma persona. El log conserva la trayectoria del proceso. No se necesita una auditoría adicional separada del log técnico, ni un registro específico de "quién aprobó cada producto" fuera de ese marco.

---

### 13. Relación PDF ↔ producto

* La relación habitual es:

| PDF   | Producto   |
| ----- | ---------- |
| 1 PDF | 1 producto |

* Pero existen excepciones relevantes:

  * un PDF puede contener **varios productos**;
  * un PDF puede corresponder a **un mismo producto con varios modelos**.

Esto añade una distinción importante: el sistema no solo trata documentos, sino que debe reconocer cuándo el contenido representa una unidad de producto simple, varias unidades de producto o una familia/modelos de producto.

* Si un PDF corresponde a:

  * un solo producto;
  * un producto con varios modelos;
  * varios productos.

* Esa decisión queda dentro del trabajo de la IA.

* La IA será quien, a partir del texto extraído del PDF:

  * interprete la estructura del contenido;
  * determine cuántos productos hay;
  * determine si existen modelos dentro de un mismo producto;
  * genere resultados acordes con esa interpretación.

Esto refuerza que la IA no solo transforma contenido, sino que también participa en la **identificación de la unidad comercial/productiva resultante**.

* Si la IA detecta varios productos o varios modelos, queda pendiente decidir con el desarrollador cómo se representará eso en el formulario.

* También queda pendiente decidir con el desarrollador si, en esos casos, la aprobación será global para todo el formulario o parcial por producto/modelo.

* A nivel del proceso definido en este proyecto, cada ejecución debe terminar creando/publicando un solo producto.

* Ese producto sí puede tener varios modelos.

* Si la IA detecta varios modelos dentro de un mismo producto, el proceso puede seguir orientado a crear/publicar ese único producto con varios modelos.

* Si la IA detecta más de un producto, el proceso no debe entenderse como creación automática de varios productos.

* En ese caso, el usuario debe tomar una decisión sobre qué hacer, y la forma de representar y gestionar esa situación queda pendiente para el desarrollador.

* La casuística "varios productos/modelos" queda como caso especial pendiente para el desarrollador.

* La aprobación del formulario de revisión autoriza todo lo incluido en el proceso que finalmente se mantenga como contenido aprobado para ese producto.

---

### 14. Flujo general comprendido

El flujo general del proceso se representa a continuación mediante un diagrama ASCII que simula la notación Mermaid:

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           FLUJO GENERAL DEL PROCESO                              │
└─────────────────────────────────────────────────────────────────────────────────┘

                                    ┌──────────────┐
                                    │   INICIO     │
                                    │   (WA)       │
                                    └──────┬───────┘
                                           │
                                           ▼
                                    ┌──────────────┐
                                    │   LOGIN      │
                                    │  (validado   │
                                    │  contra WP)  │
                                    └──────┬───────┘
                                           │
                                           ▼
                                    ┌──────────────┐
                              ┌─────│  Formulario  │─────┐
                              │     │  carga PDF   │     │
                              │     └──────┬───────┘     │
                              │            │             │
                              │            ▼             │
                              │     ┌──────────────┐     │
                              │     │   Botón      │     │
                              │     │ "Procesar    │     │
                              │     │  Producto"   │     │
                              │     └──────┬───────┘     │
                              │            │             │
                              │            ▼             │
                              │     ┌──────────────┐     │
                              │     │  Subida PDF  │     │
                              │     └──────┬───────┘     │
                              │            │             │
                              │            ▼             │
                              │     ┌──────────────┐     │
                              │     │  Crear       │     │
                              │     │  subcarpeta  │     │
                              │     │  (nombre     │     │
                              │     │   PDF)       │     │
                              │     └──────┬───────┘     │
                              │            │             │
                              │            ▼             │
                              │     ┌──────────────┐     │
                              │     │  Guardar PDF │     │
                              │     │  en sub-     │     │
                              │     │  carpeta     │     │
                              │     └──────┬───────┘     │
                              │            │             │
                              │            ▼             │
                              │     ┌──────────────┐     │
                              │     │  Extraer     │     │
                              │     │  texto PDF   │     │
                              │     │  (PHP/IA)    │     │
                              │     └──────┬───────┘     │
                              │            │             │
                              │            ▼             │
                              │     ┌──────────────┐     │
                              │     │  Guardar     │     │
                              │     │  .TXT UTF-8  │     │
                              │     │  BOM         │     │
                              │     └──────┬───────┘     │
                              │            │             │
                              │            ▼             │
                              │     ┌──────────────┐     │
                              │     │  Ejecuciones │     │
                              │     │  IA (roles   │     │
                              │     │  diferenci-  │     │
                              │     │  ados)       │     │
                              │     └──────┬───────┘     │
                              │            │             │
                              │            ▼             │
                              │     ┌──────────────┐     │
                              │     │  Formulario  │     │
                              │     │  de Revisión │     │
                              │     └──────┬───────┘     │
                              │            │             │
                              │     ┌──────┴──────┐     │
                              │     │             │     │
                              │     ▼             ▼     │
                              │ ┌───────┐   ┌─────────┐ │
                              │ │Cancelar│  │ Aprobar │ │
                              │ └───┬───┘   └────┬────┘ │
                              │     │            │      │
                              │     ▼            ▼      │
                              │ ┌───────┐   ┌─────────┐ │
                              │ │Confirm│  │Rechazar │ │
                              │ └───┬───┘   └────┬────┘ │
                              │     │            │      │
                              │     ▼            ▼      │
                              │ ┌──────────┐ ┌────────┐│
                              │ │Borrar    │ │Borrar  ││
                              │ │todo salvo│ │sub-    ││
                              │ │log       │ │carpeta ││
                              │ └──────────┘ └────────┘│
                              │                        │
                              │                        ▼
                              │                 ┌─────────────┐
                              │                 │Guardar texto│
                              │                 │en WP        │
                              │                 └──────┬──────┘
                              │                        │
                              │                        ▼
                              │                 ┌─────────────┐
                              │                 │Guardar      │
                              │                 │imágenes en  │
                              │                 │BMWP         │
                              │                 └──────┬──────┘
                              │                        │
                              │                        ▼
                              │                 ┌─────────────┐
                              │                 │API WooCommerce│
                              │                 │Crear producto │
                              │                 └──────┬──────┘
                              │                        │
                              │              ┌─────────┴─────────┐
                              │              │                   │
                              │              ▼                   ▼
                              │        ┌──────────┐      ┌──────────┐
                              │        │  ÉXITO   │      │  FALLO   │
                              │        └────┬─────┘      └────┬─────┘
                              │             │                 │
                              │             ▼                 ▼
                              │       ┌──────────┐    ┌──────────────┐
                              │       │Mensaje   │    │Mensaje error │
                              │       │éxito +   │    │"Avise al     │
                              │       │enlace    │    │admin"        │
                              │       │producto  │    └──────────────┘
                              │       └──────────┘           │
                              │                              ▼
                              │                       ┌──────────────┐
                              │                       │Mantener      │
                              │                       │archivos en   │
                              │                       │subcarpeta    │
                              │                       └──────────────┘
                              │
                              ▼
                       ┌──────────────┐
                       │  Formulario  │
                       │  carga PDF   │
                       │  (nuevo      │
                       │   ciclo)     │
                       └──────────────┘
```

**Descripción detallada del flujo:**

1. **Inicio en WA:** el usuario accede a la Web-App externa.

2. **Login:** validación de credenciales contra WordPress. Cualquier usuario con rol superior a "suscriptor" puede acceder.

3. **Formulario de carga PDF:** el usuario selecciona el archivo PDF a procesar.

4. **Botón "Procesar Producto":** inicia el ciclo de trabajo asociado al PDF.

5. **Subida del PDF:** el archivo se transfiere a la WA.

6. **Creación de subcarpeta:** se crea una subcarpeta dentro de `DIR_ALMACEN_PDF` con el nombre exacto del PDF.

7. **Guardado del PDF:** el archivo PDF se almacena en la subcarpeta creada.

8. **Extracción de texto:** se procesa el PDF para obtener el contenido textual (mediante PHP o IA, decisión pendiente).

9. **Guardado de .TXT:** el texto extraído se guarda como archivo `.TXT UTF-8 BOM` en la subcarpeta.

10. **Ejecuciones de IA:** se realizan múltiples llamadas a IA con roles diferenciados para interpretar y transformar el contenido.

11. **Formulario de Revisión:** el usuario ve los resultados generados por IA, puede corregir, completar y subir imágenes complementarias.

12. **Decisiones del usuario:**
    * **Cancelar:** durante la ejecución (antes de revisión), con confirmación. Borra todo salvo el log.
    * **Aprobar:** autoriza el tramo final de publicación.
    * **Rechazar:** descarta todo el contenido, borra la subcarpeta, conserva solo el log.

13. **Tramo final de publicación (tras aprobación):**
    * Guardado del texto PDF en WordPress.
    * Guardado de imágenes (extraídas y manuales) en la Biblioteca de Medios de WordPress.
    * Llamada a API de WooCommerce para crear/publicar el producto.

14. **Resultado final:**
    * **Éxito:** mensaje de éxito + enlace a vista pública del producto (target="_blank").
    * **Fallo:** mensaje estándar de error indicando "avise al admin". Se mantienen los archivos en la subcarpeta para revisión del admin.

15. **Nuevo ciclo:** el usuario puede procesar otro PDF o cerrar sesión.

---

### 15. Tramo previo a la intervención posterior de IA

Antes de que intervenga la IA que trabaja sobre el texto extraído, el flujo entendido es:

| Paso | Acción                                                                             |
| ---- | ---------------------------------------------------------------------------------- |
| 1    | Login del usuario en la WA                                                         |
| 2    | Clic en **“Procesar Producto”**                                                    |
| 3    | Formulario para subir PDF                                                          |
| 4    | PDF subido                                                                         |
| 5    | Se obtiene el nombre del archivo                                                   |
| 6    | Se crea una subcarpeta dentro de `DIR_ALMACEN_PDF` con el mismo nombre del archivo |
| 7    | Se guarda el PDF en esa subcarpeta                                                 |
| 8    | Se procesa el PDF para obtener el texto                                            |
| 9    | El texto PDF se guarda como `.TXT UTF-8 BOM` en la subcarpeta del PDF              |
| 10   | El archivo `.TXT UTF-8 BOM` se pasa a la IA                                        |
| 11   | Queda pendiente decidir si el texto se obtiene con IA o con extensión/librería PHP |
| 12   | Después se ejecutarán los pasos posteriores ya recogidos en el flujo general       |

* La parte posterior no se reproduce dentro de este tramo.

* Este tramo pertenece a la preparación del contenido antes de que la IA trabaje con el texto extraído.

### 16. Subcarpeta del proceso y nombre del PDF

Cuando se sube un PDF:

* se obtiene el nombre del archivo;
* se crea una subcarpeta dentro de `DIR_ALMACEN_PDF`;
* esa subcarpeta debe usar el **nombre exacto del PDF**.

No se contempla, en este momento, normalizar, transformar o reinterpretar el nombre del archivo, se usa tal y  como está en el PDF.

* La subcarpeta funciona como espacio asociado al proceso/PDF.

* En esa subcarpeta se guarda el PDF.

* En esa subcarpeta se guarda el archivo `.TXT UTF-8 BOM` generado tras obtener el texto del PDF.

* En esa subcarpeta también se guardarán imágenes subidas manualmente por el usuario durante la revisión (formulario de revisión).

* Si el usuario rechaza o desaprueba el resultado, la subcarpeta creada se borra con todo su contenido.

* Si el usuario cancela antes de la revisión/aprobación y confirma la cancelación, se borra todo salvo el log.

* Si el proceso termina con éxito en WooCommerce, la subcarpeta del PDF debe conservarse.

* En caso de éxito, la subcarpeta debe conservarse con todo su contenido.

* Si falla el guardado del texto en WP, el guardado de imágenes como media o la API-WooC dentro del tramo final posterior a la aprobación, todos los archivos se mantienen en la subcarpeta.

| Resultado del proceso                  | Tratamiento de la subcarpeta                     |
| -------------------------------------- | ------------------------------------------------ |
| Cancelación confirmada                 | Se borra lo generado salvo el log                |
| Rechazo/desaprobación                  | Se borra la subcarpeta con todo su contenido     |
| Éxito en WooCommerce                   | Se conserva la subcarpeta con todo su contenido  |
| Fallo tras aprobación en WP/media/APIW | Se mantiene la subcarpeta con todos los archivos |

---

### 17. Control por nombre de PDF ya procesado

Aunque se considera que no debería ocurrir, debe existir un control si se intenta procesar un PDF con un nombre ya usado (por eso es necesario  mantener el  nombre de la subcarpeta igual al  del PDF).

El comportamiento esperado es:

* detectar que ya se ha procesado un archivo con ese nombre;
* advertir al usuario;
* evitar que el caso pase desapercibido.

Si se detecta que ya se ha procesado un archivo con el mismo nombre:

* el proceso debe **impedir continuar**;
* no se deja al usuario decidir si continúa;
* se entiende como un bloqueo preventivo;
* evita duplicidades o conflictos asociados al nombre exacto del PDF.

Este control se aplica aunque se considere que, en condiciones normales, no debería ocurrir.

---

### 18. Formulario de revisión en la WA

* La revisión final la realiza el **usuario que ejecuta el proceso**.

* La revisión manual no es meramente una validación binaria, sino un punto de control con capacidad de edición y decisión.

El formulario de revisión es el espacio donde el usuario ve y trabaja con los resultados generados por los distintos roles de IA.

* El usuario verá todos los bloques/resultados generados por distintos roles de IA.

* Los bloques/resultados deben presentarse en un formulario.

* El diseño concreto del formulario se diseñará con el desarrollador, fuera de este boceto.

* El usuario podrá corregir cosas en el formulario.

* En el formulario, el usuario tendrá la posibilidad de subir imágenes.

* Las imágenes subidas por el usuario se guardarán en la subcarpeta del PDF.

* Las imágenes subidas manualmente por el usuario se añaden como imágenes complementarias para el  producto en WooC.

* Las imágenes subidas manualmente no sustituyen a las imágenes extraídas del PDF.

* El usuario debe poder ver en el formulario las imágenes extraídas del PDF junto con las imágenes manuales complementarias antes de aprobar.

* Las imágenes, igual que el resto del formulario, quedan incluidas en la aprobación global del usuario.

* La aprobación del formulario debe entenderse siempre como aprobación de todo el contenido mostrado que será enviado/publicado.

* Si el usuario aprueba, todo el contenido del formulario será para la API-WooC.

* Si el usuario desaprueba, todo el contenido del formulario se descarta, no se ejecuta API-WooC y se borra la subcarpeta del PDF.

---

### 19. Subida manual de imágenes durante la revisión

Durante la revisión en el formulario, el usuario podrá subir imágenes.

Estas imágenes:

* se incorporan al formulario;
* se guardan en la subcarpeta del PDF;
* se añaden como imágenes a la BMWP;
* no sustituyen a las imágenes extraídas del PDF;
* forman parte del contenido que podrá acabar enviándose a WooCommerce si el usuario aprueba.

* Las imágenes extraídas del PDF son **imágenes del producto**.

* Las imágenes manuales subidas por el usuario son complementarias  pero tambien son **imágenes del producto**.

---

### 20. Aprobación y envío a API-WooC

Si el usuario aprueba:

* todo el contenido del formulario se toma como contenido final;
* todo el contenido mostrado que será enviado/publicado queda aprobado globalmente por el usuario;
* la aprobación en la WA equivale a autorización final de publicación pública;
* el texto PDF se guarda en WordPress;
* las imágenes extraídas del PDF se guardan como media en WordPress;
* las imágenes manuales complementarias también se guardan como media en WordPress;
* los enlaces de las imágenes/media se pasan a API-WooC;
* ese contenido se envía a la API-WooC;
* la API-WooC intenta crear/publicar el producto en WooCommerce;
* si la creación se completa sin fallo, el proceso finaliza con éxito.

La aprobación convierte el contenido revisado del formulario en la entrada para WooCommerce.

* La aprobación humana es anterior a la API de WooCommerce.

* La aprobación del usuario autoriza avanzar hacia WooCommerce.

* El proceso finaliza correctamente solo cuando se guarda/publica en WooCommerce mediante API y no hay fallo de guardado.

La secuencia queda entendida así:

| Momento                          | Significado                                   |
| -------------------------------- | --------------------------------------------- |
| Aprobación del usuario           | Autoriza avanzar hacia WooCommerce y publicar |
| Tramo final WP/media/APIW        | Guarda texto/media y prepara contenido final  |
| Ejecución API WooCommerce        | Intenta guardar/crear/publicar el producto    |
| Guardado correcto en WooCommerce | Marca el final exitoso del proceso            |

* El guardado en WordPress del texto PDF, el guardado de imágenes como media y la API-WooC forman parte de un único tramo final de publicación.

---

### 21. Desaprobación, rechazo y descarte

El rechazo del usuario queda situado de forma clara dentro del flujo:

* ocurre siempre en la **WA**;
* ocurre antes de cualquier llamada a WooCommerce;
* ocurre antes de ejecutar la API-WooC;
* si el usuario rechaza, no se intenta crear ningún producto en WooCommerce.

El rechazo es, por tanto, una decisión humana previa a la integración final con WooCommerce.

Si el usuario desaprueba:

* todo el contenido del formulario se descarta;
* no se ejecuta la API-WooC;
* se borra la subcarpeta del PDF;
* se elimina lo asociado al proceso salvo el log ya contemplado.

La desaprobación corta el flujo antes de WooCommerce.

Si el usuario rechaza el resultado:

* no se conserva el contenido del proceso;
* se descarta todo lo generado;
* se borra la subcarpeta creada con todo su contenido;
* se conserva únicamente el log;
* el log debe indicar que hubo descarte por parte del usuario.

Esto define una casuística importante:

| Resultado del usuario | Conservación                                       |
| --------------------- | -------------------------------------------------- |
| Aprueba               | Continúa hacia tramo final WP/media/API-WooC       |
| Rechaza               | Se borra la subcarpeta y todo su contenido         |
| Rechaza               | Se conserva solo el log con indicación de descarte |

Si el usuario rechaza el resultado:

* no se conserva nada del proceso operativo;
* se borra la subcarpeta creada;
* se borra todo su contenido;
* el PDF original también se elimina;
* el texto PDF no queda guardado en WordPress;
* únicamente se conserva el log.

El rechazo implica descarte completo de los materiales del proceso, salvo la trazabilidad mínima registrada en el log.

---

### 22. Cancelación antes de revisión/aprobación

Se incorpora una casuística adicional:

* El usuario sí puede cancelar el proceso antes de llegar a la revisión/aprobación.

* La cancelación se considera una decisión del usuario y, a la vez, una salida excepcional durante la ejecución disponible para el usuario.

* Debe quedar diferenciada del rechazo/desaprobación tanto en el log como en la casuística.

* Si cancela, se trata como un descarte/fallo operativo.

* Se debe borrar todo lo asociado al proceso en curso.

* Debe entenderse de forma alineada con el rechazo/desaprobación:

  * no continúa hacia WooCommerce;
  * no se ejecuta API-WooC;
  * se elimina lo generado;
  * se conserva el log según la lógica ya definida.

Esta cancelación queda como una salida anticipada del flujo, anterior a la revisión final.

Debe distinguirse entre:

| Situación             | Momento           | Resultado                                                                               |
| --------------------- | ----------------- | --------------------------------------------------------------------------------------- |
| Cancelación           | Antes de revisión | Se pide confirmación, se borra todo salvo el log y se vuelve al formulario de carga PDF |
| Rechazo/desaprobación | En revisión       | Se borra todo salvo el log y no se ejecuta API-WooC                                     |

La cancelación antes de revisión debe pedir confirmación al usuario.

Si el usuario confirma la cancelación:

* se corta el proceso;

* se borra todo salvo el log;

* no se ejecuta API-WooC;

* el texto PDF no se guarda en WordPress;

* se redirige al formulario de carga de PDF;

* el ciclo queda listo para empezar de nuevo con otro PDF.

* La cancelación antes de revisión puede ocurrir mientras se ejecutan los procesos, porque debe mostrarse un botón permanente para que el usuario cancele.

* El botón se mantiene mientras se ejecutan todos los procesos.

* El proceso es en bloque, sin intervención del usuario hasta el final, salvo por el botón de cancelación.

* El usuario puede pulsar el botón de cancelación cuando quiera mientras el proceso se ejecuta.

* La cancelación puede producirse incluso después de que se haya generado parte de los resultados de IA, siempre antes de la revisión final.

* Una vez se llega a la revisión final, ya no se considera cancelación: la decisión del usuario pasa a ser aprobación o desaprobación/rechazo.


---

### 23. Fallo de API WooCommerce tras aprobación

Cuando el usuario aprueba el resultado, se ejecuta la API para crear/publicar el producto en WooCommerce.

Si esa API falla:

* el proceso queda en un estado equivalente a **aprobado pero no creado en WooCommerce**;
* no se considera finalizado con éxito;
* se comunica al usuario un mensaje estándar;
* el mensaje al usuario debe indicar algo como: **error, avise al admin del sistema**;
* se guarda el log con el error devuelto por la API de WooCommerce;
* todos los archivos se mantienen en la subcarpeta;
* el admin revisará el caso.

Este caso es distinto del rechazo del usuario: aquí los datos no deben descartarse automáticamente, porque existe una aprobación humana previa y un fallo posterior de integración.

Cuando el usuario aprueba el resultado pero falla la API de WooCommerce:

* el proceso queda bloqueado;
* el usuario operativo no puede continuar ni resolver el caso;
* se le muestra un mensaje estándar de error;
* el caso pasa a revisión del admin;
* el log conserva el error devuelto por la API de WooCommerce.

Este estado debe entenderse como una situación posterior a la aprobación humana, pero anterior al final exitoso del proceso.

---

### 24. Papel del admin ante fallo API-WooCommerce o tramo final

El nivel de actuación del Admin tras el error queda fuera de la finalidad actual del proyecto.

Por ahora solo queda comprendido que:

* el admin revisa el caso;
* el log completo queda disponible para él;
* los archivos se mantienen en la subcarpeta si el fallo ocurre tras la aprobación.

---

### 25. Mensaje final tras creación correcta en WooCommerce

Cuando el usuario aprueba y la API-WooC crea correctamente el producto:

* el usuario ve un mensaje final de éxito;
* además, se muestra un enlace al producto creado en WooCommerce;
* el enlace debe apuntar a la **vista pública del producto**;
* el enlace debe abrir en una nueva pestaña o ventana mediante `target="_blank"`.

No se contempla que el usuario vea más información histórica o técnica tras el éxito.

* El producto queda publicado directamente en la web.

* La publicación pública ocurre inmediatamente tras el éxito de API-WooC.

* El enlace final a la vista pública confirma que el producto ya está publicado y visible en la web.

* El flujo de la WA termina sin más acciones tras mostrar el mensaje final y el enlace.

---


### 26. Tipo de información implicada

* El contenido procede de productos relacionados con:

  * protección contra incendios;
  * control de incendios;
  * alarma de incendios.

* Probablemente existe información con valor para crear productos, como:

  * nombres de producto;
  * descripciones;
  * características;
  * datos técnicos;
  * posibles tablas de especificaciones;
  * imágenes asociadas;
  * información comercial o clasificatoria.

* Todavía no está definido con precisión qué campos concretos deben extraerse o generarse para WooCommerce.

* La definición detallada de qué campos de producto WooCommerce genera la IA queda fuera de este boceto y se tratará en otro documento dedicado a IA o en fase posterior.

---

### 27. Elementos y herramientas que intervienen

PENDIENTE PARA EL DESARROLLADOR

| Elemento / herramienta          | Papel dentro del proyecto                                       |
| ------------------------------- | --------------------------------------------------------------- |
| Web-App externa a WordPress     | Entorno principal de operación, revisión y aprobación           |

* El detalle técnico de esas relaciones queda pendiente para el desarrollador.

---

### 28. Estados y avance visible para el usuario

Se confirma que el proceso debe mostrar avance en la WA.

Cada vez que el proceso avance, sería conveniente que el usuario vea estados secuenciales para saber:

* en qué punto se encuentra el proceso;
* si ha surgido algún error;
* cuándo ha terminado;
* si el resultado está listo para revisión;
* si puede aprobar o rechazar.

Los estados son relevantes tanto para la experiencia del usuario como para la comprensión del flujo operativo.

* Los estados deben ayudar a que el usuario conozca cómo va el proceso mientras se ejecuta.

* El avance visible debe permitir identificar:

  * inicio del proceso;
  * pasos completados;
  * pasos en curso;
  * aparición de errores;
  * finalización del proceso;
  * disponibilidad del resultado para revisión.

* Los estados concretos y los pasos correspondientes se definirán con el desarrollador.

Por tanto, en el boceto debe quedar recogido solo a nivel de comprensión que:

* el usuario verá el avance del proceso;

* se mostrarán estados o etapas mientras se ejecuta;

* los nombres concretos de los estados no quedan cerrados ahora;

* la definición detallada de estados, subestados y pasos pertenece a una fase posterior con el desarrollador.

* Al usuario solo se le muestra el nombre del paso/stage/estación del flujo que empieza a procesarse.

* Si surge un error, al usuario solo se le mostrará un mensaje estándar más una referencia asociada al error o al log completo.

* Además, debe existir un botón permanente de cancelación mientras se ejecutan los procesos, aunque el proceso funcione en bloque y sin intervención del usuario hasta la revisión final.

---

### 29. Log y visibilidad para usuario/admin

El log debe guardarse **desde el inicio del proceso (clic en botón "Procesar Producto") y paso a paso hasta el final**.

Puntos comprendidos:

* el modo exacto de guardar el log está pendiente de definir;
* el log final se guarda como histórico;
* solo el admin podrá consultar el log completo;
* el usuario operativo no ve el log técnico;
* al usuario solo se le muestra el nombre del paso/stage/estación que empieza a procesarse;
* si surge un error, el usuario verá:

  * un mensaje estándar;
  * una referencia asociada al error o al log completo.

Esto separa claramente:

| Perfil            | Qué ve                                 |
| ----------------- | -------------------------------------- |
| Usuario operativo | Estado/paso actual y mensajes estándar |
| Admin             | Histórico/log completo del proceso     |

* No hace falta crear una clasificación formal en el boceto entre:

  * visible para usuario;
  * visible para admin;
  * registrado solo en log.

La comprensión suficiente es:

| Perfil / elemento | Alcance entendido                                                              |
| ----------------- | ------------------------------------------------------------------------------ |
| Usuario           | Proceso muy acotado y simple                                                   |
| Admin             | Pleno acceso a todo                                                            |
| Log               | Ya explicado; detalle de registro y ubicación se definirá con el desarrollador |

* El detalle técnico queda pendiente para el desarrollador.

---

### 30. Dependencias críticas identificadas

| Dependencia                     | Motivo                                                                 |
| ------------------------------- | ---------------------------------------------------------------------- |
| Calidad del PDF                 | Afecta a la extracción inicial                                         |

* El detalle técnico queda pendiente para el desarrollador.

---

### 31. Errores o problemas del proceso

* En este momento no procede profundizar en errores como:

  * extracción incompleta;
  * interpretación incorrecta;
  * creación incorrecta del producto;
  * pérdida de imágenes o tablas.

* Esos aspectos pertenecen al ámbito de los resultados de los procesos/roles con IA.

* Se resolverán fuera de esta conversación.

* No obstante, el control de errores sí forma parte del contexto que debe quedar mejor definido en el boceto global del proyecto, especialmente en relación con:

  * cómo se detectan incidencias;
  * cómo se registran;
  * cómo se gestionan;
  * qué estados generan;
  * qué efecto tienen sobre el avance del proceso.

La definición detallada del control de errores se hará con el desarrollador, pero ya se identifican criterios iniciales:

| Opción                           | Criterio entendido                                      |
| -------------------------------- | ------------------------------------------------------- |
| Detener completamente el proceso | Dependerá de la gravedad del error                      |
| Permitir reintentos              | Dependerá del tipo de error                             |
| Guardar el error para revisión   | Debe ocurrir siempre                                    |
| Mantener log del proceso         | Debe existir siempre, desde el principio hasta el final |

El error no debe desaparecer ni quedar oculto: debe registrarse siempre.

* Si falla la API-WooC después de la aprobación del usuario:

  * el proceso queda bloqueado;
  * se anuncia fallo al usuario con mensaje estándar;
  * el mensaje debe indicar que avise al admin del sistema;
  * se guarda el log con el error devuelto por API-WooC;
  * todos los archivos se mantienen en la subcarpeta;
  * el admin revisará el caso.

* Si falla el guardado del texto en WP o de las imágenes como media antes de API-WooC:

  * se trata igual que fallo de API-WooC;
  * el proceso queda bloqueado;
  * se anuncia fallo al usuario con mensaje estándar;
  * se guarda el log con el error devuelto;
  * todos los archivos se mantienen en la subcarpeta;
  * el admin revisará el caso.

* Si se detecta que ya se ha procesado un archivo con el mismo nombre:

  * se impide continuar;
  * se advierte al usuario;
  * el proceso no avanza.

* Si el usuario desaprueba:

  * no se ejecuta API-WooC;
  * se borra la subcarpeta del PDF;
  * se conserva únicamente el log con indicación del descarte.

* Si el usuario cancela antes de revisión/aprobación y confirma:

  * no se ejecuta API-WooC;
  * se borra todo salvo el log;
  * se redirige al formulario de carga PDF;
  * el ciclo queda listo para empezar de nuevo.

---

### 32. Log completo del proceso

Debe existir un **log de principio a fin**.

Ese log debe permitir conocer la trayectoria completa del proceso, tanto si termina con éxito como si no.

El log debe ayudar a reconstruir:

* qué se hizo;
* cuándo se hizo;
* qué pasos se completaron;
* qué errores aparecieron;
* qué reintentos se realizaron, si los hubo;
* dónde se detuvo el proceso, si falló;
* si terminó correctamente;
* qué resultado final tuvo.

Este log es clave para trazabilidad, revisión y diagnóstico.

* El log debe existir para cada proceso iniciado desde la WA.

* El log debe conservar la trayectoria del proceso tanto en caso de éxito como en caso de error.

* El log se entiende como una pieza necesaria para saber la trayectoria completa del proceso, no solo como un registro técnico secundario.

* El log debe guardarse a medida que se va ejecutando cada paso desde el inicio.

* Cómo se guarda el log desde el inicio y paso a paso hasta el final está por definir.

* Al final, el log se debe guardar como histórico.

* Solo el admin puede consultar el log completo.

* El usuario no ve el log técnico.

* El log histórico debe registrar también la identidad del usuario que ejecutó el proceso.

Por tanto, el log debe incluir, entre otros datos:

* usuario que ejecuta el proceso;

* PDF procesado;

* pasos/estados recorridos;

* errores, si los hay;

* resultado final;

* descarte si hubo rechazo;

* cancelación si hubo cancelación antes de revisión/aprobación;
* cancelación diferenciada del rechazo/desaprobación si hubo cancelación antes de revisión/aprobación;

* error de guardado en WP/media si falló después de aprobación;

* error API-WooCommerce si falló después de aprobación.

* Queda confirmado que el log debe registrar la identidad del usuario que ejecutó el proceso.

Sin embargo, no procede definir en este boceto si esa identidad será:

* nombre de usuario/login;
* nombre visible;
* ID interno;
* cualquier otro identificador disponible en la WA.

Ese nivel de detalle excede la finalidad actual del boceto.

---

### 33. Puntos todavía poco definidos

* Qué tipos exactos de PDF existen:

  * fichas individuales;
  * catálogos;
  * manuales;
  * documentos mixtos;
  * documentos escaneados o digitales.

* Qué estructura tiene la tabla específica en WordPress.

* Qué roles de IA existen o se prevé que existan.

* Qué resultados concretos produce cada ejecución de IA.

* Qué campos de producto de WooCommerce deben generarse.

* Qué criterios usa la revisión manual final para aprobar o rechazar.

* Qué ocurre cuando la extracción es incompleta, ambigua o incorrecta.

* Si la IA detecta más de un producto en un PDF, cómo debe representarse y gestionarse esa casuística especial con el usuario y el desarrollador.

* Si un producto puede requerir información procedente de más de un PDF.

* Qué estados visibles o internos debe tener el proceso.

* Qué ocurre cuando algo falla:

  * si el proceso se detiene completamente;
  * si permite reintentos;
  * si guarda el error para revisión;
  * si depende del tipo de fallo.

* Cómo se estructura exactamente la WA.

* Qué funciones adicionales podrá tener la WA para el admin, quedando como tarea del desarrollador.

* Qué datos de configuración controla solo el admin, además de `DIR_ALMACEN_PDF`, quedando como tarea del desarrollador.

* Cómo se crean usuarios y se asignan contraseñas.

* Cómo se decide entre lector/extractor PHP, IA u otro enfoque para extraer el contenido del PDF.

* Dónde van a residir las imágenes extraídas del PDF.

* Cómo quedarán las imágenes extraídas ligadas al producto.

* Qué nivel de detalle del log será visible para el usuario, para el admin o para el desarrollador.

* Qué estados concretos se mostrarán al usuario durante el avance del proceso.

* Qué errores detienen completamente el proceso.

* Qué errores permiten reintentos.

* Qué otros parámetros de configuración de la WA existirán además de `DIR_ALMACEN_PDF`, quedando como tarea del desarrollador.

* Cómo se guardará exactamente el log desde el inicio y paso a paso hasta el final.

* Dónde se guardará exactamente el log histórico.

* Qué formato tendrá la referencia mostrada al usuario cuando haya un error.

* Cómo se diseñará el formulario de revisión.

* Qué bloques/resultados concretos de IA aparecerán en el formulario.

* Cómo se incorporarán las imágenes subidas manualmente al contenido final enviado a API-WooC.

* Cómo se gestionará internamente el estado “aprobado pero no creado en WooCommerce”.

* Qué acciones concretas podrá o no podrá hacer el admin ante un fallo de API-WooC, si se decide abordarlo más adelante.

* Qué identificador exacto del usuario se guardará en el log.

* Cómo se representará en el formulario la existencia de varios productos o varios modelos.

* Si en casos de varios productos/modelos la aprobación será global o parcial.

* Cómo se gestionará el mensaje final si la IA detecta más de un producto desde un mismo PDF, sin que esto implique publicación automática de varios productos.

---

### 34. Pendientes para definir con el desarrollador

| Pendiente                                                      | Motivo                                 |
| -------------------------------------------------------------- | -------------------------------------- |
| Diseño concreto del formulario                                 | Desarrollo/UI                          |
| Editabilidad concreta de cada bloque IA                        | Desarrollo/documento IA                |
| Representación de varios productos/modelos en formulario       | Desarrollo/UI                          |
| Representación y gestión de más de un producto detectado por IA | Desarrollo/UI                          |
| Decisión operativa del usuario cuando se detecta más de un producto | Desarrollo/UI                      |
| Aprobación global o parcial por producto/modelo                | Desarrollo/UI                          |
| Qué representa funcionalmente el formulario: vista consolidada o conjunto de bloques | Desarrollo/UI             |
| Estados concretos y subestados                                 | Desarrollo                             |
| Nombres exactos de stages/estaciones                           | Desarrollo                             |
| Funcionamiento técnico del botón de cancelación                | Desarrollo                             |
| Implementación del log                                         | Desarrollo                             |
| Ubicación/formato del log histórico                            | Desarrollo                             |
| Referencia exacta mostrada al usuario en errores               | Desarrollo                             |
| Clasificación exacta de errores                                | Desarrollo                             |
| Reintentos posibles                                            | Desarrollo                             |
| Artefactos internos de la subcarpeta                           | Desarrollo                             |
| Organización interna de PDF/TXT/imágenes/resultados/formulario | Desarrollo                             |
| Guardado exacto en WP                                          | Desarrollo                             |
| Gestión exacta de media WP                                     | Desarrollo                             |
| Paso de enlaces a APIW                                         | Desarrollo                             |
| Otros parámetros de configuración de la WA además de `DIR_ALMACEN_PDF` | Desarrollo                      |
| Funciones adicionales concretas del admin                      | Desarrollo                             |
| Acciones correctivas del admin                                 | Fuera de finalidad actual / desarrollo |
| Identificador exacto de usuario en log                         | Desarrollo                             |
| Mensaje final si se detecta más de un producto desde un PDF    | Desarrollador                          |

#### 34.1. Formulario de revisión

Queda pendiente definir con el desarrollador:

* el diseño concreto del formulario de revisión;

* cómo se organizan visualmente los bloques/resultados de IA;

* qué bloques/resultados concretos de IA aparecerán en el formulario;

* si los bloques/resultados de IA serán:

  * completamente editables;
  * parcialmente editables;
  * solo informativos;
  * no editables.

* cómo se incorporan al formulario las imágenes subidas manualmente por el usuario;

* cómo se incorporan esas imágenes al contenido final enviado a API-WooC;

* cómo se muestran las imágenes extraídas del PDF y las imágenes manuales complementarias;

* cómo se representará en el formulario la existencia de varios productos o varios modelos detectados por la IA.
* si el formulario funcionará como vista consolidada del producto, como conjunto de bloques de revisión o de otra forma.

#### 34.2. Multiplicidad de productos/modelos

Si la IA detecta varios productos o varios modelos, queda pendiente decidir con el desarrollador:

* cómo mostrar varios productos;
* cómo mostrar varios modelos;
* cómo distinguir entre un producto con varios modelos y más de un producto;
* si se revisan agrupados o separados;
* cómo se relacionan con el formulario;
* cómo se aprueban o rechazan;
* qué se envía a WooCommerce en esos casos;
* cómo se gestiona que el proceso esté orientado a crear/publicar un solo producto;
* qué decisión debe tomar el usuario si la IA detecta más de un producto;
* si la aprobación será global para todo el formulario;
* si podría existir aprobación/rechazo parcial por producto/modelo;
* cómo se mostrará el mensaje final si se detecta más de un producto desde un mismo PDF.

#### 34.3. Estados, pasos y avance del proceso

Queda pendiente definir con el desarrollador:

* los estados concretos que se mostrarán al usuario;
* los subestados, si existen;
* los nombres concretos de pasos/stages/estaciones;
* qué paso se muestra en cada momento;
* qué se considera paso iniciado;
* qué se considera paso completado;
* cómo se muestra un error durante el avance;
* qué referencia se muestra al usuario cuando haya un error;
* cómo se integra el botón permanente de cancelación durante la ejecución.

#### 34.4. Control de errores

Queda pendiente definir con el desarrollador:

* qué errores detienen completamente el proceso;
* qué errores permiten reintentos;
* qué errores generan bloqueo;
* qué errores permiten continuar;
* cómo se clasifica la gravedad del error;
* cómo se comunica cada error al usuario;
* cómo se relaciona cada error con el log;
* cómo se gestiona un fallo en el guardado del texto en WordPress después de la aprobación;
* cómo se gestiona un fallo en el guardado de imágenes/media en WordPress después de la aprobación;
* cómo se gestiona un fallo en la API-WooC después de la aprobación del usuario;
* cómo se gestiona internamente el estado “aprobado pero no creado en WooCommerce”.

#### 34.5. Log del proceso

Queda pendiente definir con el desarrollador:

* cómo se guarda exactamente el log desde el inicio;
* cómo se actualiza paso a paso;
* dónde se guarda exactamente el log histórico;
* qué formato tendrá el log;
* qué detalle exacto se registra en cada paso;
* qué referencia se mostrará al usuario en caso de error;
* qué identificador exacto del usuario se guardará en el log;
* cómo se registra la cancelación confirmada por el usuario;
* cómo se registran los fallos del tramo final WP/media/APIW.

#### 34.6. Subcarpeta del PDF y artefactos internos

No se debe profundizar ahora en detalles técnicos sobre el contenido interno exacto de la subcarpeta.

Queda pendiente para el desarrollador:

* qué artefactos temporales o internos se guardan;
* cómo se organizan dentro de la subcarpeta;
* qué se conserva exactamente en caso de éxito;
* qué se elimina exactamente en caso de rechazo, más allá de la comprensión ya fijada de borrar la subcarpeta con todo su contenido;
* qué se elimina exactamente en caso de cancelación confirmada;
* cómo se relacionan internamente PDF, TXT, imágenes, texto extraído, resultados y formulario.

#### 34.7. Papel del admin ante incidencias

En esta fase no procede definir si el admin podrá:

* reintentar el envío a WooCommerce;
* modificar datos;
* relanzar procesos;
* ejecutar acciones correctivas desde la WA.

Ese nivel de actuación queda pendiente para el desarrollador si se decide abordarlo más adelante.

También queda pendiente para el desarrollador:

* qué funciones adicionales concretas podrá tener la WA para el admin;
* qué acciones operativas adicionales podrá realizar el admin dentro de la WA;
* cómo se materializa el pleno acceso del admin sin entrar en detalle técnico en este boceto.

#### 34.8. Extracción del PDF

Queda pendiente decidir con el desarrollador:

* si el texto del PDF se obtiene mediante IA;
* si el texto del PDF se obtiene mediante extensión/librería PHP;
* si se usa una combinación de enfoques;
* cómo afecta esa decisión al flujo previo a los roles posteriores de IA.

#### 34.9. WordPress, media y API-WooCommerce

Queda pendiente definir con el desarrollador:

* cómo se guarda el texto PDF en WordPress después de la aprobación;
* cómo se guardan las imágenes como media en WordPress;
* cómo se pasan los enlaces de media a API-WooC;
* cómo se relacionan PDF/imágenes como archivos/media de WP y WP-WooC;
* cómo se resuelve el fallo de guardado WP/media antes de API-WooC;
* cómo se mantienen los archivos en subcarpeta si falla ese tramo final.

---
