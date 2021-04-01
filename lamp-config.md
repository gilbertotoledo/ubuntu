0. Atualizar pacotes
```
sudo apt-get update
sudo apt-get upgrade
```

1. Instalar editor de texto (opcional)
```
sudo apt-get -y install nano
```

2. Instalar servidor SSH (opcional)
```
sudo apt-get -y install openssh-server
sudo service ssh start
```

3. Configurar firewall
```
sudo ufw status
sudo ufw app list
sudo ufw allow OpenSSH
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

4. Instalar Apache e PHP
```
sudo apt-get -y install apache2 apache2-utils php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl
```

5. Configurar Apache
```
sudo nano /etc/apache2/apache2.conf
ServerName 192.168.1.150
```
```
sudo nano /etc/apache2/mods-enabled/dir.conf
index.php < index.html
```
```
sudo systemctl restart apache2
sudo systemctl status apache2

sudo ufw allow in "Apache Full"
```

6. Configurar MySql
```
sudo apt-get -y install mysql-server
sudo mysql_secure_installation
```
```
sudo mysql -u root -p
mysql> CREATE USER '[myroot]'@'localhost' IDENTIFIED BY '[password]';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'myroot'@'localhost' WITH GRANT OPTION;
mysql> exit
```
```
systemctl status mysql.service
```

7. Instalar PhpMyAdmin
```
sudo apt-get -y install phpmyadmin
sudo phpenmod mbstring
```
```
sudo nano /etc/apache2/apache2.conf
- Include /etc/phpmyadmin/apache.conf
```
```
sudo systemctl restart apache2
```

8. Configurar proteção para PhpMyAdmin (opcional/recomendado)
```
sudo nano /etc/apache2/conf-available/phpmyadmin.conf
AllowOverride All
```
```
sudo systemctl restart apache2
```
```
sudo nano /usr/share/phpmyadmin/.htaccess
AuthType Basic
AuthName "Restricted Files"
AuthUserFile /etc/phpmyadmin/.htpasswd
Require valid-user
```
```
sudo htpasswd -c /etc/phpmyadmin/.htpasswd [username]
```

8.1. Adicionar usuário
```
sudo htpasswd /etc/phpmyadmin/.htpasswd [username] 
```
