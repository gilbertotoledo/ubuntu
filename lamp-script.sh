#!/bin/bash

#Make lamp-script.sh executable
#sudo chmod +x lamp-script.sh

while true; do
	read -p "Do you want to install Apache + PHP + Mysql? [Y/N]" cnt1
	case $cnt1 in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) printf "Please answer Y or N\n";;
	esac
done

apt-get -y update && apt-get -y upgrade
apt-get -y install curl vim 
apt-get -y install apache2 apache2-utils php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl
apt-get -y install mysql-server

FIND="index\.php "
REPLACE=""
sed -i "0,/$FIND/s/$FIND/$REPLACE/m" /etc/apache2/mods-available/dir.conf

FIND="DirectoryIndex"
REPLACE="DirectoryIndex index\.php"
sed -i "0,/$FIND/s/$FIND/$REPLACE/m" /etc/apache2/mods-available/dir.conf

systemctl restart apache2

ufw status
ufw app list
ufw allow OpenSSH
ufw allow http
ufw allow https
ufw allow in "Apache Full"
echo "y" | sudo ufw enable

echo "\n\nFirewall configuration finished!\n\n"

mysql_secure_installation

echo "\n\nPlease enter root password MySQL configured on previous steps: \n"
read -sp "Root MySql password: " rootpasswd

echo "\n\nPlease enter username for PhpMyAdmin user root: \n"
read -p "Username: " pmausername

echo "\n\nPlease enter password for PhpMyAdmin user root: \n"
read -sp "Password" pmapassword

mysql -uroot -p${rootpasswd} -e "CREATE USER '${pmausername}'@'localhost' IDENTIFIED BY '${pmapassword};"
mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON *.* TO '${pmausername}'@'localhost' WITH GRANT OPTION;"

apt-get -y install phpmyadmin
phpenmod mbstring

sed -i '$a Include /etc/phpmyadmin/apache.conf' /etc/apache2/apache2.conf

systemctl restart apache2

echo "\n\nLAMP Install successfull!\n\n"
