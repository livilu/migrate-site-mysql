#!/bin/bash
#ssh-copy-id to remote server first - folder over SSH migration
#this tool hopefully will migrate localhost folder to remote Linux server
#most likely not apropriate with large folder and slow network connection

# Die if no input given
[ $# -ne 2 ] && { echo "Usage, full path: $0 LocalFolder RemoteFolder"; exit 1; }

echo -e "Migrate local folder over SSH to a remote server, user must have write access!"
read -p "Remote SSH user: " sshruser
read -p "Remote SSH IP: " sshrip

tar=`which tar`

#Vars are commented if you want the above interactive bahaviour
sshruser=vagrant
sshrip=192.168.56.103
##vars end

#make sure you create new folder on remote server
ssh -n "$sshruser"@"$sshrip" "sudo mkdir -p '$2'"
cd "$1"
#migrate folder on the fly to remote server
tar czf - "." | pv | ssh "$sshruser"@"$sshrip" "sudo tar xzpf - -C '$2'"
if [ $? -eq 0 ]; then echo OK; else echo BAD; fi
