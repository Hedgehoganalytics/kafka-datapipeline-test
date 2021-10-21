#!/bin/bash
set -e

echo 'Hello!'

clickhouse client -n <<-EOSQL
    DROP DATABASE IF EXISTS graphite;
    CREATE DATABASE graphite;
    CREATE TABLE IF NOT EXISTS graphite.graphite_reverse (
      Path String,  
      Value Float64,  
      Time UInt32,  
      Date Date,  
      Timestamp UInt32
    ) ENGINE = GraphiteMergeTree('graphite_rollup')
    PARTITION BY toYYYYMM(Date)
    ORDER BY (Path, Time);
    
    CREATE TABLE IF NOT EXISTS graphite.graphite_index (
      Date Date,
      Level UInt32,
      Path String,
      Version UInt32
    ) ENGINE = ReplacingMergeTree(Version)
    PARTITION BY toYYYYMM(Date)
    ORDER BY (Level, Path, Date);

    CREATE TABLE IF NOT EXISTS graphite.graphite_tagged (
      Date Date,
      Tag1 String,
      Path String,
      Tags Array(String),
      Version UInt32
    ) ENGINE = ReplacingMergeTree(Version)
    PARTITION BY toYYYYMM(Date)
    ORDER BY (Tag1, Path, Date);
EOSQL
