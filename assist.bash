#!/usr/bin/env bash

set -eo pipefail
IFS=$'\n\t'

CPU="2"
MEMORY="4G"
DISK="25G"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=src/load.bash
source "$SCRIPT_DIR/src/load.bash"

opt="$1"
action=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $action in
    setup)
      check_preconditions
      get_vm_name
      setup $VM_NAME
      install_kali_linux "$VM_NAME"
      ;;
    up)
      get_vm_name
      multipass start "$VM_NAME"
      ;;
    down)
      get_vm_name
      multipass stop "$VM_NAME"
      ;;
    shell)
      get_vm_name
      multipass shell  "$VM_NAME"
      ;;
    status)
      echo "${BLUE}Running Containers ...${NC}"
      multipass list
      get_vm_name
      multipass info $VM_NAME
      ;;
    clean)
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
