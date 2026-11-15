--======================================================================================================
--EJERCICIO: Practicing athena
--OBJETIVO:  Amazon Athena Federated Queries
--TECNOLOGÍA: SQL
--======================================================================================================
--
--DESCRIPCIÓN DEL RETO:
--
--1. Consulta un catálogo federado directamente desde la consola de Athena
--------------------------------------------------------------------------------------------------------

-- Consulta federada sobre CloudWatch Logs usando expresiones regulares
SELECT 
    log_stream AS ec2_instance,
    regexp_extract(message, '.*orderId=(\d+).*', 1) AS orderId,
    message AS order_processor_log,
    regexp_extract(message, '(.*)::*', 1) AS log_level
FROM "MyCloudwatchCatalog"."/var/ecommerce-engine/order-processor"."all_log_streams"
WHERE regexp_extract(message, '(.*)::*', 1) != 'INFO'
LIMIT 100;