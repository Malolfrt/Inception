FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt-get install mariadb-server -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/script.sh /etc/tools/script.sh
RUN chmod +x /etc/tools/script.sh
ENTRYPOINT [ "bash", "/etc/tools/script.sh"]