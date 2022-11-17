kubectl apply -f .\.kubernetes\job\ef.yaml
kubectl wait --for=condition=complete --timeout=30s job/ef-migration
# kubectl delete job ef-migration