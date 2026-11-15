//======================================================================================================
//EJERCICIO: Practicing aws kinesis data streams - producers
//OBJETIVO:  Entender cómo funciona aws kinesis data streams - producers
//TECNOLOGÍA: Java
//======================================================================================================
//
//DESCRIPCIÓN DEL RETO:
//
//1. Configuración de KPL en Java
//------------------------------------------------------------------------------------------------------

import com.amazonaws.services.kinesis.producer.KinesisProducer;
import com.amazonaws.services.kinesis.producer.KinesisProducerConfiguration;
import java.nio.ByteBuffer;

KinesisProducerConfiguration config = new KinesisProducerConfiguration()
    .setRegion("us-east-1")
    .setRecordMaxBufferedTime(100) // Retiene máximo 100ms para empaquetar
    .setMaxConnections(24);

KinesisProducer producer = new KinesisProducer(config);

// Envío asíncrono y optimizado con Aggregation + Collection
ByteBuffer data = ByteBuffer.wrap("datos_transaccion_binarios".getBytes());
producer.addRecord("bank-transactions-stream", "ACC-98421", data);
