podman build -t webserver:v1 .
mkdir -p ./out
podman stop webserver && podman rm webserver
podman volume create webhook-alerts-data
podman run --rm -d -v webhook-alerts-data:/app/out --name="webserver" --network host webserver:v1 

podman logs webserver 

#https://grafana.com/docs/grafana/latest/alerting/configure-notifications/manage-contact-points/integrations/webhook-notifier/#configure-webhook-for-a-contact-point


curl -v http://localhost:9001
