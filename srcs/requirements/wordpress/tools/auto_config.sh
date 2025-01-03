#!/bin/bash

mkdir -p /var/www/html/wordpress
mv /var/www/html/wp-config.php /var/www/html/wordpress/wp-config.php

sleep 10;

if [ ! -f /var/www/html/wordpress/wp-config-sample.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root --path=/var/www/html/wordpress/
fi

if ! wp core is-installed --allow-root --path=/var/www/html/wordpress/; then
    echo "Configuring WordPress..."

    # Installer WordPress
    wp core install --allow-root --path=/var/www/html/wordpress/ --url=https://$DOMAIN_NAME --title=$SITE_TITLE --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL

    # Créer un utilisateur supplémentaire
    wp user create $USER1_LOGIN $USER1_MAIL --allow-root --path=/var/www/html/wordpress/ --role=author --user_pass=$USER1_PASS

    # Configurer le site
    wp cache flush --allow-root --path=/var/www/html/wordpress/
    wp language core install en_US --activate --allow-root --path=/var/www/html/wordpress/
    wp plugin delete hello --allow-root --path=/var/www/html/wordpress/
    wp rewrite structure '/%postname%/' --allow-root --path=/var/www/html/wordpress/
    wp plugin install redis-cache --activate --allow-root --path=/var/www/html/wordpress/
    wp post create --post_title='Test Redis' --post_content='This is a test post to generate cache.' --post_status=publish --allow-root --path=/var/www/html/wordpress/
fi

chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

if [ ! -d "/run/php" ]; then
    mkdir -p /run/php
fi

chown -R www-data:www-data /run/php
chmod -R 755 /run/php

if wp plugin is-active redis-cache --allow-root --path=/var/www/html/wordpress/; then
    wp redis enable --allow-root --path=/var/www/html/wordpress/
else
    echo "Redis plugin not active. Skipping redis enable."
fi

exec /usr/sbin/php-fpm7.4 -F -R
