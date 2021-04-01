0. Atualizar pacotes
```
sudo apt-get update
```

1. Instalar editor de texto (opcional)
```
sudo apt-get install nano
```

2. Instalar servidor SSH (opcional)
```
sudo apt-get install openssh-server
sudo service ssh start
```

3. Configurar firewall
```
sudo ufw status
sudo ufw allow OpenSSH
sudo ufw allow http
sudo ufw allow https
sudo ufw enable
```

4. Instalar Apache, PHP, Mysql
```
sudo apt-get install apache2 apache2-utils mysql-server php libapache2-mod-php php-mysql
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
```


6. Configurar MySql
```
sudo mysql_secure_installation
```

5. Adicionar permissão para o Apache no firewall
```
sudo ufw allow in "Apache Full"
```

6. Instalar PHPMyAdmin
```
sudo apt-get install phpmyadmin
sudo nano /etc/apache2/apache2.conf
- Include /etc/phpmyadmin/apache.conf
sudo nano /etc/apache2/apache2.conf
```
