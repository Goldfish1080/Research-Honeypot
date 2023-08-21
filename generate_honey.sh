#!/bin/bash
#There will be two(three?) more of these but have different total number of files 
#Takes in the name of the container and the CSV file
if [ $# -ne 1 ]
then 
  echo "Not enough"
fi 
#Copies 
cp $2 /var/lib/lxc/"$1"/rootfs/ 
sudo lxc-attach -n "$1" -- bash -c "echo -e Y\n | sudo apt upgrade"
#Installs the MYSQL server
sudo lxc-attach -n "$1" -- bash -c "echo -e Y\n | sudo apt install mysql-server"
#To avoid any errors when importing the CSV file
sudo lxc-attach -n "$1" -- bash -c "sudo echo secure-file-priv = \"\" >> /etc/mysql/mysql.conf.d/mysqld.cnf"
sudo lxc-attach -n "$1" -- bash -c "sudo echo local_infile=1 >> /etc/mysql/mysql.conf.d/mysqld.cnf"
sudo lxc-attach -n "$1" -- bash -c "sudo systemctl restart mysql"
#Create the database
sudo lxc-attach -n "$1" -- bash -c 'mysql -u root -e "create database unga"';
#Creates the table inside the database
sudo lxc-attach -n "$1" -- bash -c 'mysql -u root -e "use files"';
sudo lxc-attach -n "$1" -- bash -c 'mysql -u root -D files -e "create table students(Id_number bigint not null, Name varchar(255) not null, Birthday varchar(255) not null, Address varchar(255) not null, Password varchar(255) not null, Email varchar(255) not null, Phone_Number varchar(255) not null)"';
#Imports the CSV file onto the table
#The file name honey.csv is a placeholder 
sudo lxc-attach -n "$1" -- bash -c 'mysql --local-infile=1 -u root -D files -e "load data local infile \"honey.csv\" into table students fields terminated by \",\" lines terminated by \"\n\" ignore 1 rows"';
sudo lxc-attach -n "$1" -- bash -c 'sudo mysql --local-infile=1 -u root';
