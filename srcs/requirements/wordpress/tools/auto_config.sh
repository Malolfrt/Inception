# #!/bin/bash

# # S'assurer que le dossier existe
# mkdir -p /var/www/html/wordpress

# # echo "Waiting for MariaDB to be ready..."
# # until mysqladmin ping -h $SQL_HOST --silent; do
# #     echo "MariaDB is unavailable - retrying in 5 seconds..."
# #     sleep 5
# # done

# sleep 10;

# if [ -f /var/www/html/wordpress/wp-config.php ]; then
#     rm -f /var/www/html/wordpress/wp-config.php
# fi

# # Télécharger WordPress si nécessaire
# if [ ! -f /var/www/html/wordpress/wp-config-sample.php ]; then
#     echo "Downloading WordPress..."
#     wp core download --allow-root --path=/var/www/html/wordpress
# fi

# # Vérifier si WordPress est déjà installé
# if ! wp core is-installed --allow-root --path=/var/www/html/wordpress; then
#     echo "Configuring WordPress..."

#     # Créer le fichier wp-config.php
#     wp config create --allow-root --path=/var/www/html/wordpress --dbname=$SQL_DATABASE --dbuser=$SQL_USER --dbpass=$SQL_PASSWORD --dbhost=$SQL_HOST --url=https://$DOMAIN_NAME

#     # Installer WordPress
#     wp core install --allow-root --path=/var/www/html/wordpress --url=https://$DOMAIN_NAME --title=$SITE_TITLE --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL

#     # Créer un utilisateur supplémentaire
#     wp user create $USER1_LOGIN $USER1_MAIL --allow-root --path=/var/www/html/wordpress --role=author --user_pass=$USER1_PASS

#     # Configurer le site
#     wp cache flush --allow-root --path=/var/www/html/wordpress
#     wp plugin install contact-form-7 --activate --allow-root --path=/var/www/html/wordpress
#     wp language core install en_US --activate --allow-root --path=/var/www/html/wordpress
#     wp theme delete twentynineteen twentytwenty --allow-root --path=/var/www/html/wordpress
#     wp plugin delete hello --allow-root --path=/var/www/html/wordpress
#     wp rewrite structure '/%postname%/' --allow-root --path=/var/www/html/wordpress
# fi

# # Assurer les permissions
# chown -R www-data:www-data /var/www/html/wordpress
# chmod -R 755 /var/www/html/wordpress

# # Créer le dossier pour PHP si nécessaire
# if [ ! -d "/run/php" ]; then
#     mkdir -p /run/php
# fi

# chown -R www-data:www-data /run/php
# chmod -R 755 /run/php

# # Lancer PHP-FPM
# exec /usr/sbin/php-fpm7.4 -F -R


#!/bin/bash

# S'assurer que le dossier existe
mkdir -p /var/www/html/wordpress

# Attendre que MariaDB soit prêt (si activé dans le Docker Compose)
# echo "Waiting for MariaDB to be ready..."
# until mysqladmin ping -h $SQL_HOST --silent; do
#     echo "MariaDB is unavailable - retrying in 5 seconds..."
#     sleep 5
# done

# Attente statique (pour éviter les erreurs pendant l'installation initiale)
sleep 10;

# Supprimer wp-config.php s'il existe
if [ -f /var/www/html/wordpress/wp-config.php ]; then
    rm -f /var/www/html/wordpress/wp-config.php
fi

# Télécharger WordPress si nécessaire
if [ ! -f /var/www/html/wordpress/wp-config-sample.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root --path=/var/www/html/wordpress
fi

# Vérifier si WordPress est déjà installé
if ! wp core is-installed --allow-root --path=/var/www/html/wordpress; then
    echo "Configuring WordPress..."

    # Créer le fichier wp-config.php
    wp config create --allow-root --path=/var/www/html/wordpress --dbname=$SQL_DATABASE --dbuser=$SQL_USER --dbpass=$SQL_PASSWORD --dbhost=$SQL_HOST --url=https://$DOMAIN_NAME

    # Installer WordPress
    wp core install --allow-root --path=/var/www/html/wordpress --url=https://$DOMAIN_NAME --title=$SITE_TITLE --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL

    # Créer un utilisateur supplémentaire
    wp user create $USER1_LOGIN $USER1_MAIL --allow-root --path=/var/www/html/wordpress --role=author --user_pass=$USER1_PASS

    # Configurer le site
    wp cache flush --allow-root --path=/var/www/html/wordpress
    wp plugin install contact-form-7 --activate --allow-root --path=/var/www/html/wordpress
    wp language core install en_US --activate --allow-root --path=/var/www/html/wordpress
    wp theme delete twentynineteen twentytwenty --allow-root --path=/var/www/html/wordpress
    wp plugin delete hello --allow-root --path=/var/www/html/wordpress
    wp rewrite structure '/%postname%/' --allow-root --path=/var/www/html/wordpress
fi

# Assurer les permissions
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

# Créer le dossier pour PHP si nécessaire
if [ ! -d "/run/php" ]; then
    mkdir -p /run/php
fi

chown -R www-data:www-data /run/php
chmod -R 755 /run/php

# Lancer PHP-FPM
exec /usr/sbin/php-fpm7.4 -F -R
