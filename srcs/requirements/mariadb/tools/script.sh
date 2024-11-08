#!/bin/bash

mkdir -p /run/mysqld

chown mysql:mysql /run/mysqld

echo "démarrage de MariaDB..."
mysqld --user=mysql --socket=/run/mysqld/mysqld.sock &

until mysqladmin ping --host=localhost --silent; do
  echo "Attente du démarrage de MariaDB..."
  sleep 1
done

echo "MariaDB est prêt, exécution des commandes SQL..."

mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown
exec mysqld_safe

wait &