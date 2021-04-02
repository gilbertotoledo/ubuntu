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

4. Instalar repositorio Ondrej/php para PHP8.0
```
apt-get -y install software-properties-common
add-apt-repository -y ppa:ondrej/php
apt-get -y update
```

5. Instalar Apache e PHP8.0
```
apt-get -y install curl
apt-get -y install apache2 apache2-utils libapache2-mod-php8.0 libapache2-mod-fcgid
apt-get -y install php8.0 php8.0-mysql php8.0-mbstring php8.0-zip php8.0-gd php8.0-json php8.0-curl php8.0-fpm
```

6. Configurar Apache
```
sudo nano /etc/apache2/apache2.conf
ServerName 192.168.1.150
```
```
sudo nano /etc/apache2/mods-enabled/dir.conf
index.php index.html
```

```
sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php8.0-fpm
sudo phpenmod mbstring
```

```
sudo systemctl restart apache2
sudo systemctl status apache2

sudo ufw allow in "Apache Full"
```

7. Configurar MySql
```
sudo apt-get -y install mysql-server
sudo mysql_secure_installation
```
```
sudo mysql -u root -p
mysql> CREATE USER '[myroot]'@'localhost' IDENTIFIED BY '[password]';
mysql> GRANT ALL PRIVILEGES ON *.* TO '[myroot]'@'localhost' WITH GRANT OPTION;
mysql> CTRL + D
```
```
systemctl status mysql.service
```

8. Instalar PhpMyAdmin
```
sudo apt-get -y install phpmyadmin
```
```
sudo nano /etc/apache2/apache2.conf
- Include /etc/phpmyadmin/apache.conf
```
```
sudo systemctl restart apache2
```

9. Configurar proteção para PhpMyAdmin (opcional/recomendado)
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

10. Adicionar usuário (opcional)
```
sudo htpasswd /etc/phpmyadmin/.htpasswd [username] 
```
