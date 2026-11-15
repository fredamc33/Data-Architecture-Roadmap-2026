#======================================================================================================
#EJERCICIO: Practicing aws emr
#OBJETIVO:  Entender aws emr con aws CLI
#TECNOLOGÍA: Bash
#======================================================================================================
#
#DESCRIPCIÓN DEL RETO:
#
#1. Crear Cluster Transitorio con Steps PySpark
#------------------------------------------------------------------------------------------------------

# Crear un cluster transitorio de EMR que ejecuta un script de PySpark en S3 y se apaga al terminar
aws emr create-cluster \
    --name "Batch-ETL-Transient-Cluster" \
    --release-label emr-6.10.0 \
    --applications Name=Spark \
    --ec2-attributes KeyName=my-key-pair \
    --instance-groups \
        InstanceGroupType=MASTER,InstanceCount=1,InstanceType=m5.xlarge \
        InstanceGroupType=CORE,InstanceCount=2,InstanceType=m5.xlarge \
        InstanceGroupType=TASK,InstanceCount=4,InstanceType=m5.xlarge,BidPrice=OnDemandPrice \
    --steps Type=Spark,Name="PySpark_ETL_Step",ActionOnFailure=TERMINATE_CLUSTER,Args=[s3://my-code-bucket/scripts/etl_process.py,--input,s3://my-raw-data/,--output,s3://my-curated-data/] \
    --auto-terminate \
    --use-default-roles