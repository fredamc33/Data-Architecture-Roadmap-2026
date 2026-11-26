## Sección 9 - Application Integration 🚀



### 🔑 Conceptos Clave Dominados:
- **193. Intro: Application Integration:** 
- **194. Amazon SQS:** servicio de colas de mensajes completamente administrado
1. Tipos de Colas: Standard (ilimitado, Entrega al menos una vez, Ordenamiento de mejor esfuerzo) vs. FIFO (Menor rendimiento, procesamiento estrictamente ordenado y entrega exactamente una vez)
2. Ciclo de Vida de los Mensajes y SQS Extended Client: Producing (un mensaje tiene body en XML JSON o texto, hasta 1MB, opcionalmente metadatos y delay), Consuming (polling para extraer lotesde mensajes, los procesan y luego los eliminan) y SQS Extended Client (para mensajes > 1MB, en el mensaje se guarda un puntero que apunta a S3 que es donde se guarda el mensaje pesado)
3. Casos de Uso, Límites y Seguridad: Casos de Uso (procesamiento asíncrono de pagos, sistemas de votación, envío de correos), Límites Operativos (max de 120,000 mensajes en in-flight, Batch Request -> max 10 mensajes, retención de datos 1 a 14 días, y facturación por solicitud API y uso de red), Seguridad (Cifrado en tránsito -> endpoints HTTPS, cifrado en reposo opcional mediante SSE con KMS pero solo el cuerpo del mensaje, políticas de IAM, SQS Queue Access Policies para control granular por IP u horario)

- **195. Amazon Kinesis Data Streams vs. Amazon SQS:** actúan como intermediarios para mover mensajes y eventos entre componentes, pero Kinesis es una plataforma de ingesta y transmisión continua -> múltiples aplicaciones lean y analicen los mismos datos en tiempo real, mientras que SQS es un servicio de colas de mensajes, orientado al desacoplamiento punto a punto donde una única aplicación consumidora procesa y elimina cada mensaje.
1. Diferencias Arquitectónicas Clave: **Persistencia y Consumo Múltiple** (retención hasta 365 días, múltiples aplicaciones consuman los mismos registros simultáneamente | retención hasta 14 días, una aplicación por cola y los registros se eliminan inmediatamente después de ser consumidos), **Ordenamiento y Entrega** (Shard / Key | SQS Standard: sin garantía de orden, SQS FIFO: orden estricto mediante Group ID), **Control de Lectura y Escalamiento** (checkpointing (por ejemplo, usando KCL con DynamoDB), Streaming MapReduce, scala mediante Shards aprovisionados o On-demand | escalamiento dinámico, retrasar mensajes, 1024 KB por mensaje)
2. Casos de Uso Ideales: **Amazon SQS** (Procesamiento de órdenes de compra, procesamiento asíncrono de imágenes, autoescalamiento de trabajadores según la longitud de la cola, amortiguación y agrupamiento (buffer & batch) de mensajes para procesamiento futuro y descarga de peticiones (request offloading)), **Amazon Kinesis Data Streams** (Recolección y procesamiento rápido de logs y eventos, métricas y reportes en tiempo real, captura de datos móviles, analítica de datos en tiempo real, flujos de datos de videojuegos (gaming), procesamiento complejo de streams e ingesta continua desde dispositivos IoT)

- **196. Amazon SQS - Dead Letter Queues:** colas secundarias destinadas a almacenar mensajes que no pudieron ser procesados tras múltiples intentos.
1. Reglas de Configuración y Buenas Prácticas de DLQ: **Compatibilidad Estricta de Tipos** (ambas colas Standard o FIFO), **Período de Retención** (14 días)
2. Recuperación de Mensajes: Redrive to Source
	**Inspección y Reprocesamiento** (diagnosticar la causa raíz del fallo que puede ser por código del consumidor o caída temporal de una base de datos externa)
	**Ejecución sin Código Personalizado** (Una vez corregido, Redrive to Source permite reenviar los mensajes en lotes desde la DLQ hacia la cola de origen u otra cola)

- **198. Amazon SNS:** servicio de mensajería administrado diseñado bajo el patrón Publicación / Suscripción (Pub/Sub), resuelve la necesidad de enviar un único mensaje hacia múltiples receptores simultáneamente sin acoplar directamente al emisor con cada destino.
1. Arquitectura Pub/Sub, Suscriptores y Límites: Distribución y Filtrado (Cada suscriptor asociado a un Topic recibe todos los mensajes publicados en él). Tipos de Suscriptores (Amazon SQS, funciones AWS Lambda, Kinesis Data Firehose, correos electrónicos, mensajes SMS y notificaciones móviles, y endpoints HTTP(S)). Escalabilidad (100,000 topics por cuenta y hasta 12,500,000 suscripciones por topic).
2. Integraciones Nativas y Métodos de Publicación: Integración con Servicios AWS (Múltiples servicios pueden publicar eventos, CloudWatch Alarms, AWS Budgets, Lambda, Auto Scaling Groups, eventos de S3 Buckets, DynamoDB, CloudFormation, AWS DMS y RDS). Formas de Publicar (Topic Publish y Direct Publish).
3. Seguridad en Amazon SNS: Cifrado (en tránsito obligatorio -> HTTPS, cifrado en reposo -> AWS KMS). Control de Acceso (políticas de IAM, SNS Access Policies).

