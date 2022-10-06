$ErrorActionPreference = 'Stop'

$tag = '1.0.0'
$image = "aspnetcoreapp:$tag"
$port = 8080

'Deleting cluster...'
minikube delete
if (!$?) {throw}

'Creating cluster...'
minikube start --driver=docker --ports=127.0.0.1:$port`:30000
if (!$?) {throw}

'Building docker image...'
docker build -t $image src
if (!$?) {throw}

'Loading docker image into minikube...'
minikube image load $image --overwrite=true
if (!$?) {throw}

'Applying configuration...'
kubectl apply -f deployment
kubectl apply -f service
if (!$?) {throw}

"Service listening on http://localhost:$port"
