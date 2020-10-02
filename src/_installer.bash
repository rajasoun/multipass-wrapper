#!/usr/bin/env sh

function install_kali_linux(){
    VM_NAME=$1
    multipass exec  "$VM_NAME" -- git clone https://github.com/s-h-3-l-l/katoolin3
    multipass exec  "$VM_NAME" -- chmod +x  katoolin3/install.sh
    multipass exec  "$VM_NAME" -- sudo katoolin3/install.sh
}
