---
name: sainapsis-bridge-context
description: >
  Contexto de negocio del producto Bridge (bridge.new), desarrollado por Sainapsis. Usa esta skill SIEMPRE que trabajes en cualquier tarea relacionada con Bridge o Sainapsis: escribir código, diseñar features, tomar decisiones de producto, redactar documentación, crear contenido, responder preguntas sobre la app, revisar PRs, planificar sprints, nombrar variables o módulos, definir arquitectura, o cualquier tarea donde entender el negocio, la terminología interna o las funcionalidades sea relevante. Si el usuario menciona "Bridge", "Sainapsis", "internals", "externals", "briefings", "broadcasts", "tasks", "workspaces", "accounts", chats, WhatsApp empresarial, gestión de clientes, secciones de chat, contactos, llamadas, file repository, tareas, agentes personalizados, o cualquier feature de la plataforma, consulta esta skill.
---

# Bridge — Contexto de Negocio

Bridge es el producto principal de Sainapsis. Es una plataforma AI-powered que centraliza todas las comunicaciones de una empresa (chats, emails, llamadas) en un solo lugar para que tengan visibilidad completa y en tiempo real de lo que pasa con sus clientes. La app vive en https://app.bridge.new.

Sainapsis es la empresa detrás de Bridge. Está certificada en SOC 2 Type 2, GDPR e ISO 27001. Los principios de ingeniería son calidad, seguridad e innovación, con AI integrada en el núcleo del producto. El código debe ser escalable, seguro y de alta disponibilidad. Bridge está disponible en Web, iOS, Android y Desktop (Windows y Mac), es 100% cloud-based sobre AWS. La autenticación es nativa con Microsoft 365, Google G Suite, o usuario y contraseña. Para WhatsApp se requiere una cuenta verificada de Meta Business.


## Qué resuelve Bridge

Bridge existe porque las empresas no saben qué está pasando con sus clientes. Los chats, emails y llamadas viven en múltiples apps, el CRM queda desactualizado y la visibilidad desaparece. Esto afecta las decisiones, el servicio y la seguridad de los datos.

Bridge lo resuelve poniendo todo en un solo lugar con AI que analiza todo en tiempo real. Los tres resultados principales son: equipos más productivos porque no saltan entre apps, mejor visibilidad que lleva a mejores decisiones y más ventas, y soporte más rápido que genera clientes más felices y menos churn.

Bridge está pensado para empresas donde las relaciones con clientes son gestionadas por humanos: banca, B2B con relationship managers, firmas legales, seguros, ciencias de la vida y la salud, y cualquier B2C con trato directo. No es para call centers transaccionales puros.

Un diferenciador clave es la propiedad corporativa de los datos. Cuando un empleado se va, toda su información y conversaciones quedan en la empresa, accesibles para su reemplazo. Los datos pertenecen a la empresa, no al empleado.


## Estructura organizativa

Bridge se organiza en tres niveles jerárquicos. Una empresa puede tener múltiples workspaces. Cada workspace es un espacio independiente dentro de la empresa. Dentro de cada workspace hay cuentas (accounts), que son el identificador de cada internal user. Una cuenta de internal es diferente a la cuenta del workspace, son entidades separadas. Por ejemplo, una empresa podría tener 3 workspaces y cada uno con 300 cuentas diferentes. Esto permite que una misma empresa gestione equipos, sucursales o divisiones de forma separada pero bajo el mismo paraguas.


## Funcionalidades

### Mensajería (Chats)

El sistema de chats se divide en dos tipos. Los "internals" son mensajes entre usuarios dentro de la organización, como un chat corporativo. Los "externals" son mensajes con personas fuera de la organización (clientes, proveedores). El canal principal de externals es WhatsApp vía Meta Business API, pero puede ser cualquier otro canal.

En ambos tipos de chat se soportan: texto, imágenes, videos, documentos y audios. Los audios tienen transcripción automática completa, así que se pueden leer además de escuchar.

### Secciones de chat

Las conversaciones se organizan en secciones. Las default son: "Chats" que es la sección principal donde caen todas las conversaciones nuevas. "Pinned" donde las conversaciones quedan fijadas de primeras. "Archivados" donde las conversaciones se mutean y quedan al fondo. "Released" donde la conversación no es visible y se usa para liberar una línea de WhatsApp, si el external escribe por esa línea el mensaje llega por aparte y la conversación no se reactiva, esto solo aplica para externals porque los números de WhatsApp son recursos limitados.

