//======================================================================================================
//EJERCICIO: Practicing aws kinesis data streams - producers
//OBJETIVO:  Entender cómo funciona aws kinesis data streams - producers
//TECNOLOGÍA: Java
//======================================================================================================
//
//DESCRIPCIÓN DEL RETO:
//
//1. Suscripción con HTTP/2 usando el SDK de AWS v2 para Java
//------------------------------------------------------------------------------------------------------

import software.amazon.awssdk.services.kinesis.KinesisAsyncClient;
import software.amazon.awssdk.services.kinesis.model.SubscribeToShardRequest;
import software.amazon.awssdk.services.kinesis.model.SubscribeToShardResponseHandler;

KinesisAsyncClient kinesisAsyncClient = KinesisAsyncClient.create();

SubscribeToShardRequest request = SubscribeToShardRequest.builder()
    .consumerARN("arn:aws:kinesis:us-east-1:123456789012:stream/bank-stream/consumer/AnalyticsApp:1620000000")
    .shardId("shardId-000000000000")
    .startingPosition(s -> s.type("LATEST"))
    .build();

// Conexión push por HTTP/2 que recibe eventos asíncronos en tiempo real (~70 ms)
kinesisAsyncClient.subscribeToShard(request, SubscribeToShardResponseHandler.builder()
    .onError(throwable -> System.err.println("Error en stream: " + throwable.getMessage()))
    .onEventStream(publisher -> publisher.subscribe(event -> {
        System.out.println("Registros recibidos vía PUSH: " + event.records().size());
    }))
    .build());