#!/bin/sh

cd /var/www/wordpress/

export HTTP_HOST=$DOMAIN

# Wait for the database to become available
until mariadb-admin ping -h"$DATABASE_HOST" --silent --skip-ssl --connect-timeout=3; do
    sleep 2
done

# Automatically generate wp-config.php if it doesn't exist
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    wp config create \
        --path=/var/www/wordpress \
        --dbname="$DATABASE" \
        --dbuser="$DATABASE_USER" \
        --dbpass="$DATABASE_USER_PASSWORD" \
        --dbhost="$DATABASE_HOST" \
        --allow-root

    # Install WordPress if it is not already installed
    if ! wp core is-installed --allow-root; then
        wp core install \
	        --path=/var/www/wordpress \
            --url=https://"$DOMAIN" \
            --title="$WORDPRESS_TITLE" \
            --admin_user="$WORDPRESS_ADMIN_USER" \
            --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
            --admin_email="$WORDPRESS_ADMIN_EMAIL" \
            --allow-root
        wp theme activate twentytwentyfive --allow-root
        wp user create $WORDPRESS_USER_USER $WORDPRESS_USER_EMAIL --user_pass=$WORDPRESS_USER_PASSWORD --allow-root
    fi
fi

# start the PHP-FPM
php-fpm83 --nodaemonize
