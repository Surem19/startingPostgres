#!/bin/bash
clear
echo "Reading properties ....."
file="./properties.txt"
if [ -f "$file" ]
then
    echo "$file found."
    while IFS='=' read -r key value
    do
        key=$(echo $key | tr '.' '_')
        eval ${key}=\${value}
    done < "$file"
    user="${db_user}"
    pass="${db_passwd}"
    port="${db_port}"
    name="${db_name}"
else
    echo "$file not found."
fi

echo    "Chech the connection"

if psql -U $user -lqt | cut -d \| -f 1 | grep -qw $name;			#Chech if the ddbb exist
then
	echo "I'm connected"
	exit
fi

echo 	"I'm not connected, i will install postgres"

echo    "Now we are going to delete the database, are you sure you want to continue?"

read -p "press enter to continue." sacrificial

echo 	"Delete and reload ddbb"
sudo apt-get --purge remove postgresql-10 postgresql-client-10 postgresql-client-common postgresql-common postgresql-contrib postgresql-contrib-10

echo    "instal postgres"						
sudo 	apt install postgresql postgresql-contrib					#Install a postgresql
sudo 	apt-get install postgresql-client
echo    "installation finished"
echo    "Add configurations"

echo    "Add new postgressql.conf"
findPostgresql=$(find / -name "postgresql.conf") 			#Find the path where locate postgresql.conf
pathPostgres=$(sudo dirname "$findPostgresql")
sudo chmod 777 $pathPostgres
cp postgresql.conf $pathPostgres

echo    "Add new pg_hba.conf"
findPghba=$(find / -name "pg_hba.conf") 			#Find the path where locate postgresql.conf
pathHba=$(sudo dirname "$findPghba")
sudo chmod 777 $pathHba
cp pg_hba.conf $pathHba
	
echo    "conect to ddbb && create ddbb"
psql -U $user < load.sql							#Install a postgresql

echo    "import ddbb"
psql -U $user $name < xcurrent_postgresql.sql					#Install a postgresql

echo    "Chech the connection again"

if psql -U $user -lqt | cut -d \| -f 1 | grep -qw $name;			#Install a postgresql
then
	echo "I'm connected"

	echo    "Add new service.settings"
	findServiceSettings=$(find / -name 'service.settings')			#Find the path where locate postgresql.conf
	pathServiceSettings="${findServiceSettings%/*}"
	sudo cp david.txt $pathServiceSettings					#Save new file in the path
	exit
fi


echo "I'm not connected"




