#! /bin/bash

name=$1
default_value="demo"
name=${name:-$default_value}
docker volume create victoria-metrics-data
# victoria-metrics
victoria_metrics_name=${name}-victoria-metrics
victoria_metrics_host_port=8428
docker rm ${victoria_metrics_name} -f
docker run -d --restart unless-stopped --network host \
    --name=${victoria_metrics_name} \
    -v victoria-metrics-data:/victoria-metrics-data \
    -v ${PWD}/${victoria_metrics_name}/provisioning:/etc/grafana/provisioning \
    victoriametrics/victoria-metrics

docker ps -l
