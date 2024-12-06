FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y php
RUN apt-get install -y php-mysqli
RUN apt-get install -y php-json
RUN apt-get install -y php-fpm
RUN apt-get install -y wget
RUN rm -rf /var/lib/apt/lists/*

RUN wget "https://www.adminer.org/latest.php" -O /var/www/html/adminer.php

RUN chmod 755 /var/www/html/adminer.php

EXPOSE 8082

ENTRYPOINT ["php", "-S", "0.0.0.0:8082", "-t", "/var/www/html"]