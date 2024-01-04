#! /bin/bash
name=$1
default_value="demo"
name=${name:-$default_value}
prometheus_name=${name}-prometheus
mkdir -p ${PWD}/$prometheus_name
cat <<EOF >${PWD}/$prometheus_name/prometheus.yml
global:
  scrape_interval: 15s
  scrape_timeout: 10s
  evaluation_interval: 15s
scrape_configs:
  - job_name: prometheus
    metrics_path: /metrics
    scheme: http
    static_configs:
      - targets:
          - localhost:9090
  - job_name: node-exporter
    metrics_path: /metrics
    scheme: http
    static_configs:
      - targets:
          - localhost:9100
EOF

prometheus_host_port=9090
docker volume create prometheus-data
mkdir -p ${prometheus_name}
docker rm ${prometheus_name} -f
docker run -d --restart unless-stopped --network host \
  --name=${prometheus_name} \
  -v ${PWD}/$prometheus_name/:/etc/prometheus/ \
  -v prometheus-data:/prometheus \
  prom/prometheus
docker ps -l