- **199. Amazon SNS - with SQS Fan Out:** combina la capacidad de distribución masiva de Amazon SNS con la persistencia y resiliencia de Amazon SQS (SNS -> SNS Topic -> múltiples SQS suscritas).
1. Arquitectura y Casos de Uso del Patrón Fan Out: Requisitos y Alcance del Fan Out (SQS Queue Access Policy autoriza a SNS Topic, Cross-Region Delivery o SQS en otras regiones). Eventos de Amazon S3 a Múltiples Destinos (se envía primero el evento a un SNS Topic y se aplica Fan Out). Ingesta hacia S3 vía Kinesis Data Firehose (SNS puede enviar mensajes directamente a un flujo de Amazon Kinesis Data Firehose, permitiendo consolidar y almacenar notificaciones en Amazon S3)
2. Amazon SNS FIFO y Fan Out Ordenado: SNS FIFO Topic (Garantiza el ordenamiento estricto mediante Message Group ID). SNS FIFO + SQS FIFO Fan Out (arquitectura indicada cuando un sistema requiere simultáneamente distribución a múltiples consumidores (fan out)).
3. Filtrado de Mensajes (SNS Message Filtering): Políticas JSON de Suscripción (adjunta una política de filtrado en formato JSON a cada suscripción de un SNS Topic). Comportamiento por Defecto (Si una suscripción no tiene configurada una política de filtrado, recibirá absolutamente todos los mensajes publicados en el topic).

- **201. AWS Step Functions:** orquestación serverless que permite diseñar, coordinar y visualizar flujos de trabajo distribuidos mediante State Machines definidas en lenguaje JSON llamado Amazon States Language (ASL)
1. Capacidades Fundamentales de la Máquina de Estados: Visualización e Historial de Auditoría (registro auditable detallado de cada transición). Manejo Avanzado de Errores fuera del Código (Catch y Retry). Temporización y Duración (Wait, 1 año).
2. Patrones de Orquestación Integrados (Ejemplos Reales): se integra de forma síncrona y asíncrona con múltiples servicios de AWS (Entrenamiento de Modelos ML, Ajuste de Hiperparámetros, Gestión de Trabajos por Lotes)

- **202. AWS Step Functions: State Machines and States:** todo el workflow recibe el nombre de State Machine, y cada paso individual dentro de ese flujo constituye un State (Estado)
Tipos de Estados (Task, Choice, Wait, Parallel, Map - estado más relevante para la ingeniería de datos. Y Pass, Succeed y Fail). 

- **203. Amazon AppFlow:** permite transferir datos de forma bidireccional y segura entre aplicaciones de Software como Servicio (SaaS) y servicios de AWS, eliminando la necesidad de escribir código personalizado o gestionar conectores API manualmente.
1. Orígenes (Sources) y Destinos (Destinations): Orígenes Soportados (Salesforce, SAP, Zendesk, Slack, ServiceNow, Amazon S3, Amplitude, Datadog, Dynatrace, Google Analytics, Infor Nexus, Marketo y Salesforce Pardot). Destinos Soportados (Amazon S3, Amazon Redshift y Amazon Lookout for Metrics; externos como Snowflake, Salesforce, Marketo, Upsolver y Zendesk)
2. Frecuencia de Ejecución, Transformaciones y Seguridad: Modos de Ejecución (Frequency) (on demand, on a schedule, in response to events). Capacidades de Transformación (no es necesario levantar un cluster ETL). Seguridad y Conectividad Privada (cifrado en tránsito y en reposo, Internet público cifrado o mediante AWS PrivateLink)

- **204. Amazon EventBridge:** permite conectar aplicaciones mediante eventos generados por servicios de AWS, socios SaaS integrados y aplicaciones personalizadas, enrutándolos en tiempo real hacia destinos específicos mediante reglas declarativas.
1. Disparadores y Reglas (EventBridge Rules): Schedule (ejecutar acciones de forma periódica). Event Pattern (Reacciona en tiempo real cuando un servicio de AWS realiza una acción específica). Filtrado y Destinos (Las reglas enrutan hacia múltiples categorías de destinos: Cómputo, Integración, Orquestación y Mantenimiento).
2. Tipos de Buses de Eventos, Archivado y Replay: Default Event Bus, Partner Event Bus, Custom Event Bus.
3. Schema Registry y Políticas Basadas en Recursos: Schema Registry (puede analizar automáticamente el tráfico de eventos para inferir su estructura) y Resource-based Policies (gestionar permisos a nivel de un Event Bus específico para autorizar o denegar el envío de eventos desde otras cuentas o regiones de AWS).

- **206. Amazon Managed Workflows for Apache Airflow (Amazon MWAA):** permite desarrollar, programar y monitorear flujos de trabajo complejos orientados al procesamiento por lotes. Se definen mediante código Python estructurado como Grafos Acíclicos Dirigidos (DAGs).
1. Operación y Despliegue en AWS: Almacenamiento en Amazon S3 (archivos Python de los DAGs, plugins, requirements.txt). Redes y Seguridad (se despliega dentro de una VPC distribuida en al menos 2 Zonas de Disponibilidad). Auto Scaling (escalan automáticamente hasta los límites máximos configurados por el usuario).
2. Arquitectura Interna e Integraciones: Infraestructura Serverless en Contenedores (Schedulers y Workers se ejecutan como contenedores, AWS Fargate, Customer VPC, Amazon ECR, S3, SQS, CloudWatch, AWS KMS). VPC del Servicio (). Ecosistema de Integraciones (Athena, Batch, CloudWatch, DynamoDB, DataSync, EMR, Fargate, EKS, Kinesis, Glue, Lambda, Redshift, SQS, SNS, SageMaker, S3 y AWS Secrets Manager).








