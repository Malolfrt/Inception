#!/bin/bash

sleep 10
wp config create --allow-root \
            --dbname=$SQL_DATABASE \
            --dbuser=$SQL_USER \
            --dbpass=$SQL_PASSWORD \
            --dbhost=mariadb:3306 \
            --path='/var/www/wordpress' || exit 1

wp core install --allow-root \
            --url='mlefort.42.fr' \
            --title='WordPress' \
            --admin_user='root' \
            --admin_password='root' \
            --admin_email='root@42.fr' || exit 1

wp user create mlefort mlefort@42.fr 
                        --role=contributor \
                        --user_password='mlefort' \
                        --display_name='mlefort' \
                        --allow-root || exit 1
