# k8slab

- [k8slab](#k8slab)
  - [Prerequisites](#prerequisites)
    - [WSL 2](#wsl-2)
    - [Docker Desktop for Windows](#docker-desktop-for-windows)
    - [kubectl](#kubectl)
    - [minikube](#minikube)
  - [Building](#building)
  - [Debugging](#debugging)

## Prerequisites

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

Set docker as default driver:

```
minikube config set driver docker
```

Start a cluster:

```
minikube start --driver=docker --ports=127.0.0.1:8080:80
```

Basic controls: https://minikube.sigs.k8s.io/docs/handbook/controls/


## Building

```powershell
Invoke-psake build.psake.ps1 -t build
```

## Debugging

```
kubectl run -i --tty --rm ef-migration-debug --image=k8slab/ef:latest --restart=Never --image-pull-policy=Never -- /bin/bash
```