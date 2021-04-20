# multipass-wrapper

Bash Wrapper to Multipass and microk8s

## Getting Started

### multipass

[Pre-Requisite Setup](SLS.md)

1. `./assist.bash multipass` wrapper script for multipass

### microk8s

1. `export MEMORY=4G DISK=20G && ./assist.bash microk8s ` wrapper script for microk8s

1. `./assist.bash microk8s dashboard ` to access k8s Dashboard on host system

1. `./assist.bash microk8s pods ` to list all pods

### kubectl

```
$ export "$(< kubeconfig/env xargs)"
$ kubectl get pods --all-namespaces

```

### override defaults

1. `export MEMORY=4G DISK=20G && ./assist.bash` to overrise default CPU, MEMORY and DISK
