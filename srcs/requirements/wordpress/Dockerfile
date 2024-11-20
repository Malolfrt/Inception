FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install wget -y
RUN apt-get install -y php7.3 \
php-fpm \
php-mysql \
mariadb-client

RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www
RUN tar -xvf /var/www/wordpress-6.0-fr_FR.tar.gz
RUN cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz
# RUN chown -R root:root /var/www/wordpress
RUN chown -R www-data:www-data /var/www/wordpress

COPY /conf/php.ini /etc/php/7.3/cli/php.ini

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY /conf/auto_config.sh ./
RUN chmod +x ./auto_config.sh
ENTRYPOINT ["bash", "auto_config.sh"]
