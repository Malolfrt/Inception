#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

echo "Starting MariaDB..."
mysqld --datadir=/var/lib/mysql --skip-networking &
sleep 5

if [ ! -f /var/lib/mysql/.mysql_initialized ]; then
    echo "Configuring MariaDB..."
    mysql -u root <<EOF
    CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};
    CREATE USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOF
    touch /var/lib/mysql/.mysql_initialized
fi

exec mysqld --datadir=/var/lib/mysql