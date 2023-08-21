#!/bin/bash

#Arguments: Container name and public IP (maybe also port number later for the MITM script)
if [ $# -ne 2 ]
then 
  echo "Not enough"
  exit 1
fi 

#Stop MITM server 
sudo forever stopall
#sudo iptables --table nat --delete PREROUTING --source 0.0.0.0/0 --destination "$2" --prototcol tcp --dport 22 --jump #DNAT -to-destination  <mitm host ip>: 

CON_IP=$(sudo lxc-info)

#Remove IP assignments 
sudo iptables --table nat --delete PREROUTING --source 0.0.0.0/0 --destination "$2" --jump DNAT --to-destination "CON_IP"
sudo iptables --table nat --delete POSTROUTING --source "$CON_IP" --destination 0.0.0.0/0 --jump SNAT --to-source "$2"

#Remove public IP from the machine 
sudo ip addr delete "$2"/16 brd + dev enp4s2

#Stop and destroy the container 
sudo lxc-stop "$1"
sudo lxc-destroy "$1"

#Execute setup_MITM script
#Execute openssh
#Execute honeyscript

