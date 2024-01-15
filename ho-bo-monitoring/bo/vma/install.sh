default_name="demo"
default_id="111"
default_pincode="751003"

BO_NAME=$1
BO_NAME=${BO_NAME:-$default_name}
BO_ID=$2
BO_ID=${BO_ID:-$default_id}
BO_PINCODE=$3
BO_PINCODE=${BO_PINCODE:-$default_pincode}

cat <<EOF >$BO_NAME-values.yaml
extraArgs:
  envflag.enable: "true"
  envflag.prefix: VM_
  loggerFormat: json
  remoteWrite.forceVMProto: true
  remoteWrite.flushInterval: "30s"
  remoteWrite.queues: "1"
  remoteWrite.tlsInsecureSkipVerify: "true"
  remoteWrite.label: "bo_id=$BO_ID,pincode=$BO_PINCODE" 
EOF

echo helm upgrade --install $BO_NAME vm/victoria-metrics-agent \
  -f vmagent-values.yaml -f $BO_NAME-values.yaml \
  -n $BO_NAME --create-namespace

k apply -f sample-recording-rules.yaml -n monitoring #TODO
