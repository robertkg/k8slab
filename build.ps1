# CI/CD pipeline mockup script

[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $DeleteCluster
)

$ErrorActionPreference = 'Stop'

function task ($m) {
    Write-Host -f Green "`n====================================`n$m`n===================================="
}

$tag = 'latest'
$image = "k8slab/webapi:$tag"
$port = 8080

if ($PSBoundParameters.ContainsKey('DeleteCluster')) {
    'Deleting cluster...'
    minikube delete
    if (!$?) { throw }

    'Creating cluster...'
    minikube start --driver=docker --ports 127.0.0.1:30000:30000 --ports 127.0.0.1:30001:30001
    if (!$?) { throw }
}

# 'Generating mgiration script'
# dotnet ef migrations script --project app -o app/mssql/migrations.sql --idempotent

task 'Building docker images'
docker build -t k8slab/ef -f app/ef/Dockerfile app # Image must copy parent project dir
docker build -t k8bslab/webapi -f app/Dockerfile app
docker images k8slab/*
# if (!$?) { throw }

task 'Loading docker images into minikube...'
# minikube image load k8slab/ef:latest --overwrite=true
# minikube image load k8slab/webapi:latest --overwrite=true
minikube image ls --format json | ConvertFrom-Json | Where-Object repotags -m 'k8slab\/(ef|webapi)' | Select-Object repoTags, id, size | Out-Host
#if (!$?) { throw }

task 'Deploying k8slab/mssql'
kubectl apply -f .kubernetes/deployment/mssql.yaml
kubectl apply -f .kubernetes/service/mssql.yaml

# task 'Applying database migration'
# kubectl apply -f .kubernetes/job/ef.yaml
# kubectl wait --for=condition=complete --timeout=30s job/ef-migration
# kubectl delete job ef-migration
# # if (!$?) { throw }

# "Service listening on http://localhost:$port"


