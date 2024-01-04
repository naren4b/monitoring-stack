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

docker run --privileged -v ${PWD}:/tmp -it --network host --entrypoint=/bin/sh minio/mc

S3_ALIAS=demo
S3_ENDPOINT=http://localhost:9000
ACCESS_KEY=ROOTNAME
SECRET_KEY=CHANGEME123
BUCKET_NAME=data
mc alias set $S3_ALIAS $S3_ENDPOINT $ACCESS_KEY $SECRET_KEY --api "s3v4" --path "auto"

mc --insecure rm -r --force $S3_ALIAS/$BUCKET_NAME
mc --insecure mb $BUCKET_NAME

#rf: https://github.com/minio/minio/issues/4769#issuecomment-320319655
