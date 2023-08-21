#!/bin/bash

#Takes in the name of the container as the argument
if [ $# -ne 1 ]
then 
  echo "Not enough"
fi 

sudo lxc-attach -n "$1" -- bash -c "echo -e Y\n |sudo apt-get remove --purge *mysql*"
sudo lxc-attach -n "$1" -- bash -c "echo -e Y\n | sudo apt-get autoremove"
sudo lxc-attach -n "$1" -- bash -c "sudo apt-get autoclean"
