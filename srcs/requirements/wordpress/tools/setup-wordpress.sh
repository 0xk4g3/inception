#!/bin/bash

set -e

echo "========================================"
echo "WordPress Setup Script Starting..."
echo "========================================"

echo "Waiting for MariaDB to be ready..."
while ! mariadb -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e "SELECT 1" >/dev/null 2>&1; do
    echo "MariaDB is unavailable - waiting..."
    sleep 3
done
echo "✓ MariaDB is ready!"

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    
    rm -rf *
    
    wp core download --allow-root
    
    echo "WordPress downloaded!"
    
    echo "Configuring WordPress..."
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306 \
        --allow-root
    
    echo "WordPress configured!"
    
    echo "Installing WordPress..."
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="Inception WordPress" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --skip-email \
        --allow-root
    
    echo "WordPress installed!"
    
    echo "Creating additional WordPress user..."
    wp user create \
        ${WP_USER} \
        ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${WP_USER_PASSWORD} \
        --allow-root
    
    echo "Additional user created!"
    
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    
    echo "Permissions set!"
else
    echo "WordPress is already installed!"
fi

echo "========================================"
echo "Starting PHP-FPM..."
echo "========================================"

exec php-fpm7.4 -F
