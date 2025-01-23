#!/bin/bash

# Vaatame, kas mysql-server on juba installitud. 
# Kui väärtus võrdub 1-ga, siis on installitud.
# Kui väärtus võrdub 0-ga, siis ei ole veel installitud.

MYSQL=$(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c 'ok installed')

# juhul, kui väärtus võrdub 0-ga

if [ $MYSQL -eq 0 ]; then
	
	echo "MYSQL ei ole paigaldatud"
	sleep 1
	echo "Paigaldame MYSQL"
	
	apt install mysql-server
	
	echo "MYSQL koos vajalike lisadega on paigaldatud"
	sleep 1

	#lisame võimaluse kasutada mysqli ilma kasutaja ja paroolita
	
	touch $HOME/.my.cnf
	echo "[client]" >> $HOME/.my.cnf
	echo "host = localhost" >> $HOME/.my.cnf
	echo "user = root" >> $HOME/.my.cnf
	echo "password = qwerty" >> $HOME/.my.cnf

# juhul, kui väärtus võrdub 1-ga

elif [ $MYSQL -eq 1 ]; then

	echo "MYSQL on juba paigaldatud!"

# lõpetame tingimuse

fi

# Vaatame, kas PHP töötab
if systemctl is-active --quiet mysql; then
    echo "MYSQL töötab!"
else
    echo "MYSQL ei tööta!"

#lõpetame uuesti tingimuse
fi
