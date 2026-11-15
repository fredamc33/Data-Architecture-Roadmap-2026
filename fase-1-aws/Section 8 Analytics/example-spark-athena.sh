#======================================================================================================
#EJERCICIO: Practicing spark-athena
#OBJETIVO:  Amazon Athena for Apache Spark
#TECNOLOGÍA: Bash
#======================================================================================================
#
#DESCRIPCIÓN DEL RETO:
#
#1. Automatización por AWS CLI para iniciar una sesión y cálculo Spark
#------------------------------------------------------------------------------------------------------

# 1. Crear una sesión interactiva en Athena asignando DPUs
aws athena start-session \
    --work-group "spark-analytics-wg" \
    --engine-configuration "CoordinatorDpuSize=1,MaxConcurrentDpus=20" \
    --notebook-version "JupyterLab-1.0"

# 2. Enviar la ejecución de un script de cálculo
aws athena start-calculation-execution \
    --session-id "12345678-abcd-1234-abcd-1234567890ab" \
    --code-block "df = spark.read.parquet('s3://my-data-lake/orders/'); df.show()"