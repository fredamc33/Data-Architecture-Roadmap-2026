//======================================================================================================
//EJERCICIO: Practicing spark-kinesis-redshift
//OBJETIVO:  Entender la integración de Spark con Kinesis y Redshift
//TECNOLOGÍA: Scala
//======================================================================================================
//
//DESCRIPCIÓN DEL RETO:
//
//1. Ingesta desde Kinesis con Structured Streaming y Carga del resultado a Amazon Redshift (vía S3 Staging)
//------------------------------------------------------------------------------------------------------

import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions._

val spark = SparkSession.builder()
  .appName("KinesisToRedshiftPipeline")
  .getOrCreate()

// 1. Leer stream continuo desde Amazon Kinesis Data Streams
val kinesisDF = spark.readStream
  .format("kinesis")
  .option("streamName", "telemetry-events-stream")
  .option("region", "us-east-1")
  .option("initialPosition", "LATEST")
  .load()

// 2. Parsear el payload JSON y aplicar agregación en ventana temporal de 1 hora
val processedDF = kinesisDF
  .selectExpr("CAST(data AS STRING) as json_payload")
  .select(from_json($"json_payload", schema).as("data"))
  .select("data.*")
  .groupBy($"device_type", window($"event_time", "1 hour"))
  .count()
  
// 3. Escribir el resultado transformado a una tabla de Amazon Redshift
processedDF.writeStream
  .format("io.github.spark_redshift_community.spark.redshift")
  .option("url", "jdbc:redshift://redshift-cluster.amazonaws.com:5439/analytics_db")
  .option("dbtable", "public.device_hourly_counts")
  .option("tempdir", "s3://my-data-lake-staging-bucket/redshift_temp/")
  .option("aws_iam_role", "arn:aws:iam::123456789012:role/RedshiftS3AccessRole")
  .start()