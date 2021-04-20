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
    multipass exec  "$VM_NAME" -- sudo apt-get update -y -q
    multipass exec  "$VM_NAME" -- sudo apt-get install python3.9 python3-pip -y -q
    multipass exec  "$VM_NAME" -- sudo apt-get upgrade -y -q
    multipass exec  "$VM_NAME" -- sudo apt-get -y autoremove
    multipass exec  "$VM_NAME" -- sudo apt-get -y autoclean
}

function mount_dir(){
    VM_NAME=$1
    DIR=$2
    multipass mount "$DIR" "$VM_NAME":/home/ubuntu/host-dir
}

function setup(){
    VM_NAME=$1
    launch_vm "$VM_NAME"
    add_google_dns "$VM_NAME"
}

function display_runnning_vms(){
    action=$1
    #Atleast one VM is Available
    if [ "$(multipass ls | grep -c "No instances found.")" -eq 0 ]
    then
        echo "${BLUE}Running VMs ...${NC}"
        multipass list
    else
        if [ "$action" != "setup" ]
        then
            raise_error "${RED}No VM instances found.. Exiting...${NC}"
        fi
    fi
}
