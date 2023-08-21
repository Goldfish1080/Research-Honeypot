# Scripts: 
- openssh.sh
- honeypot.sh
- setup_MITM.sh
- recycle.sh
- make_con.sh

## openssh.sh
Installs opennssh inside the container 

## setup_MITM.sh
Installs MITM inside each container, which will run in the background. Gives the attacker 5 attempts to access into the container.
Also, sets up the NAT rules (networking) of the containers so that packets can be received and sent for both the source and destination.

## honeypot.sh
Creates all 4 honeypot containers. Each container will have openssh, an MITM server with a given port number, and the honey.

## recycle.sh
Includes a timer of 30 minutes. Once the attacker has ssh into the container, the timer will start and will proceed to recycle once the timer is finished. 

## make_con.sh
Script for automatically creating a container

### Other Stuff:
Use `sudo DOWNLOAD_KEYSERVER="keyserver.ubuntu.com" lxc-create -n [container name] -t download -- -d ubuntu -r focal -a amd64` when encountering the GPG key ring issue.



