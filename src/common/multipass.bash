#!/usr/bin/env sh

function launch_vm(){
    VM_NAME=$1
    #multipass launch -n "$VM_NAME"
    multipass launch -c"$CPU" -m"$MEMORY" -d"$DISK" -n "$VM_NAME"
    IP=$(multipass info "$VM_NAME" | grep IPv4 | awk '{print $2}')

    echo "${GREEN}VM Creation Sucessfull${NC}"
    echo "${GREEN}VM Name : $VM_NAME |  IP: $IP${NC}"
}

function add_google_dns(){
    VM_NAME=$1
    multipass exec  "$VM_NAME" -- sudo cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak
    multipass exec  "$VM_NAME" -- sudo sed -i -e '13i\\            nameservers:' /etc/netplan/50-cloud-init.yaml
    multipass exec  "$VM_NAME" -- sudo sed -i -e '14i\\                addresses:\ [8.8.8.8, 8.8.4.4]' /etc/netplan/50-cloud-init.yaml
    multipass exec  "$VM_NAME" -- sudo netplan apply
    multipass exec  "$VM_NAME" -- sudo systemd-resolve --status | grep 'DNS Servers' -A2
}

function upgrade(){
    VM_NAME=$1
     echo "${GREEN}Upgrading Packages...${NC}"
    multipass exec  "$VM_NAME" -- DEBIAN_FRONTEND=noninteractive sudo apt-get update -y
    multipass exec  "$VM_NAME" -- DEBIAN_FRONTEND=noninteractive sudo apt-get install python3.8 python3-pip -y
    multipass exec  "$VM_NAME" -- DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y
    multipass exec  "$VM_NAME" -- DEBIAN_FRONTEND=noninteractive sudo apt-get -y autoremove
}

function mount_current_dir(){
    VM_NAME=$1
    multipass mount run-on-vm "$VM_NAME":/home/ubuntu/run-on-vm
}

function setup(){
    VM_NAME=$1
    launch_vm "$VM_NAME"
    add_google_dns "$VM_NAME"
    upgrade "$VM_NAME"
    mount_current_dir "$VM_NAME"
}
