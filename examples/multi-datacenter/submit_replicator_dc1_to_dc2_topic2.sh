#!/bin/bash

HEADER="Content-Type: application/json"
DATA=$( cat << EOF
{
  "name": "replicator-dc1-to-dc2-topic2",
  "config": {
    "connector.class": "io.confluent.connect.replicator.ReplicatorSourceConnector",
    "topic.whitelist": "topic2",
    "topic.rename.format": "\${topic}.replica",
    "key.converter": "io.confluent.connect.replicator.util.ByteArrayConverter",
    "value.converter": "io.confluent.connect.replicator.util.ByteArrayConverter",
    "src.kafka.bootstrap.servers": "broker-dc1:9091",
    "src.consumer.group.id": "replicator-dc1-to-dc2-topic2",
    "src.consumer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor",
    "src.consumer.confluent.monitoring.interceptor.bootstrap.servers": "broker-dc2:9092",
    "src.kafka.timestamps.producer.interceptor.classes": "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor",
    "src.kafka.timestamps.producer.confluent.monitoring.interceptor.bootstrap.servers": "broker-dc2:9092",
    "dest.kafka.bootstrap.servers": "broker-dc2:9092",
    "dest.kafka.replication.factor": 1,
    "provenance.header.enable": "false",
    "offset.timestamps.commit": "true",
    "offset.topic.commit": "true",
    "header.converter": "io.confluent.connect.replicator.util.ByteArrayConverter",
    "tasks.max": "1"
  }
}
EOF
)

curl -X POST -H "${HEADER}" --data "${DATA}" http://localhost:8382/connectors
