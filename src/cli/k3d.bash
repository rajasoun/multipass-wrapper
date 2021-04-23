#!/usr/bin/env bash

function _k3d(){
    opt="$2"
    action=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $action in
    setup)
      #_multipass "$@"
      multipass exec "$VM_NAME" -- curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash || echo "k3d install ❌"
      multipass exec "$VM_NAME" -- k3d cluster create microk3s
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
