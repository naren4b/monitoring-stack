helm upgrade --install vms vm/victoria-metrics-single \
    -f vms-values.yaml \
    -n vms --create-namespace

