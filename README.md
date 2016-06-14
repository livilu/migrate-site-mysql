# migrate-sire-mysql
Requirements:  
1. Copy public ssh key to remote server - ssh-copy-id  
2. install pv which is a pipe meter to provides some output during the transfer  
3. Edit /etc/sudoers and comment #Defaults    requiretty - no security benefit  

Scripts:  
1. migrate_folder.sh will migrate a local folder to a new remote location - folder will be created as well, recursive  
2. migrate_mysql.sh  will migrate a local MySQL DB to a remote server. Script will handle the new MySQL user creation on remote side as well
