#!/bin/bash

if [ $# -ne 1 ]
then 
  echo "Not enough"
fi 

NAME=$1

sudo lxc-create -n "$NAME" -t download -- -d ubuntu -r focal -a amd64
sudo lxc-start -n "$NAME"
