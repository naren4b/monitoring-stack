#! /bin/bash

name=$1
default_value="demo"
name=${name:-$default_value}

#scanner-grafana
grafana_name=${name}-grafana
grafana_host_port=3000
docker rm ${grafana_name} -f
docker run -d --restart unless-stopped --network host \
    --name=${grafana_name} \
    -v ${PWD}/${grafana_name}/plugins:/var/grafana/plugins \
    -v ${PWD}/${grafana_name}/provisioning:/etc/grafana/provisioning \
    grafana/grafana

docker ps -l

