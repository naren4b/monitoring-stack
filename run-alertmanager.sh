#! /bin/bash

name=$1
default_value="demo"
name=${name:-$default_value}
mkdir -p alertmanager
cat <<EOF >${PWD}/alertmanager/alertmanager.yml
route:
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 1h
  receiver: 'web.hook'
receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'http://127.0.0.1:5001/'
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']
EOF

alertmanager_name=${name}-alertmanager
alertmanager_host_port=9093
mkdir -p ${alertmanager_name}

docker rm ${alertmanager_name} -f
docker run -d --restart unless-stopped --network host \
    -v ${PWD}/alertmanager:/etc/alertmanager \
    --name=${alertmanager_name} \
    prom/alertmanager

docker ps -l
