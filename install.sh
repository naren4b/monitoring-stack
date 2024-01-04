#! /bin/bash

name=$1
default_value="demo"
name=${name:-$default_value}

source run-alertmanager.sh $name
source run-prometheus.sh $name
source run-node-exporter.sh $name
source run-grafana.sh $name
source run-vmagent.sh $name
source run-victoria-metrics.sh $name

docker ps | grep -E "STATUS|$name"


