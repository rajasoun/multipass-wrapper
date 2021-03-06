#!/usr/bin/env bash

set -eo pipefail
IFS=$'\n\t'

CPU="2"
MEMORY="2G"
DISK="4G"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=src/load.bash
source "$SCRIPT_DIR/src/load.bash"

opt="$1"
action=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $action in
    setup)
      check_preconditions
      display_runnning_vms
      get_vm_name
      setup $VM_NAME
      # upgrade "$VM_NAME"
      # install_kali_linux "$VM_NAME"
      ;;
    up)
      display_runnning_vms
      get_vm_name
      multipass start "$VM_NAME"
      ;;
    down)
      display_runnning_vms
      get_vm_name
      multipass stop "$VM_NAME"
      ;;
    shell)
      display_runnning_vms
      get_vm_name
      multipass shell  "$VM_NAME"
      ;;
    status)
      display_runnning_vms
      get_vm_name
      multipass info $VM_NAME
      ;;
    clean)
      display_runnning_vms
      get_vm_name
      multipass stop "$VM_NAME" && multipass delete "$VM_NAME" && multipass purge
      ;;
    *)
      echo "${RED}Usage: ./assist <command>${NC}"
cat <<-EOF
Commands:
---------
  setup  -> Setup VM
  up     -> Bring Up VM
  down   -> Bring Down VM
  shell  -> Enter Shell
  status -> Status of all multipass VMs
  clean  -> Clean & Destroy VM
EOF
    ;;
esac
