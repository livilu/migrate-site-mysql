#!/bin/bash
#ssh-copy-id to remote server first - mysql over SSH migration
#this tool hopefully will migrate localhost MySQL DB and create user to remote MySQL Linux server
#most likely not apropriate with large database and slow network connection
#/etc/sudoers #Defaults    requiretty
#install pv

#Input data as parameter
mydb="$1"
myruser="$2"

# Die if no input given
[ $# -ne 3 ] && { echo "Usage: $0 DBToBeMigrated RemoteUserToBeGranted -[iv] Interactive mode Or Variables mode"; exit 1; }

case "$3" in

-i)
echo -e "\e[1;92mMigrate over SSH local MySQL db to a remote MySQL server!"
echo -ne "\e[0;39mLocal MySQL user (most likely root): "
read myuser
read -s -p "Local user password: " mypass
echo ""
read -s -p "Remote root MySQL password: " myrrpass
echo ""
read -s -p "Remote MySQL user password to setup: " myrpass
echo ""
echo -e "\e[1;31mRemote SSH details are needed now"
echo -ne "\e[0;39mRemote SSH user:"
read sshruser
read -p "Remote user SSH IP: " sshrip
echo ""

###work
MySQLD=`which mysqldump`
MySQL=`which mysql`
#dump db to remote server
$MySQLD --user="$myuser" --password="$mypass" --databases "$mydb" | pv | ssh "$sshruser"@"$sshrip" 'cat - | mysql --user=root --password='$myrrpass''
if [ $? -eq 0 ]; then echo OK; else echo BAD; fi

#create new user and grant access to migrated db
Q1="GRANT ALL ON *.* TO '$myruser'@'localhost' IDENTIFIED BY '\'$myrpass\'' WITH GRANT OPTION;"
Q2="GRANT ALL PRIVILEGES ON '$mydb'.* TO '$myruser'@'localhost';"
Q3="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}"

ssh -n "$sshruser"@"$sshrip" "$MySQL --user=root --password='$myrrpass' -e '$SQL'"
if [ $? -eq 0 ]; then echo OK; else echo BAD; fi
;;
###work ended

-v)
#Vars to be commented if interactive bahaviour wanted
#Local server
myuser=root
mypass=mypass
#Remote server
myrrpass=mypasswd
myrpass=wwwpass
sshruser=vagrant
sshrip=192.168.56.103
#vars end

###work
MySQLD=`which mysqldump`
MySQL=`which mysql`
#dump db to remote server
$MySQLD --user="$myuser" --password="$mypass" --databases "$mydb" | ssh "$sshruser"@"$sshrip" 'cat - | mysql --user=root --password='$myrrpass''
if [ $? -eq 0 ]; then echo OK; else echo BAD; fi

#create new user and grant access to migrated db
Q1="GRANT ALL ON *.* TO '$myruser'@'localhost' IDENTIFIED BY '\'$myrpass\'' WITH GRANT OPTION;"
Q2="GRANT ALL PRIVILEGES ON '$mydb'.* TO '$myruser'@'localhost';"
Q3="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}"

ssh -n "$sshruser"@"$sshrip" "$MySQL --user=root --password='$myrrpass' -e '$SQL'"
if [ $? -eq 0 ]; then echo OK; else echo BAD; fi
;;
###work ended
*) echo "Invalid option"
;;
esac

# GRANT ALL PRIVILEGES ON *.* TO 'www'@'localhost' IDENTIFIED BY somepasswd  WITH GRANT OPTION;
# GRANT ALL PRIVILEGES ON `www`.* TO 'www'@'localhost';
