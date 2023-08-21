#!/bin/bash
#The names of the 4 containers will be changed eventually

#stop all containers
sudo lxc-stop honeypot1
sudo lxc-destroy honeypot1
sudo lxc-stop honeypot2
sudo lxc-destroy honeypot2
sudo lxc-stop honeypot3
sudo lxc-destroy honeypot3
sudo lxc-stop honeypot4
sudo lxc-destroy honeypot4

#STOP MITM and remove ip assignments for all honeypots
sudo forever stopall
sudo iptables --table nat --flush

#removes all public IP from the machine
sudo ip addr delete 128.8.238.195/16 brd + dev enp4s2
sudo ip addr delete 128.8.238.195/16 brd + dev enp4s2
sudo ip addr delete 128.8.238.45/16 brd + dev enp4s2
sudo ip addr delete 128.8.238.175/16 brd + dev enp4s2

#run data collection script -- good time, because all honeypots are stopped.
./datacollection.sh

#shuffle the 4 ip addresses in the array, so each time the script is run they'll be in a different order
array=("128.8.238.195" "128.8.238.27" "128.8.238.45" "128.8.238.175")
array=( $(shuf -e "${array[@]}") )

#Make first honeypot
./make_con honeypot1
sleep 5
#install open-ssh server
./openssh.sh honeypot1
#generate the honey
./generate_honey.sh honeypot1 "honey.csv"
#Set up MITM server for each honeypot (port # doesn't matter as long as it's not 22)
./setup_MITM.sh honeypot1 25 ${array[0]} #uses shuffled ip addr

#Make second honeypot
./make_con honeypot2
sleep 5
./openssh.sh honeypot2
./generate_honey.sh honeypot2 "honey.csv"
./setup_MITM.sh honeypot2 70 ${array[1]} #uses shuffled ip addr

#Make third honeypot
./make_con honeypot3
sleep 5
./openssh.sh honeypot3
./generate_honey.sh honeypot3 "honey.csv"
./setup_MITM.sh honeypot3 150 ${array[2]} #uses shuffled ip addr

#Make fourth honeypot
./make_con honeypot4
sleep 5
./openssh.sh honeypot4
./generate_honey.sh honeypot4 "honey.csv"
./setup_MITM.sh honeypot4 300 ${array[3]} #uses shuffled ip addr
