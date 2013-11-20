#!/bin/sh

VM=$1
VDI=$2
SSH_PORT=2223
INDEX=1

VBoxManage unregistervm "$VM" --delete
VBoxManage createvm --name "$VM" --ostype Linux26 --register
VBoxManage modifyvm "$VM" --memory 1024 --vram 128 --accelerate3d off
VBoxManage storagectl "$VM" --name "SATA" --add sata --controller IntelAHCI --sataportcount 1
VBoxManage storageattach "$VM" --storagectl SATA --port 0 --type hdd --mtype normal --medium $VDI
VBoxManage modifyvm "$VM" --nic1 nat --nictype1 virtio
VBoxManage modifyvm "$VM" --nic2 intnet --intnet2 sailfishsdk --nictype2 virtio --macaddress2 08005A11000$INDEX
VBoxManage modifyvm "$VM" --natpf1 "guestssh,tcp,127.0.0.1,${SSH_PORT},,22"
VBoxManage modifyvm "$VM" --natdnshostresolver1 on
VBoxManage setextradata "$VM" CustomVideoMode1 "540x960x32"
VBoxManage modifyvm "$VM" --bioslogodisplaytime 1
VBoxManage modifyvm "$VM" --audio pulse --audiocontroller ac97
VBoxManage modifyvm "$VM" --mouse ps2
VBoxManage sharedfolder add "$VM" --name ssh --hostpath ~/SailfishOS/emulator/$INDEX/ssh
VBoxManage sharedfolder add "$VM" --name config --hostpath ~/SailfishOS/vmshare

VBoxManage setextradata global GUI/SuppressMessages "remindAboutAutoCapture,remindAboutWrongColorDepth,showRuntimeError.warning.HostAudioNotResponding,remindAboutMouseIntegrationOff"
