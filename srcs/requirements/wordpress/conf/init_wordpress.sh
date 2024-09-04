#!/bin/bash

sleep 10;
# Chemin vers le repertoire WordPress
WP_PATH=/var/www/wordpress/

cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

export MYSQL_PASSWORD=$(cat /run/secrets/db_password)
export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export ADMIN_PASSWORD=$(grep 'ADMIN_PASSWORD' /run/secrets/credentials | cut -d '=' -f2)
export USER_2_PASSWORD=$(grep 'USER_2_PASSWORD' /run/secrets/credentials | cut -d '=' -f2)


if [ -n "$MYSQL_DATABASE" ]; then
	sed -i "s|define( 'DB_NAME', 'database_name_here' );|define( 'DB_NAME', '$MYSQL_DATABASE' );|" /var/www/wordpress/wp-config.php
	if [ -n "$MYSQL_USER" ]; then
		sed -i "s|define( 'DB_USER', 'username_here' );|define( 'DB_USER', '$MYSQL_USER' );|" /var/www/wordpress/wp-config.php
		if [ -n "$MYSQL_PASSWORD" ]; then
    		sed -i "s|define( 'DB_PASSWORD', 'password_here' );|define( 'DB_PASSWORD', '$MYSQL_PASSWORD' );|" /var/www/wordpress/wp-config.php
		sed -i "s|define( 'DB_HOST', 'localhost' );|define( 'DB_HOST', 'mariadb' );|" /var/www/wordpress/wp-config.php
		fi
	fi
fi
	# Creation compte Admi
	wp core install --path=$WP_PATH \
		--url="${DOMAIN_NAME}" \
		--title="${TITLE_NAME}" \
		--admin_user="${ADMIN_USER}" \
		--admin_password="${ADMIN_PASSWORD}" \
		--admin_email="lol@lol.com" \
		--allow-root

	# Creation 2em utilisateur
	wp user create "${USER_2}" "lol2@lol2.com" \
		--user_pass="${USER_2_PASSWORD}" \
		--role="${USER_2_ROLE:-author}" \
		--path=$WP_PATH \
		--allow-root

#Lancement de PHP-FPM
/usr/sbin/php-fpm7.4 -F
