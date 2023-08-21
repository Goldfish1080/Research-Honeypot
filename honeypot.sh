#!/bin/bash 
#The names of the 4 containers will be changed eventually
#Make first honeypot 
./make_con honeypot1
#We want to wait 5 seconds because it takes a while for the container to be assigned an IP address
sleep 5
#Install openssh-server
./openssh.sh honeypot1

#Set up MITM server for each honeypot (port # doesn't matter as long as it's not 22)
./setup_MITM.sh honeypot1 25 128.8.238.195
 

#Add the honey (Will be made eventually)

#Make second honeypot
./make_con honeypot2
sleep 5
./openssh.sh honeypot2
./setup_MITM.sh honeypot2 70 128.8.238.27

#Make third honeypot 
./make_con honeypot3
sleep 5
./openssh.sh honeypot3
./setup_MITM.sh honeypot3 150 128.8.238.45

#Make fourth honeypot
./make_con honeypot4
sleep 5
./openssh.sh honeypot4
./setup_MITM.sh honeypot4 300 128.8.238.175
