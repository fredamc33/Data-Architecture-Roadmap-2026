## Section 7 - Containers 🚀



### 🔑 Conceptos Clave Dominados:
- **127. Intro: Containers:** 
- **128. What is Docker?:** plataforma que simplifica la creación, el envío y la ejecución de aplicaciones. Plataforma de despliegue. Empaquetado en contenedores. Comportamiento idéntico y predecible de la app. Casos de uso: microservicios, Migración Lift-and-Shift (empaquetar aplicaciones tradicionales on-premises para llevarlas rápidamente a la nube, sin reescribir código). Las imagenes de Docker se almacenan en Docker Repositories (Docker Hub, Amazon ECR). 
- Amazon Elastic Container Service (Amazon ECS): plataforma nativa y propia de AWS para orquestar y gestionar contenedores.
- Amazon Elastic Kubernetes Service (Amazon EKS): Servicio administrado de Kubernetes (tecnología open-source de orquestación de contenedores).
- AWS Fargate: Plataforma de cómputo serverless para contenedores. Elimina la necesidad de aprovisionar, configurar o escalar servidores EC2 subyacentes. Solo pagas por la memoria y CPU que consume tu contenedor.
- Amazon ECR (Elastic Container Registry): registro privado y administrado para almacenar, gestionar y desplegar imágenes de contenedores Docker.
- **129. Amazon ECS:** EC2 Launch Type te da control total sobre la infraestructura de servidores, pero a costa de asumir el trabajo operativo de parchear, administrar y escalar las instancias EC2 donde corren tus contenedores. Cada instancia EC2 (dentro del clúster) tiene instalado un ECS Agent, que se comunica con el clúster ECS.
Fargate Launch Type te libera por completo de la administración de servidores EC2. Tú solo defines la CPU y RAM que requiere tu contenedor, y AWS se encarga de ejecutarlo y escalarlo de forma 100% serverless (aprovisionar y administrar la capacidad de cómputo necesaria para ejecutar tus contenedores).
El EC2 Instance Profile otorga permisos al servidor para administrar la infraestructura y descargar los contenedores, mientras que el ECS Task Role le da permisos específicos al código de tu aplicación para interactuar de forma segura con otros servicios de AWS.
Para distribuir el tráfico en aplicaciones web modernas alojadas en ECS, la opción principal y recomendada es usar un Application Load Balancer (ALB), dejando el Network Load Balancer (NLB) para casos de rendimiento extremo y descartando el Classic Load Balancer (CLB) por ser una tecnología en desuso.
Si tus contenedores en ECS necesitan guardar datos persistentes y compartirlos en tiempo real entre múltiples tareas o zonas de disponibilidad, Amazon EFS es la solución de almacenamiento en red nativa y compatible con Fargate. Compatible tanto con el modo administrado (EC2) como con el modo serverless (Fargate).
- **130. Amazon ECS - Create Cluster - Hands On:** 
- **131. Amazon ECS - Create Service - Hands On:** 
- **132. Amazon ECR:** depósito seguro para guardar y versionar las imágenes de tu aplicación. Sirve como el punto de origen desde el cual tus servidores o servicios serverless descargan (pull) los contenedores para ponerlos a funcionar en ECS. El acceso para subir (push) o descargar (pull) imágenes está protegido por políticas de AWS IAM.
- **133. Amazon EKS:** Alternativa a ECS, mejor opción si buscas orquestar contenedores usando el estándar abierto de Kubernetes, lo que te da flexibilidad para reutilizar configuraciones en cualquier nube o migrar aplicaciones existentes desde tus propios servidores locales a AWS. 
Diagrama. Proteger los contenedores (Pods) y servidores (Nodes) en subredes privadas distribuidas en múltiples zonas, dejando únicamente los balanceadores de carga (ELB) en las subredes públicas para recibir las peticiones.
Tipos de nodos: Self-Managed Nodes para control total y personalizado, Managed Node Groups para automatizar el ciclo de vida de las instancias EC2, o AWS Fargate para eliminar por completo la gestión de infraestructura.
Te permite aprovisionar volúmenes de datos usando el estándar CSI. Dependiendo de la necesidad de tu aplicación, puedes elegir desde almacenamiento en bloques rápido (EBS) y archivos compartidos multi-AZ (EFS), hasta almacenamiento especializado para cargas pesadas de cómputo o empresarial (FSx).
- **134. Amazon EKS - Hands On:** 