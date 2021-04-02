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

apt-get -y update
apt-get -y upgrade
apt-get -y install software-properties-common
add-apt-repository -y ppa:ondrej/php
apt-get -y update
apt-get -y install curl vim 
apt-get -y install apache2 apache2-utils libapache2-mod-php8.0 libapache2-mod-fcgid
apt-get -y install php8.0 php8.0-mysql php8.0-mbstring php8.0-zip php8.0-gd php8.0-json php8.0-curl php8.0-fpm
apt-get -y install mysql-server

FIND="index\.php "
REPLACE=""
sed -i "0,/$FIND/s/$FIND/$REPLACE/m" /etc/apache2/mods-available/dir.conf

FIND="DirectoryIndex"
REPLACE="DirectoryIndex index\.php"
sed -i "0,/$FIND/s/$FIND/$REPLACE/m" /etc/apache2/mods-available/dir.conf

a2enmod proxy_fcgi setenvif
a2enconf php8.0-fpm
phpenmod mbstring

systemctl restart apache2

ufw status
ufw app list
ufw allow OpenSSH
ufw allow http
ufw allow https
ufw allow in "Apache Full"
echo "y" | ufw enable

echo -e "\n\nFirewall configuration finished!\n\n"

mysql_secure_installation

echo -e "\n\nPlease enter root password MySQL configured on previous steps:"
read -sp "Root MySql password: " rootpasswd

echo -e "\n\nPlease enter username for PhpMyAdmin user root:"
read -p "Username: " pmausername

echo -e "\n\nPlease enter password for PhpMyAdmin user root:"
read -sp "Password: " pmapassword

mysql -uroot -p${rootpasswd} -e "CREATE USER '${pmausername}'@'localhost' IDENTIFIED BY '${pmapassword}';"
mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON *.* TO '${pmausername}'@'localhost' WITH GRANT OPTION;"

apt-get -y install phpmyadmin

sed -i '$a Include /etc/phpmyadmin/apache.conf' /etc/apache2/apache2.conf

systemctl restart apache2

echo -e "\n\nLAMP Install successfull!\n\n"
