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
read -p "Username: " username

echo -e "\n\nPlease enter domain for host:"
read -p "Domain (abc.com.br): " domain

echo -e "\n\nPlease enter alias for host:"
read -p "Alias (www.abc.com.br): " alias

echo -e "\n\nWhat port is the application running on?"
read -p "Port: " port

adduser ${username}
usermod -aG www-data ${username}

echo -e "\nUser created!\n\n"

sudo mkdir /var/www/${username}
sudo mkdir /var/www/${username}/publish
sudo chown -R vsftpd:nogroup /var/www/${username}
sudo chmod -w /var/www/${username}
sudo chmod -R 775 /var/www/${username}/publish

echo -e "\nUser diretory created!\n"

cat > /etc/apache2/sites-available/${domain}.conf << EOF1
<VirtualHost *:80>  
	ServerName ${domain}
	DocumentRoot /var/www/${username}/publish

	ProxyPreserveHost On
	ProxyPass / http://localhost:${port}/
	ProxyPassReverse / http://localhost:${port}/

	RewriteEngine on
	RewriteCond %{HTTP:UPGRADE} ^WebSocket$ [NC]
	RewriteCond %{HTTP:CONNECTION} Upgrade$ [NC]
	RewriteRule /(.*) ws://127.0.0.1:${port}/$1 [P]

	ErrorLog ${APACHE_LOG_DIR}/error-${domain}.log
	CustomLog ${APACHE_LOG_DIR}/access-${domain}.log combined

	<Directory /var/www/${username}/publish>
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>
</VirtualHost>

EOF1

sudo a2ensite ${domain}.conf

echo -e "\nVirtualHost created!\n"

sudo htpasswd -d /etc/vsftpd/ftpd.passwd ${username}

printf "%s\n" ${username} >> /etc/vsftpd.userlist

echo -e "\nFTP user created!\n"

sudo service apache2 restart
sudo service vsftpd restart

sudo certbot --apache -d ${domain}

echo -e "\n\nHTTPS configured!\n\n"

echo -e "\n\nYour v-host is served on ${domain}!\n\n"
