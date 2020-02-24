#!/bin/bash
clear
echo "Reading properties ....."
file="./properties.txt"
if [ -f "$file" ]								#Load file with properties 
then
    echo "$file found."
    while IFS='=' read -r key value						#Read the file with properties
    do
        key=$(echo $key | tr '.' '_')
        eval ${key}=\${value}
    done < "$file"
    user="${db_user}"								#save the user value in variable
    pass="${db_passwd}"								#save the pass value in variable
    port="${db_port}"								#save the port value in variable
    name="${db_name}"								#save the name value in variable
else
    echo "$file not found."
fi

echo    "Chech the connection"

if psql -U $user -lqt | cut -d \| -f 1 | grep -qw $name;			#Chech if the ddbb exist
										
										#database called "List, "Access" or "rows" will succeed. So we 											pipe this output through a bunch of built-in command line 											tools to only search in the first column
										
										#The next bit, cut -d \| -f 1 splits the output by the 											vertical pipe | character (escaped from the shell with a 											backslash), and selects field 1. This leaves:
										
										#grep -w matches whole words, and so won't match if you are 											searching for temp in this scenario. The -q option suppresses 											any output written to the screen, so if you want to run this 											interactively at a command prompt you may with to exclude the 											-q so something gets displayed immediately
										


then
	echo "I'm connected"
	exit
fi

echo 	"I'm not connected, i will install postgres"

echo    "Now we are going to delete the database, are you sure you want to continue?"

read -p "press enter to continue." sacrificial

echo 	"Delete and reload ddbb"
sudo apt-get --purge remove postgresql-10 postgresql-client-10 postgresql-client-common postgresql-common postgresql-contrib postgresql-contrib-10										#Remove the DDBB to install again

echo    "instal postgres"						
sudo 	apt install postgresql postgresql-contrib					#Install a postgresql
sudo 	apt-get install postgresql-client
echo    "installation finished"
echo    "Add configurations"

echo    "Add new postgressql.conf"
findPostgresql=$(find / -name "postgresql.conf") 			#Find the path where locate postgresql.conf
pathPostgres=$(sudo dirname "$findPostgresql")				#SAve the dirname of this file
sudo chmod 777 $pathPostgres						#give permissions to modify the directory
sudo cp postgresql.conf $pathPostgres					#Copy the new file it  the directory

echo    "Add new pg_hba.conf"
findPghba=$(find / -name "pg_hba.conf") 				#Find the path where locate postgresql.conf
pathHba=$(sudo dirname "$findPghba")					#SAve the dirname of this file
sudo chmod 777 $pathHba							#give permissions to modify the directory
sudo cp pg_hba.conf $pathHba						#Copy the new file it  the directory
	
echo    "conect to ddbb && create ddbb"
sudo -u $user psql < load.sql							#Load the configuratios to save de creates datatable

echo    "import ddbb"
sudo -u $user psql< xcurrent_postgresql.sql					#Import the sql

echo    "Chech the connection again"

if psql -U $user -lqt | cut -d \| -f 1 | grep -qw $name;			#Check again
then
	echo "I'm connected"

	echo    "Add new service.settings"
	findServiceSettings=$(find / -name 'service.settings')			
	pathServiceSettings="${findServiceSettings%/*}"
	sudo cp david.txt $pathServiceSettings					
	exit
fi


echo "I'm not connected"



