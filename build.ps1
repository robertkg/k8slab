[CmdletBinding()]
param (
    [Parameter()]
    [switch]
    $DeleteCluster
)

$ErrorActionPreference = 'Stop'

$tag = 'latest'
$image = "k8slab/webapi:$tag"
$port = 8080

if ($PSBoundParameters.ContainsKey('DeleteCluster')) {
    'Deleting cluster...'
    minikube delete
    if (!$?) { throw }

    'Creating cluster...'
    minikube start --driver=docker --ports=127.0.0.1:8080:30000 --ports 127.0.0.1:1433:30001
    if (!$?) { throw }
}

'Generating mgiration script'
dotnet ef migrations script --project app -o app/mssql/migrations.sql --idempotent

'Building docker images...'
docker build -t $image app
docker build -t k8slab/mssql app/mssql
docker build -t k8slab/ef app/mssql/migrations
if (!$?) { throw }

'Loading docker images into minikube...'
minikube image load k8slab/webapi:latest
minikube image load k8slab/mssql:latest
minikube image load k8slab/ef:latest
if (!$?) { throw }

'Applying configuration...'
kubectl apply -f .kubernetes/deployment
kubectl apply -f .kubernetes/service
if (!$?) { throw }

"Service listening on http://localhost:$port"


