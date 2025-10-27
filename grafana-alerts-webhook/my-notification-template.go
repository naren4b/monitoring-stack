{{ define "webhook.local.simple" -}}
{
  "alerts": {{ data.ToJSONPretty "  " .Alerts }},
  "alert_name": "{{ .CommonLabels.alertname }}",
  "labels": {
    "pod": "{{ index .CommonLabels "pod" }}",
    "namespace": "{{ index .CommonLabels "namespace" }}",
    "phase": "{{ index .CommonLabels "phase" }}"
  }  
}
{{- end }}