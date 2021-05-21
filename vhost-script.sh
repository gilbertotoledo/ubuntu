#!/bin/bash

#Make vhost-script.sh executable
#sudo chmod +x vhost-script.sh

while true; do
	read -p "Do you want to create a new Virtual Host? [Y/N]" cnt1
	case $cnt1 in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) printf "Please answer Y or N\n";;
	esac
done

echo -e "\n\nPlease enter username for host:"
read -sp "Username: " username

echo -e "\n\nPlease enter domain for host:"
read -sp "Domain (abc.com.br): " domain

echo -e "\n\nPlease enter alias for host:"
read -sp "Alias (www.abc.com.br): " alias

adduser ${username}
usermod -aG www-data ${username}

echo -e "\n\nUser created!\n\n"

sudo mkdir /var/www/${username}
sudo mkdir /var/www/${username}/public_html
sudo chown -R vsftpd:nogroup /var/www/${username}
sudo chmod -w /var/www/${username}
sudo chmod -R 775 /var/www/${username}/public_html

echo -e "\n\nUser diretory created!\n\n"

cat > /etc/apache2/sites-available/${domain}.conf << EOF1
<VirtualHost *:80>
	ServerName ${domain}
	ServerAlias ${alias}
	ServerAdmin ogilbertotoledo@gmail.com
	DocumentRoot /var/www/${username}/public_html

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
    
	<Directory /var/www/${username}/public_html>
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>
</VirtualHost>
EOF1

sudo a2ensite ${domain}.conf

echo -e "\n\nVirtualHost created!\n\n"

sudo htpasswd -d /etc/vsftpd/ftpd.passwd ${username}

sed -i '$a ${username}' /etc/vsftpd.userlist

echo -e "\n\nFTP user created!\n\n"

sudo service apache2 restart
sudo service vsftpd restart

echo -e "\n\nFinished!\n\n"
