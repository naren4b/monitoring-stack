helm repo add vm https://victoriametrics.github.io/helm-charts/
helm repo update
helm show values vm/victoria-metrics-agent >values.yaml
