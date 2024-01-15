helm upgrade --install vmc vm/victoria-metrics-cluster \
    -f vmcluster-values.yaml \
    -n vmc --create-namespace

