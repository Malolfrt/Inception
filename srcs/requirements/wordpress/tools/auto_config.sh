#!/bin/bash
#set -eux

# until mysqladmin ping -h mariadb --silent; do
#     echo "Waiting for MariaDB...";
#     sleep 2;
# done

sleep 10;

cd /var/www/html/wordpress

if ! wp core is-installed; then
wp config create --allow-root --dbname=${SQL_DATABASE} \
            --dbuser=${SQL_USER} \
            --dbpass=${SQL_PASSWORD} \
            --dbhost=${SQL_HOST} \
            --url=https://${DOMAIN_NAME};

wp core install --allow-root \
            --url=https://{DOMAIN_NAME} \
            --title=${SITE_TITLE} \
            --admin_user=${ADMIN_USER} \
            --admin_password=${ADMIN_PASSWORD} \
            --admin_email=${ADMIN_MAIL};

wp user create      --allow-root \
        ${USER1_LOGIN} ${USER1_MAIL} \
        --role=author \
        --user_pass=${USER1_PASS} \

wp cache flush --allow-root

# it provides an easy-to-use interface for creating custom contact forms and managing submissions
wp plugin install contact-form-7 --activate

# set the site language to english
wp language core install en_US --activate

# remove default themes and plugings
wp theme delete twemtynineteen twentytwenty
wp plugin delete hello

# set the permalink structure
wp rewrite structure '/%postname%/'

fi

if [ ! -d /run/php ]; then
    mkdir /run/php;
fi

# start the PHP FastCGI Process Manager (FPM) for PHP version 7.3 in the foreground
exec /usr/sbin/php-fm7.3 -F -R