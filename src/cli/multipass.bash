#!/usr/bin/env bash

function _multipass(){
    opt="$2"
    action=$( tr '[:upper:]' '[:lower:]' <<<"$opt" )
case $action in
    setup)
      check_preconditions
      display_runnning_vms "$action"
      get_vm_name
      echo "CPU:$CPU | MEMORY:$MEMORY | DISK:$DISK"
      setup "$VM_NAME"
      ;;
    up)
      display_runnning_vms "$action"
      get_vm_name
      multipass start "$VM_NAME"
      ;;
    upgrade)
      display_runnning_vms "$action"
      get_vm_name
      upgrade "$VM_NAME"
      ;;
    down)
      display_runnning_vms "$action"
      get_vm_name
      multipass stop "$VM_NAME"
      ;;
    shell)
      display_runnning_vms "$action"
      get_vm_name
      multipass shell  "$VM_NAME"
      ;;
    status)
      display_runnning_vms "$action"
      get_vm_name
      multipass info "$VM_NAME"
      ;;
    clean)
      display_runnning_vms "$action"
      get_vm_name
      multipass stop "$VM_NAME" && multipass delete "$VM_NAME" && multipass purge
      ;;
    *)
      echo "${RED}Usage: ./assist <command>${NC}"
cat <<-EOF
Commands:
---------
  setup               -> Setup VM
  up                  -> Bring Up VM
  upgrade             -> Upgrade VM
  down                -> Bring Down VM
  shell               -> Enter Shell
  status              -> Status of all multipass VMs
  clean               -> Clean & Destroy VM
EOF
    ;;
esac
}
