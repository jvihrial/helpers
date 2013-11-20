#!/bin/sh

VM=$1
SSH_PORT=2222
HTTP_PORT=8080
VDI=$2

VBoxManage unregistervm "$VM" --delete
VBoxManage createvm --name "$VM" --ostype Linux26 --register
VBoxManage modifyvm "$VM" --memory 1024 --vram 128 --accelerate3d off
VBoxManage storagectl "$VM" --name "SATA" --add sata --controller IntelAHCI --sataportcount 1
VBoxManage storageattach "$VM" --storagectl SATA --port 0 --type hdd --mtype normal --medium $VDI
VBoxManage modifyvm "$VM" --nic1 nat --nictype1 virtio
VBoxManage modifyvm "$VM" --nic2 intnet --intnet2 sailfishsdk --nictype2 virtio --macaddress2 08005A11F155
VBoxManage modifyvm "$VM" --bioslogodisplaytime 1

VBoxManage modifyvm "$VM" --natpf1 "guestssh,tcp,127.0.0.1,${SSH_PORT},,22" 
VBoxManage modifyvm "$VM" --natpf1 "guestwww,tcp,127.0.0.1,${HTTP_PORT},,9292"

VBoxManage modifyvm "$VM" --natdnshostresolver1 on

VBoxManage sharedfolder add "$VM" --name ssh --hostpath ~/SailfishOS/mersdk/ssh
VBoxManage sharedfolder add "$VM" --name config --hostpath ~/SailfishOS/vmshare
VBoxManage sharedfolder add "$VM" --name home --hostpath ~/
VBoxManage sharedfolder add "$VM" --name targets --hostpath ~/SailfishOS/mersdk/targets
VBoxManage sharedfolder add "$VM" --name src1 --hostpath ~/

