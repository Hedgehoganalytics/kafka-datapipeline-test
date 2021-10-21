#!/bin/bash
set -e

echo 'Hello!'
clickhouse-client --query='DROP DATABASE IF EXISTS graphite'
clickhouse-client --query='CREATE DATABASE graphite'
clickhouse-client --database=graphite --query='CREATE TABLE graphite.graphite_tree (`Date` Date, `Level` UInt32, `Path` String, `Deleted` UInt8, `Version` UInt32) ENGINE = MergeTree() ORDER BY (Level, Path)'
clickhouse-client --database=graphite --query='CREATE TABLE graphite.graphite (`Path` String, `Value` Float64, `Time` UInt32, `Date` Date, `Timestamp` UInt32) ENGINE = MergeTree() PARTITION BY toMonday(Date) ORDER BY (Path, Time)'
clickhouse-client --database=graphite --query='SHOW TABLES'
