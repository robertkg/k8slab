# Kubernetes lab environment

## Prerequisites
- Docker desktop/kind or other cluster running
- kubectl CLI installed
- argocd CLI installed
- helm CLI installed

## Getting started

`setup.sh` will install ArgoCD, kube-prometheus-stack and an example app for polling metrics in your cluster.

```bash
chmod +x setup.sh
./setup.sh
```
