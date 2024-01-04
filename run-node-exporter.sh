#! /bin/bash
text_collector_dir=/var/lib/node-exporter/textfile_collector
mkdir -p ${text_collector_dir}

cat <<EOF >/etc/cron.d/directory_size
*/5 * * * * root du -sb /var/log /var/cache/apt /var/lib/prometheus | sed -ne 's/^\([0-9]\+\)\t\(.*\)$/node_directory_size_bytes{directory="\2"} \1/p' > ${text_collector_dir}/directory_size.prom.$$ && mv ${text_collector_dir}/directory_size.prom.$$ ${text_collector_dir}/directory_size.prom
EOF
name=$1
default_value="demo"
name=${name:-$default_value}
node_exporter_name=${name}-node-exporter
node_exporter_host_port=9100

docker rm ${node_exporter_name} -f
docker run -d --restart unless-stopped --network host \
    -v ${text_collector_dir}:${text_collector_dir} \
    --name=${node_exporter_name} \
    prom/node-exporter --collector.textfile.directory=${text_collector_dir}

docker ps -l
