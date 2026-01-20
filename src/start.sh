#!/bin/bash

service mariadb start

sleep 2
echo "Création de la base et de l'utilisateur..."
echo "CREATE DATABASE IF NOT EXISTS wordpress;" | mariadb -u root
echo "CREATE USER IF NOT EXISTS 'maximetest'@'localhost' IDENTIFIED BY 'secret';" | mariadb -u root
echo "GRANT ALL PRIVILEGES ON *.* TO 'maximetest'@'localhost';" | mariadb -u root
echo "FLUSH PRIVILEGES;" | mariadb -u root

if [ "$INDEX" = "1" ]; then
    echo "Autoindex : DÉSACTIVÉ (INDEX=1)"
    sed -i 's/autoindex on;/autoindex off;/g' /etc/nginx/sites-available/default
    sed -i "2i header('Location: /index.html'); exit;" /var/www/html/wordpress/index.php
    sed -i "2i header('Location: /index.html'); exit;" /var/www/html/phpmyadmin/index.php
    sed -i "2i header('Location: /index.html'); exit;" /var/www/html/index.php
    sed -i '2i <meta http-equiv="refresh" content="0;url=/index.html" />' /var/www/html/index.nginx-debian.html
fi

service php7.4-fpm start

echo "Lancement de Nginx..."
nginx -g 'daemon off;'