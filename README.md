# Kubernetes lab environment

## Prerequisites
- Docker desktop/kind or other cluster running
- kubectl CLI installed
- argocd CLI installed
- helm CLI installed

## Getting started

`setup.sh` will install ArgoCD, kube-prometheus-stack, HashiCorp Vault and a flask app (for scraping prometheus metrics) in your cluster.

```bash
chmod +x setup.sh
./setup.sh
```

## Accessing services
ArgoCD:

```bash
kubectl port-forward -n argocd svc/argocd-server 8080:443
```

Grafana (default login: admin:prom-operator):

```bash
kubectl port-forward -n prometheus svc/prometheus-grafana 8081:80
```

Prometheus:

```bash
kubectl port-forward -n prometheus svc/prometheus-kube-prometheus-prometheus 9090:9090
```

Alertmanager:

```bash
kubectl port-forward -n prometheus svc/alertmanager-operated 9093:9093
```

## Troubleshooting

### Prometheus service monitors aren't detected
- Ensure that your ServiceMonitor API resource is labeled correctly: `kubectl get prometheuses.monitoring.coreos.com --all-namespaces -o jsonpath="{.items[*].spec.serviceMonitorSelector}"`

### Prometheus alerts aren't firing
- Check the **Alerts** tab in Prometheus and ensure that your PrometheusRule API resources are detected
- Check if your alerts are firing under **Alerts** in Prometheus or by running the following query in Grafana: `ALERTS{alertstate="firing"}`
- Run the PromQL query contained in your `exp` property

### AlertmanagerConfig isn't posting to Slack
- Check for any errors in Alertmanager: `kubectl logs -n prometheus alertmanager-prometheus-kube-prometheus-alertmanager-0`
- Ensure Slack receiver is detected by Alertmanager by going to **Alerts -> Receiver -> monitoring/alertmanagerconfig-slack/slack** in the Alertmanager web GUI.
