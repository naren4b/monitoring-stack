name=$1
default_value="demo"
name=${name:-$default_value}
vmagent_name=${name}-vmagent
vmagent_host_port=8429
mkdir -p ${PWD}/$vmagent_name

remoteWrite_url="https://localhost:8428/api/v1/write"
cd
cat <<EOF >${PWD}/$vmagent_name/Dockerfile
FROM victoriametrics/vmagent
ENTRYPOINT ["/vmagent-prod"]
CMD ["-remoteWrite.url=$remoteWrite_url"]
EOF

docker build -t victoriametrics/vmagent:$vmagent_name .
rm -rf ${PWD}/$vmagent_name/Dockerfile

cat <<EOF >${PWD}/$vmagent_name/prometheus.yml
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

docker volume create vmagentdata
docker rm ${vmagent_name} -f

docker run -d --restart unless-stopped --network host \
  --name=${vmagent_name} \
  -v ${PWD}/$vmagent_name/:/etc/prometheus/ \
  -v vmagentdata:/vmagentdata \
  victoriametrics/vmagent:$vmagent_name

docker ps -l
