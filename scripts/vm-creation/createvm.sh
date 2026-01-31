#!/bin/bash
#
# This script creates an OpenVMS VM and mounts a vmdk
VM_NAME=OpenVMS-Community_2026 #VM name
VMDK_NAME=test_new.vmdk #path to the VMDK

#DISK_NAME=DATA #add an extra disk
$PORT_NUMBER=1 #extra disk adds as DKA100
CONTROLLER=SATA
VBoxManage createvm --ostype=Other_64 --name=$VM_NAME --register
VBoxManage storagectl $VM_NAME --name=$CONTROLLER --add=SATA --bootable=on \
 --portcount=4 --controller=IntelAhci --hostiocache=on

#uncomment the following line to create a new disk
#vboxmanage createmedium disk --filename $DISK_NAME --size 8000 --format VDI --variant Fixed
###
vboxmanage modifyvm $VM_NAME --ostype=Other_64
vboxmanage modifyvm $VM_NAME --cpus 2
vboxmanage modifyvm $VM_NAME --pae on
vboxmanage modifyvm $VM_NAME --memory 2049 # add more memory
vboxmanage modifyvm $VM_NAME --firmware efi64
vboxmanage modifyvm $VM_NAME --chipset ich9
vboxmanage modifyvm $VM_NAME --boot1 disk
vboxmanage modifyvm $VM_NAME --ioapic on
vboxmanage modifyvm $VM_NAME --uart1 0x3F8 4 --uartmode1=tcpserver 2026 #telnet 127.0.0.1 2026
vboxmanage modifyvm $VM_NAME --nic1 nat
vboxmanage modifyvm $VM_NAME --nictype1 82540EM
vboxmanage modifyvm $VM_NAME --cableconnected1 on
vboxmanage modifyvm $VM_NAME --audio=null
vboxmanage modifyvm $VM_NAME --audio=none
vboxmanage storageattach $VM_NAME --storagectl $CONTROLLER --port 0 --type hdd --medium
$VMDK_NAME

# uncomment the following line to add your newly created disk
#vboxmanage storageattach $VM_NAME --storagectl $CONTROLLER --port $PORT_NUMBER --type hdd --
medium $DISK_NAME
echo "VM setup complete. Run with vboxmanage startvm $VM_NAME --type=headless"
