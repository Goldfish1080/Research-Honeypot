#!/bin/bash

#Takes in name of the honeypot, port number, and public IP
if [ $# -ne 3 ]
then 
  echo "Not enough"
fi 

#Grabs the IP address of the container 
CON_IP=$(sudo lxc-info -n $1 -iH)

#Start the MITM SERVER to run in the background and assign the IP with the container
sudo forever -l ~/MITM/MITMlogfile -a start ~/MITM/mitm.js -n "$1" -i "$CON_IP" -p "$2" --auto-access --auto-access-fixed 5 --debug

#Turns on the interface 
sudo ip link set dev enp4s1 up

#Adds the public IP address to the interface so that it's recognized otherwise the machine won't know what to do with it
sudo ip addr add "$3"/16 dev enp4s1

sudo iptables --table nat --insert PREROUTING --source 0.0.0/0 --destination "$3" --jump DNAT --to-destination "$CON_IP"
sudo iptables --table nat --insert POSTROUTING --source "$CON_IP" --destination 0.0.0.0/0 --jump SNAT --to-source "$3"
sudo iptables --table nat --insert PREROUTING --source 0.0.0.0/0 --destination "$3" --protocol tcp --dport 22 --jump DNAT --to-destination "172.30.141.241:$2"

#Allows to redirect SSH traffic to the MITM server and redirects it to the local host
sudo systcl -w net.ipv4.conf.all.route_localnet=1

