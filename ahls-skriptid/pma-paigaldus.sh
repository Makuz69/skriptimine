#!/bin/bash
# Enne phpmyadmini installimist, installime mariadb

MDB=$(dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep -c 'ok installed')

if [ $MDB -eq 0 ]; then

	echo "MariaDB ei ole veel installitud"
	sleep 1
	echo "Installime MariaDB"
	apt install -y mariadb-server mariadb-client
	echo "MariaDB koos vajalike lisadega on paigaldatud"

elif [ $MDB -eq 1 ]; then

	echo "MariaDB on juba paigaldatud!"
	sleep 1
fi


# Nüüd paigaldame vajadusel phpmyadmini

PMA=$(dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -c 'ok installed')

if [ $PMA -eq 0 ]; then

	echo "Phpmyadmin ei ole veel installitud"
	sleep 1
	echo "Installime phpmyadmin-i"
	apt install -y phpmyadmin
	echo "Phpmyadmin on paigaldatud!"

elif [ $PMA -eq 1 ]; then

	echo "Phpmyadmin on juba paigaldatud!"
	
fi
