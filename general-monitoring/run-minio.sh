#! /bin/bash

name=$1
default_value="demo"
name=${name:-$default_value}
docker volume create minio-data

# minio
minio_name=${name}-minio
minio_host_port=9000,9001
docker rm ${minio_name} -f
docker run -d --restart unless-stopped --network host \
    --name=${minio_name} \
    -v minio-data:/data \
    -e "MINIO_ROOT_USER=ROOTNAME" \
    -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
    quay.io/minio/minio server /data --console-address ":9001"

docker ps -l
