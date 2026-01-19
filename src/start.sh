#!/bin/bash

echo "ServerName localhost" >> /etc/apache2/apache2.conf

if [ "$INDEX" = "1" ]; then
    echo "Mode INDEX=1 ACTIVÉ"

    rm -f /var/www/html/index.php

    # On modifie la configuration d'Apache pour activer les Indexes
    sed -i "s/Indexes//g" /etc/apache2/apache2.conf
fi

rm -f /var/run/apache2/apache2.pid

echo "Lancement d'Apache..."
apachectl -D FOREGROUND