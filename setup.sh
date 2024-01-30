#!/bin/bash

kubectl version || exit 1
which argocd    || exit 1 # CLI throws error when login is not set up

echo "=== Installing ArgoCD ==="
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || exit 1

echo "Waiting for ArgoCD deployment ready state..."
kubectl wait -n argocd deployment/argocd-server --for=condition=Available --timeout=300s

echo " "
echo "Please port set up a port forward from another shell"
echo " "
echo "  kubectl port-forward -n argocd svc/argocd-server 8080:443"
read -r -p "Press Enter to continue..."

echo "Logging into ArgoCD server on localhost:8080"
ARGOCD_ADMIN_SECRET="$(kubectl get secret -n argocd argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 -d)" || exit 1
argocd login localhost:8080 --username admin --password "${ARGOCD_ADMIN_SECRET}"

echo "=== Creating ArgoCD app: vault ==="
argocd proj create -f manifest/argocd/vault/project.yaml --upsert
argocd app create -f manifest/argocd/vault/application.yaml --upsert

echo "=== Creating ArgoCD app: kube-prometheus-stack ==="
argocd proj create -f manifest/argocd/kube-prometheus-stack/project.yaml --upsert
argocd app create -f manifest/argocd/kube-prometheus-stack/application.yaml --upsert
kubectl wait -n prometheus deployment/prometheus-grafana --for=condition=Available --timeout=300s
kubectl create namespace monitoring

echo "=== Creating ArgoCD app: example-app ==="
argocd proj create -f manifest/argocd/example-app/project.yaml --upsert
argocd app create -f manifest/argocd/example-app/application.yaml --upsert

echo " "
echo "ArgoCD login details:"
echo "  server address: https://localhost:8080"
echo "  username: admin"
echo "  password: ${ARGOCD_ADMIN_SECRET}"

echo "Done"
