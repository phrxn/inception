#!/bin/sh

mariadb-install-db --user=mysql --datadir=/var/lib/mysql
mariadbd-safe &

until mariadb -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 1
done

mariadb -e "DROP USER IF EXISTS ''@"$(hostname)
mariadb -e "DROP USER IF EXISTS ''@'localhost'"
mariadb -e "CREATE DATABASE IF NOT EXISTS $DATABASE; GRANT ALL ON $DATABASE.* TO '$DATABASE_USER'@'%' IDENTIFIED BY '$DATABASE_USER_PASSWORD';"
mariadb -e "ALTER USER '$DATABASE_ROOT'@'localhost' IDENTIFIED BY '$DATABASE_ROOT_PASSWORD'; FLUSH PRIVILEGES;"
