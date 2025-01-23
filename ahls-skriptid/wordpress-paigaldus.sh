#!/bin/bash

# kontroll, kas apache2 on installitud

APACHE2=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c 'ok installed')

if [ $APACHE2 -eq 0 ]; then

        echo "Paigaldame apache2"
        apt install apache2
        echo "Apache on paigaldatud"

elif [ $APACHE2 -eq 1 ]; then

        echo "apache2 on juba paigaldatud"
        service apache2 start

fi

# Kontroll, kas MYSQL on installitud

MYSQL=$(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c 'ok installed')
if [ $MYSQL -eq 0 ]; then

        echo "MYSQL ei ole paigaldatud"
        sleep 1
        echo "Paigaldame MYSQL"

        apt install mysql-server

        echo "MYSQL koos vajalike lisadega on paigaldatud"
        sleep 1

elif [ $MYSQL -eq 1 ]; then

        echo "MYSQL on juba paigaldatud!"
        sleep 1

fi

# Kontroll, kas PHP on installitud

PHP=$(dpkg-query -W -f='${Status}' php8.2 2>/dev/null | grep -c 'ok installed')

if [ $PHP -eq 0 ]; then

        echo "PHP ei ole installitud, paigaldame PHP ja lisad"
        apt install -y php8.2 libapache2-mod-php8.2 php8.2-mysql php8.2-curl php8.2-xml
        echo "PHP koos vajalike lisadega sai paigaldatud"


elif [ $PHP -eq 1 ]; then
        echo "PHP koos vajalike lisadega on juba paigaldatud!"


fi

# Loome MYSQLi andmebaasi ja kasutaja WP jaoks

        echo "Loome MySQL andmebaasi ja kasutaja WordPressi jaoks..."

read -p "Sisestage MySQL root parool: " rootpass
read -p "Sisestage andmebaasi nimi: " dbname
read -p "Sisestage andmebaasi kasutajanimi: " dbuser
read -p "Sisestage parool kasutajale $dbuser: " userpass

# Käivitame mysqli ja lisame sinna andmed

mysql -u root -p"$rootpass" <<MYSQL_SCRIPT
CREATE DATABASE $dbname;
CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$userpass';
GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

        echo "Andmebaas ja kasutaja on loodud."

# Installime WP

        echo "Laadime alla ja installime WordPressi..."

        cd /tmp || exit
        wget https://wordpress.org/latest.tar.gz
        tar xzvf latest.tar.gz

# Liigutame WP failid veebikausta

        mv wordpress/* /var/www/html/

# Muudame WP failide õigusi

        chown -R www-data:www-data /var/www/html/
        chmod -R 777 /var/www/html/

# Loome faili  wp-config.php sample failist

        cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Uuendame wp-config.php andmebaasi andmetega

        sed -i "s/database_name_here/$dbname/" /var/www/html/wp-config.php
        sed -i "s/username_here/$dbuser/" /var/www/html/wp-config.php
        sed -i "s/password_here/$userpass/" /var/www/html/wp-config.php

        echo "WordPress on edukalt paigaldatud! Palun minge oma brauserisse ja avage http://192.168.46.98/install.php, et lõpule viia installimine."


