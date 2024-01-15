helm upgrade --install kps prometheus-community/kube-prometheus-stack \
    -f kps-values.yaml \
    -n monitoring --create-namespace


