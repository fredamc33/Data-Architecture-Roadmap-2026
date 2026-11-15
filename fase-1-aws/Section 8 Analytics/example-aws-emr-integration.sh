#======================================================================================================
#EJERCICIO: Practicing aws emr integration
#OBJETIVO:  Entender cómo aws emr se integra con los otros servicios de aws
#TECNOLOGÍA: Bash
#======================================================================================================
#
#DESCRIPCIÓN DEL RETO:
#
#1. Configuración de EBS como soporte para HDFS vía AWS CLI
#2. Habilitar Managed Scaling en un cluster EMR existente para optimizar costos de computación y HDFS
#------------------------------------------------------------------------------------------------------

aws emr create-cluster \
    --name "EMR-EBS-HDFS-Cluster" \
    --release-label emr-6.10.0 \
    --applications Name=Spark \
    --instance-groups '[
        {
            "InstanceCount": 1,
            "InstanceGroupType": "MASTER",
            "InstanceType": "c5.xlarge"
        },
        {
            "InstanceCount": 2,
            "InstanceGroupType": "CORE",
            "InstanceType": "c5.xlarge",
            "EbsConfiguration": {
                "EbsBlockDeviceConfigs": [
                    {
                        "VolumeSpecification": {
                            "VolumeType": "gp3",
                            "SizeInGB": 100
                        },
                        "VolumesPerInstance": 1
                    }
                ]
            }
        }
    ]' \
    --use-default-roles
	
	
	
	







aws emr put-managed-scaling-policy \
    --cluster-id "j-2AXXXXXXXXXX" \
    --managed-scaling-policy '{
        "ComputeLimits": {
            "UnitType": "Instances",
            "MinimumCapacityUnits": 2,
            "MaximumCapacityUnits": 20,
            "MaximumOnDemandCapacityUnits": 5,
            "MaximumCoreCapacityUnits": 10
        }
    }'
	