#!/bin/bash

#Script to wait until mysql is started
maxcounter=45
counter=1
echo mysql  -u"root" -p"${MYSQL_ROOT_PASSWORD}" -e "show databases;" > /dev/null 2>&1;
echo "Checking status..."
while ! mysql  -u"root" -p"${MYSQL_ROOT_PASSWORD}" -e "show databases;" > /dev/null 2>&1; do
    echo "Waiting for MySQL..."
    sleep 1
    counter=`expr $counter + 1`
    if [ $counter -gt $maxcounter ]; then
        >&2 echo "Couldn't get MySQL running. Aborting"
        exit 1
    fi;

done

#Check whether databases exists

if [[ ! -d "/var/lib/mysql/app/" ]]
then
    echo "Creating Database ..."
    mysql -u"root"  -p"${MYSQL_ROOT_PASSWORD}" -e"create database DirectOne"
    echo "Database Creation complete!"
else
    echo "Database already exists. Aborting import"
fi
#Ensure mysql is running in foreground
#tail -f /dev/null
