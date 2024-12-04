FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install wget -y
RUN apt-get install curl -y
RUN apt-get install -y php7.4
RUN apt-get install -y php-fpm
RUN apt-get install -y php-mysql

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN apt-get update && apt-get install -y default-mysql-client
RUN apt-get install -y mariadb-client
RUN wget https://wordpress.org/wordpress-6.6.tar.gz -P /var/www/html
RUN cd /var/www/html \
    && tar -xzf /var/www/html/wordpress-6.6.tar.gz \
    && rm /var/www/html/wordpress-6.6.tar.gz

COPY ./tools/wp-config.php /var/www/html

RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

EXPOSE 9000

COPY /tools/auto_config.sh ./
RUN chmod +x ./auto_config.sh

COPY ./tools/www.conf /etc/php/7.4/fpm/pool.d/www.conf

ENTRYPOINT ["bash", "./auto_config.sh"]

