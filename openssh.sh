#!/bin/bash

#Takes in the honeypot name 

sleep 20 

sudo lxc-attach -n "$1" -- bash -c "sudo apt-get update"
sudo lxc-attach -n "$1" -- bash -c "echo -e Y\n | sudo apt install openssh-server"

sleep 10 

touch dupe_root_user

sudo sed "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /var/lib/lxc/"$1"/rootfs/etc/ssh/sshd_config | tee dupe_root_user

sudo mv dupe_root_user /var/lib/lxc/"$1"/rootfs/etc/ssh/sshd_config

sudo lxc-attach -n "$1" -- bash -c "sudo systemctl restart ssh"

