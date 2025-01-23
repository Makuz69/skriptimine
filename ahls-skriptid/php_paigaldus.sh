#!/bin/bash
# Näitame, kas PHP on juba installitud, kui vastuse väärtus on 0, siis ei ole.
# Kui väärtus on 1, siis on installitud

PHP=$(dpkg-query -W -f='${Status}' php8.2 2>/dev/null | grep -c 'ok installed')

# Väärtus võrdub 0-ga, siis ei ole installitud

if [ $PHP -eq 0 ]; then
	
	echo "PHP ei ole installitud, paigaldame PHP ja lisad"
	apt install -y php8.2 libapache2-mod-php8.2 php8.2-mysql
	echo "PHP koos vajalike lisadega sai paigaldatud"

# Väärtus võrdub 1-ga, siis on paigaldatud

elif [ $PHP -eq 1 ]; then
	echo "PHP koos vajalike lisadega on juba paigaldatud!"
	
	which php
	
# Lõpetame tingimuse

fi

# Vaatame, kas PHP töötab
if systemctl is-active --quiet php-fpm; then
    echo "PHP-FPM töötab."
else
    echo "PHP-FPM ei tööta."
fi

	
