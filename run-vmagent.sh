#! /bin/bash
name=$1
default_value="demo"
name=${name:-$default_value}
vmagent_name=${name}-vmagent
mkdir -p ${PWD}/$vmagent_name

remoteWrite_url="http://localhost:8428/api/v1/write"
docker build -t victoriametrics/vmagent:$vmagent_name ${PWD}/$vmagent_name/
rm -rf ${PWD}/$vmagent_name/Dockerfile

cat <<EOF > ${PWD}/$vmagent_name/relabel.yml
- target_label: "node"
  replacement: "local"
EOF

cat <<EOF >${PWD}/$vmagent_name/prometheus.yml
scrape_configs:
  - job_name: 'federate'
    scrape_interval: 15s

    honor_labels: true
    metrics_path: '/federate'

    params:
      'match[]':
        - '{service="naren"}'
        - '{__name__=~"up|vm_.*"}'
    static_configs:
      - targets:
          - localhost:9090
EOF

docker volume create vmagentdata
docker rm ${vmagent_name} -f

docker run -d --restart unless-stopped --network host \
  --name=${vmagent_name} \
  -v ${PWD}/$vmagent_name:/etc/prometheus/ \
  -v ${PWD}/vma:/opt/ \
  -v vmagentdata:/vmagentdata \
  victoriametrics/vmagent -remoteWrite.url=$remoteWrite_url -remoteWrite.urlRelabelConfig=/etc/prometheus/relabel.yml -remoteWrite.forceVMProto -promscrape.config=/etc/prometheus/prometheus.yml -remoteWrite.tlsCAFile=/opt/ca.crt -remoteWrite.tlsCertFile=/opt/vmagent-client-tls.crt -remoteWrite.tlsKeyFile=/opt/vmagent-client-tls.key -remoteWrite.tlsInsecureSkipVerify=false

docker ps -l
