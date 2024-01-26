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
