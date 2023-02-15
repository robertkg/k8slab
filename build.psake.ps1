Properties {
    $webApiPort = '30000'
    $mssqlPort = '30001' # for local debugging through mgmt console
}

#region kind
Task 'Delete kind cluster' -alias 'delete-cluster' {
    kind delete cluster; if (!$?) { throw }
}

Task 'Create cluster' -alias 'create-cluster' {
    if ($null -eq (kind get clusters)) {
        kind create cluster --config $PSScriptRoot\.kind\cluster-config.yml; if (!$?) { throw }
        kubectl cluster-info --context kind-kind; if (!$?) { throw }
    } else {
        Write-Output 'Cluster kind already exists'
    }
}

Task 'Load docker images into kind cluster' -alias 'load-image' {
    kind load docker-image k8slab/webapi:latest k8slab/ef:latest mcr.microsoft.com/mssql/server:2019-CU18-ubuntu-20.04; if (!$?) { throw }
    # list images present on cluster:
    #   docker exec -it kind-control-plane crictl images
} -depends 'pull-image', 'build-image'
#endregion kind

#region minikube
# Task 'Delete minikube cluster' -alias 'delete-cluster' {
#     minikube delete; if (!$?) { throw }
# }

# Task 'Create minikube cluster' -alias 'create-cluster' {
#     $cluster = docker ps -f 'name=minikube' --format '{{.Names}}'
#     if ($null -eq (docker ps -f 'name=minikube' --format '{{.Names}}')) {
#         minikube start --driver=docker --ports 127.0.0.1:$webApiPort`:30000 --ports 127.0.0.1:$mssqlPort`:30001; if (!$?) { throw }
#     }
#     else {
#         Write-Output "Cluster $cluster already exists, nothing to do"
#     }
# }
# Task 'Load docker images into minikube' -alias 'load-image' {
#     'k8slab/ef:latest'; minikube image load k8slab/ef:latest --overwrite=true; if (!$?) { throw }
#     'k8slab/webapi:latest'; minikube image load k8slab/webapi:latest --overwrite=true; if (!$?) { throw }
#     minikube image ls --format json | ConvertFrom-Json | Where-Object repotags -m 'k8slab\/(ef|webapi)' | Select-Object repoTags, id, size | Out-Host
    
#     $mssqlImageTag = 'mcr.microsoft.com/mssql/server:2019-CU18-ubuntu-20.04'
#     if (-not (minikube image ls --format json | ConvertFrom-Json | Where-Object repoTags -Contains $mssqlImageTag)) {
#         $mssqlImageTag; minikube image load $mssqlImageTag; if (!$?) { throw }
#     }
# } -depends 'Build docker images', 'Create minikube cluster'
#endregion minikube

Task 'Pull docker images' -alias 'pull-image' {
    docker pull mcr.microsoft.com/mssql/server:2019-CU18-ubuntu-20.04; if (!$?) { throw }
}

Task 'Build docker images' -alias 'build-image' {
    docker build -t k8slab/ef -f app/ef/Dockerfile app; if (!$?) { throw } # Image must copy parent project dir
    docker build -t k8slab/webapi -f app/Dockerfile app; if (!$?) { throw }
    docker image list k8slab/*
}

#region kubernetes deployment
Task 'Deploy k8slab/mssql' -alias 'k8slab-mssql' {
    kubectl apply -f .kubernetes/deployment/mssql.yaml; if (!$?) { throw }
    kubectl apply -f .kubernetes/service/mssql.yaml; if (!$?) { throw }
    'Waiting for pod ready state'
    kubectl wait pods -l run=k8slab-mssql --for condition=Ready --timeout=30s
}

Task 'Apply database migration' -alias 'k8slab-ef' {
    kubectl apply -f .kubernetes/job/ef.yaml; if (!$?) { throw }
    'Waiting for job complete state'
    kubectl wait --for condition=Complete --timeout=30s job/k8slab-ef-migration
} -depends 'Deploy k8slab/mssql'

Task 'Deploy k8slab/webapi' -alias 'k8slab-webapi' {
    kubectl apply -f .kubernetes/service/webapi.yaml
    kubectl apply -f .kubernetes/deployment/webapi.yaml
    'Waiting for pod ready state'
    kubectl wait pods -l run=k8slab-webapi --for condition=Ready --timeout=30s

    'Deployment completed'
    "Service listening on http://localhost:$webApiPort/swagger/index.html"
} -depends 'Apply database migration'
#endregion kubernetes deployment

#region helm deployment
# Alternative to k8slab-* tasks
Task 'Helm install' -alias 'helm-install' {
    helm upgrade --install --wait --wait-for-jobs --timeout 2m0s -f charts/k8slab-webapi/values.yaml k8slab-webapi charts/k8slab-webapi; if (!$?) { throw }
}

Task 'Add webapi sample data' -alias 'add-sample-data' {
    $requestParams = @{
        Uri         = "http://localhost:$webApiPort/api/Contacts/add"
        Method      = 'Post'
        ContentType = 'application/json'
        Body        = $null
    }
    $sampleData = Get-Content -Encoding utf8 -Path $PSScriptRoot\app\sampleData.json | ConvertFrom-Json

    $sampleData | ForEach-Object {
        $requestParams.Body = $_ | ConvertTo-Json -Depth 1
        $req = Invoke-RestMethod @requestParams
        Write-Output ($req | ConvertTo-Json -Compress -Depth 1)
    }
}
#endregion helm deployment

Task 'Kubernetes delete all' -alias 'k8s-delete-all' {
    # alternative: kubectl delete all --all
    kubectl delete service k8slab-mssql
    kubectl delete deployment k8slab-mssql
    kubectl delete job k8slab-ef-migration
    kubectl delete service k8slab-webapi
    kubectl delete deployment k8slab-webapi
}

Task 'Install ArgoCD' -alias 'install-argocd' {
    function base64d ($i) {
        [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($i))
    }

    if ($null -eq ((kubectl get namespace -o json | ConvertFrom-Json).items.metadata | Where-Object name -EQ argocd)) {
        kubectl create namespace argocd
    }
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    $secret = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
    Write-Output "Secret: $(base64d $secret)"
    Write-Output 'Port forward'
}

Task 'Output webapi URL' -alias 'output-webapi-url' {
    Write-Output "http://localhost:$webApiPort/swagger/index.html"
}

# Simple tasks
Task 'build' -depends create-cluster, build-image, load-image,<#k8s-deploy#> helm-install, add-sample-data, output-webapi-url
Task 'build-prune' -depends delete-cluster, build, output-webapi-url
Task 'helm-install-prune' -depends k8s-delete-all, helm-install, add-sample-data, output-webapi-url
Task 'k8s-deploy' -depends k8slab-mssql, k8slab-ef, k8slab-webapi
Task 'k8s-reapply' -depends k8s-delete-all, k8slab-mssql, k8slab-ef, k8slab-webapi, add-sample-data, output-webapi-url
