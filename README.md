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