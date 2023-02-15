# k8slab

- [k8slab](#k8slab)
  - [Prerequisites (Windows workstation)](#prerequisites-windows-workstation)
    - [WSL 2](#wsl-2)
    - [PowerShell modules](#powershell-modules)
    - [Docker Desktop for Windows](#docker-desktop-for-windows)
    - [kubectl](#kubectl)
    - [helm](#helm)
    - [kind](#kind)
      - [minikube](#minikube)
  - [Building](#building)

## Prerequisites (Windows workstation)

These prerequisites are meant for running on a Windows desktop workstation:

### WSL 2

Install WSL 2:

```
wsl --install -d Ubuntu
wsl --set-version Ubuntu 2 # Enable WSL 2
wsl --set-default Ubuntu
```

Install Linux on Windows with WSL: https://learn.microsoft.com/en-us/windows/wsl/install

### PowerShell modules

Build script currently uses PowerShell. The following modules are recommended/required:

- **PSKubectlCompletion**: Used for kubectl tab-completetion for for PowerShell (not required)
- **psake**: Used for building the cluster lab environment (required)

```powershell
Install-PSResource PSKubectlCompletion, psake -Scope CurrentUser
```

If you are using PowerShellGet 2.2.5 or earlier, use `Install-Module` or upgrade to a beta release: https://www.powershellgallery.com/packages/PowerShellGet/


### Docker Desktop for Windows

Install [Docker Desktop for Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe?utm_source=docker&utm_medium=webreferral&utm_campaign=dd-smartbutton&utm_location=header)

Enable WSL 2 based engine by going to **⚙️ -> General** and make sure **Use the WSL 2 based engine** is checked.

Go to **Resources -> WSL Integration** and make sure **Enable integration with my default WSL distro** is checked.

### kubectl

Used for managing kubernetes resources on the lab cluster.

Install from command-line installer or download the binary directly from https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/

```
scoop install kubectl
```

### helm

Used for deploying kubernetes resources using [helm charts](https://helm.sh/docs/topics/charts/).

Install from command-line installer or download the binary directly from https://helm.sh/docs/intro/install/

```
scoop install helm
```

### kind

Using for running kubernetes cluster locally through Docker/WSL2.

Install from command-line installer or download the binary directly from https://kind.sigs.k8s.io/#installation-and-usage

```
scoop install kind
```

Using WSL2: https://kind.sigs.k8s.io/docs/user/using-wsl2/

#### minikube

Alternative to kind for running cluster locally.

Install from command-line installer or download the binary directly from https://minikube.sigs.k8s.io/docs/start/

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

Current build script uses the PowerShell module [psake](https://www.powershellgallery.com/packages/psake/) for build automation. See [PowerShell modules](#powershell-modules) for installation.

Invoke the build script using the following command:

```powershell
Invoke-psake build.psake.ps1 -t build
```
