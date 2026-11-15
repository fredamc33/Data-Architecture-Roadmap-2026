#======================================================================================================
#EJERCICIO: Practicing aws emr serverless
#OBJETIVO:  Entender aws emr serverless
#TECNOLOGÍA: Bash
#======================================================================================================
#
#DESCRIPCIÓN DEL RETO:
#
#1. Crear Aplicación y Enviar Job en EMR Serverless
#------------------------------------------------------------------------------------------------------

# 1. Crear una aplicación EMR Serverless para Spark con capacidad pre-inicializada
aws emr-serverless create-application \
    --type "SPARK" \
    --name "DataPipelineApp" \
    --release-label "emr-6.10.0" \
    --initial-capacity '{
        "DRIVER": {
            "workerCount": 2,
            "resourceConfiguration": {"cpu": "2vCPU", "memory": "4GB"}
        },
        "EXECUTOR": {
            "workerCount": 10,
            "resourceConfiguration": {"cpu": "4vCPU", "memory": "8GB"}
        }
    }' \
    --maximum-capacity '{"cpu": "200vCPU", "memory": "800GB"}'

# 2. Enviar un Job de PySpark a la aplicación creada
aws emr-serverless start-job-run \
    --application-id "00f1a2b3c4d5e6f" \
    --execution-role-arn "arn:aws:iam::123456789012:role/EMRServerlessJobRole" \
    --job-driver '{
        "sparkSubmit": {
            "entryPoint": "s3://my-code-bucket/jobs/process_transactions.py",
            "entryPointArguments": ["s3://my-raw-data/", "s3://my-output-data/"],
            "sparkSubmitParameters": "--conf spark.executor.cores=4 --conf spark.executor.memory=8g"
        }
    }' \
    --configuration-overrides '{
        "monitoringConfiguration": {
            "s3MonitoringConfiguration": {
                "logUri": "s3://my-logs-bucket/emr-serverless-logs/"
            }
        }
    }'