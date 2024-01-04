docker run -it --network host victoriametrics/vmbackup -storageDataPath=/victoria-metrics-data -snapshot.createURL=http://localhost:8428/snapshot/create    -dst=s3://localhost:9000/data -credsFilePath=/etc/credentials -customS3Endpoint=http://localhost:9000


 ./vmrestore-prod -src=fs:///tmp/data 