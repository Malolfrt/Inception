#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

chown -R mysql:mysql /var/lib/mysql

echo "Starting MariaDB..."
mysqld --datadir=/var/lib/mysql &

sleep 10

DB_EXISTS=$(mysql -u -root -e "SHOW DATABASES LIKE '${SQL_DATABASE}';" | grep ${SQL_DATABASE} || true)

if [ -z "$DB_EXISTS" ]; then
    echo "Database does not exist. Configuring MariaDB..."
    mysql -u root <<EOF
    CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};
    USE ${SQL_DATABASE};
    CREATE USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${ADMIN_USER}'@'wordpress.inception' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    FLUSH PRIVILEGES;
EOF
    touch /var/lib/mysql/.mysql_initialized
else
    echo "Database already exists. Skipping initilization."
fi

mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
exec mysqld --datadir=/var/lib/mysql