# k8slab

## Setup K8S cluster with minikube, docker and WSL 2 

### WSL 2

Install WSL 2:

```
wsl --install -d Ubuntu
wsl --set-version Ubuntu 2 # Enable WSL 2
wsl --set-default Ubuntu
```

### Docker Desktop for Windows

Install [Docker Desktop for Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=header)

Enable WSL 2 based engine by going to **⚙️ -> General** and check **Use the WSL 2 based engine**

Go to **Resources -> WSL Integration** and ensure **Enable integration with my default WSL distro** is checked.

### kubectl

Install from package manager or download from website:

```
scoop install kubectl
```

### minikube

Install from package manger or download from website:

```
scoop install minikube
```

Start a cluster:

```
minikube start --driver=docker --ports=127.0.0.1:8080:80 # expects service (e.g. NodePort) on cluster exposed on port 80
```

Set docker as default driver:

```
minikube config set driver docker
```

Basic controls: https://minikube.sigs.k8s.io/docs/handbook/controls/

### SQL server

Create docker image for now:

```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=MyPass@word' -p 1433:1433 -d mcr.microsoft.com/mssql/server
```

### EF - Code first migrations

https://learn.microsoft.com/en-us/ef/core/managing-schemas/migrations/?tabs=dotnet-core-cli#create-your-database-and-schema

```
dotnet tool install --global dotnet-ef
```
