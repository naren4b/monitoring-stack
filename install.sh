#! /bin/bash

name=$1
default_value="demo"
name=${name:-$default_value}

echo run-alertmanager.sh $name
source run-alertmanager.sh $name
echo "---"

echo run-prometheus.sh $name
source run-prometheus.sh $name
echo "---"

echo run-node-exporter.sh $name
source run-node-exporter.sh $name
echo "---"

echo run-grafana.sh $name
source run-grafana.sh $name
echo "---"

echo run-vmagent.sh $name
source run-vmagent.sh $name
echo "---"

echo run-victoria-metrics.sh $name
source run-victoria-metrics.sh $name
echo "---"

docker ps | grep -E "STATUS|$name"
