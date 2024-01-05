#!/bin/bash
cat <<EOF >/etc/credentials
[default]
aws_access_key_id=ROOTNAME
aws_secret_access_key=CHANGEME123
EOF

docker run -v victoria-metrics-data:/victoria-metrics-data --network host victoriametrics/vmrestore -storageDataPath=/victoria-metrics-data -snapshot.createURL=http://localhost:8428/snapshot/create -src=s3://localhost:9000/data -credsFilePath=/etc/credentials -customS3Endpoint=http://localhost:9000
