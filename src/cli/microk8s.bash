#!/usr/bin/env bash

function _microk8s(){
    opt="$2"
    action=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $action in
    setup)
      _multipass "$@"
      multipass exec "$VM_NAME" -- sudo snap install microk8s --classic || echo "microk8s install ❌"
      multipass exec "$VM_NAME" -- sudo iptables -P FORWARD ACCEPT || echo "iptables update ❌"
      multipass exec "$VM_NAME" -- sudo usermod -a -G microk8s ubuntu || echo "usermod  ❌"
      multipass exec "$VM_NAME" -- sudo snap alias microk8s.kubectl kubectl || echo "snap alias  ❌"
      multipass exec "$VM_NAME" -- microk8s status --wait-ready || echo "status  ❌"
      multipass exec "$VM_NAME" -- microk8s start || echo "microk8s start  ❌"
      multipass exec "$VM_NAME" -- microk8s enable dashboard || echo "dashboard  ❌"
      multipass exec "$VM_NAME" -- kubectl get pods --all-namespaces || echo "pods  ❌"
      multipass exec "$VM_NAME" -- kubectl cluster-info || echo "cluster info  ❌"

      # multipass exec "$VM_NAME" -- sudo chown -f -R ubuntu ~/.kube || echo "chown  ❌"
      token=$(multipass exec "$VM_NAME" -- kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
      multipass exec "$VM_NAME" -- kubectl -n kube-system describe secret "$token" || echo "secret  ❌"
      # enable kubeconfig on host system
      multipass exec "$VM_NAME" -- microk8s config > kubeconfig/.admin.kubeconfig  || echo "kubeconfig  ❌"
      ;;
    status)
      _multipass "$@"
      ;;
    pods)
      kubectl get pods --all-namespaces || echo "pods  ❌"
      ;;
    dashboard)
      secret=$(multipass exec "$VM_NAME" -- sudo kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
      token=$(multipass  exec "$VM_NAME" -- sudo kubectl -n kube-system describe secret "$secret" | grep token:)
      IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{ print $2 }')

      multipass exec "$VM_NAME"  -- sudo kubectl port-forward -n kube-system service/kubernetes-dashboard \
                                    10443:443 --address 0.0.0.0 > /dev/null 2>&1 &
      echo "Dashboard URL: https://$IP:10443"
      echo "$token"
      ;;
    clean)
      _multipass "$@"
      ;;
    *)
      echo "${RED}Usage: ./assist <command>${NC}"
cat <<-EOF
Commands:
---------
  setup       -> Install and Configure microk8s
  dashboard   -> Access k8s Dashboard
  pods        -> List Running PODs
  clean       -> Clean multipass VM
EOF
    ;;
esac
}
