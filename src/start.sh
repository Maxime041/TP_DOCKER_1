#!/bin/bash

echo "ServerName localhost" >> /etc/apache2/apache2.conf

service mariadb start

sleep 2
echo "Création de la base et de l'utilisateur..."
echo "CREATE DATABASE wordpress;" | mariadb -u root
echo "CREATE USER 'maximetest'@'localhost' IDENTIFIED BY 'secret';" | mariadb -u root
echo "GRANT ALL PRIVILEGES ON *.* TO 'maximetest'@'localhost';" | mariadb -u root
echo "FLUSH PRIVILEGES;" | mariadb -u root

if [ "$INDEX" = "1" ]; then
    echo "Mode INDEX=1 ACTIVÉ"

    rm -f /var/www/html/index.php
    rm -rf /var/www/html/phpmyadmin

    # On modifie la configuration d'Apache pour activer les Indexes
    sed -i "s/Indexes//g" /etc/apache2/apache2.conf
fi

rm -f /var/run/apache2/apache2.pid

echo "Lancement d'Apache..."
apachectl -D FOREGROUND