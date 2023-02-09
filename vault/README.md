# Hashicorp Vault

## Cheat sheet


Prereqs:

```
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
```

Install:

```
kubectl create namespace vault
helm install vault hashicorp/vault --namespace vault --version 0.23.0
```

Setup:

```
kubectl exec -n vault --stdin=true --tty=true vault-0 -- vault operator init
kubectl port-forward -n vault vault-0 8080:8200
```

## Related links

https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-raft-deployment-guide