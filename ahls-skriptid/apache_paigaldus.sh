# apache paigaldusskript

# kontroll, kas apache2 on installitud
APACHE2=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c 'ok installed')
# kui väärtus 0, siis ei ole installitud. Teavitame sellest ja 
# paigaldame apache, ning väljastame kui on paigaldatud
if [ $APACHE2 -eq 0 ]; then
	echo "Paigaldame apache2" 
	apt install apache2
	echo "Apache on paigaldatud"
# kui APACHE2 väärtus on 1, siis on installitud, teavitame
# sellest, et on installitud. Stardime ja näitame staatust
elif [ $APACHE2 -eq 1 ]; then
	echo "apache2 on juba paigaldatud"
	service apache2 start
	service apache2 status
# lõpetame tingimuslause
fi
