#!/bin/bash
remoteWrite_url="http://localhost:8428/api/v1/write"
cat <<EOF >${PWD}/$vmagent_name/Dockerfile
FROM victoriametrics/vmagent
ENTRYPOINT ["/vmagent-prod"]
CMD ["-remoteWrite.url=$remoteWrite_url" , "-remoteWrite.forceVMProto","-promscrape.config=/etc/prometheus/prometheus.yml"]
EOF

docker build -t victoriametrics/vmagent:$vmagent_name ${PWD}/$vmagent_name/
rm -rf ${PWD}/$vmagent_name/Dockerfile

cat <<EOF >${PWD}/$vmagent_name/prometheus.yml
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

docker volume create vmagentdata
docker rm ${vmagent_name} -f

docker run -d --restart unless-stopped --network host \
  --name=${vmagent_name} \
  -v ${PWD}/$vmagent_name:/etc/prometheus/ \
  -v vmagentdata:/vmagentdata \
  victoriametrics/vmagent:$vmagent_name

docker ps -l