Además de las default, el usuario puede crear secciones personalizadas para organizar sus conversaciones como quiera.

### Contactos

Los contactos son la forma en que Bridge guarda a las personas. Representan principalmente a los externals (clientes, proveedores) pero también representan de cierto modo a los internals. Son la base del directorio de personas en la plataforma.

### Llamadas

Bridge soporta llamadas dentro de los chats. Se pueden hacer llamadas entre internals y externals directamente desde la conversación. Cada llamada es procesada por un agente AI que genera automáticamente un resumen de la reunión y una transcripción completa de lo que se habló.

### Emails

Bridge integra email a través de Outlook. Se pueden enviar y recibir emails desde la plataforma y seguir el hilo completo de conversaciones por email. La composición de emails tiene herramientas de AI integradas: mejorar con AI, alargar con AI, acortar con AI, entre otras.

### Reuniones

Se pueden agendar reuniones por Microsoft Teams directamente desde Bridge. La plataforma genera el enlace de la reunión automáticamente.

### Agente AI

Bridge tiene un agente AI integrado en la app que ayuda a gestionar conversaciones, encontrar información dentro de ellas, analizar comportamientos de clientes, dar insights en tiempo real, detectar oportunidades de negocio y riesgos, y sincronizar información con el CRM.

Además del agente base, cada empresa puede crear sus propios agentes AI personalizados. Esto permite que el agente se adapte al contexto específico del negocio del cliente y mejore la calidad de la comunicación con sus clientes. Cada empresa configura su agente para que entienda su industria, su tono y sus necesidades particulares.

### Broadcasts

Funcionalidad para enviar mensajes masivos a todas las conversaciones con externals. Se usa para comunicaciones generales, campañas o avisos.

### File Repository

Repositorio de archivos dentro de Bridge. Se pueden subir y almacenar documentos para tener acceso fácil y reutilizarlos dentro de la plataforma.

### Briefings

Sistema de resúmenes para conversaciones. Permite generar informes sobre el estado y contenido de las conversaciones sin tener que leer todo el historial.

### Tareas (Tasks)

Bridge tiene un sistema de tareas centralizado a nivel de workspace. Esto significa que las tareas creadas son visibles para toda la organización dentro de ese workspace.

Las tareas se pueden crear de varias formas: manualmente, por recomendación de la AI, o a partir de un mensaje enviado en una conversación (con o sin asistencia de la AI). Se pueden asignar usuarios con sus respectivos roles y también linkear conversaciones que se consideren relacionadas con la tarea.

Cada tarea tiene estados, un historial completo de todo lo que se hace en ella, y comentarios internos. También tiene reminders, que son notificaciones que se envían según el patrón que el usuario definió. Se pueden añadir attachments tanto en la descripción como en los comentarios.

Hay varios tipos de tareas. Las "tasks" son tareas normales de gestión. Los "reminders" son tareas a modo de eventos o recordatorios con fecha.

Las tareas tienen dos vistas: una vista dentro de las conversaciones donde se pueden ver y crear tareas relacionadas al chat, y una vista de gestión separada donde se tiene control completo sobre todas las tareas del workspace.


## Terminología

"Internal" es un usuario o mensaje dentro de la organización. "External" es una persona o mensaje fuera de la organización. "Released" es un estado de chat donde se libera la línea de WhatsApp y la conversación deja de ser visible. "Pinned" es una conversación fijada al tope. "Archivado" es una conversación muteada al fondo. "Briefing" es un resumen generado sobre una conversación. "Broadcast" es un mensaje masivo a múltiples externals. "File Repository" es el almacén centralizado de archivos. "Workspace" es un espacio independiente dentro de una empresa, una empresa puede tener varios. "Account" es la cuenta de un internal user dentro de un workspace, es diferente a la cuenta del workspace en sí. "Task" es una tarea normal de gestión. "Reminder" es una tarea tipo evento o recordatorio con fecha.


## Principios para decisiones de producto y código

La seguridad es lo primero porque Bridge maneja comunicaciones sensibles de empresas. La relación humana es central, Bridge potencia al humano, no lo reemplaza, el AI asiste. Aunque los mensajes vienen de distintos canales la experiencia debe sentirse como una sola conversación fluida. Los datos pertenecen a la empresa, no al empleado, esto es diferenciador clave. La AI está en el ADN del producto, no es algo superpuesto. Todo debe sentirse como un chat simple sin importar la complejidad detrás.
