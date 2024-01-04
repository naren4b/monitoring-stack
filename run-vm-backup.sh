docker run -it --network host victoriametrics/vmbackup
./vmbackup -storageDataPath=</path/to/victoria-metrics-data> -snapshot.createURL=http://localhost:8428/snapshot/create -dst=gs://<bucket>/<path/to/new/backup>

 ./vmbackup-prod -storageDataPath=/victoria-metrics-data -snapshot.createURL=http://localhost:8428/snapshot/create    -dst=s3://localhost:9000/data -credsFilePath=/etc/credentials -customS3Endpoint=http://localhost:9000


 ./vmrestore-prod -src=fs:///tmp/data 