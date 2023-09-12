#!/bin/bash
set -e

clickhouse client --user default \
--password secret \
-n <<-EOSQL
    CREATE DATABASE IF NOT EXISTS vitalsigns;
    CREATE TABLE IF NOT EXISTS vitalsigns.vitalsigns
    (
        time DateTime64,
        heartRate_out Float32,
        breathRate_out Float32
    ) ENGINE = MergeTree ORDER BY (time);
    CREATE TABLE IF NOT EXISTS vitalsigns.vitalsigns_queue
    (
        time DateTime64,
        heartRate_out Float32,
        breathRate_out Float32
    ) ENGINE = Kafka('kafka1:9092', 'messages', 'clickhouse', 'JSONEachRow') settings kafka_thread_per_consumer = 0, kafka_num_consumers = 1;
    CREATE MATERIALIZED VIEW IF NOT EXISTS vitalsigns.vitalsigns_mv TO vitalsigns.vitalsigns AS
    SELECT * 
    FROM vitalsigns.vitalsigns_queue;
EOSQL