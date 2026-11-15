/*
======================================================================================================
EJERCICIO: Practicing aws athena CTAS
OBJETIVO:  Entender cómo convertir un archivo CSV plano alojado en S3 a formato Parquet comprimido con Snappy
TECNOLOGÍA: SQL
======================================================================================================

DESCRIPCIÓN DEL RETO:

1. Create a table and save as parquet format
------------------------------------------------------------------------------------------------------
*/

CREATE TABLE ecommerce_db.orders_parquet
WITH (
  format = 'PARQUET',
  parquet_compression = 'SNAPPY',
  external_location = 's3://my-optimized-data-lake/orders_parquet/'
) AS 
SELECT 
    order_id,
    customer_id,
    order_date,
    total_amount
FROM ecommerce_db.orders_raw_csv
WHERE order_date >= '2026-01-01';