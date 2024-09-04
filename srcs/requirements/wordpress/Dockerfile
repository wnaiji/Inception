FROM	debian:bullseye

RUN	apt update -y && apt upgrade -y && apt install wget -y

#install php
RUN	apt install -y php php-fpm php-mysql

#install wordpress
RUN	wget https://fr.wordpress.org/wordpress-6.6-fr_FR.tar.gz -P /var/www
RUN	cd /var/www && tar -xzf wordpress-6.6-fr_FR.tar.gz && rm wordpress-6.6-fr_FR.tar.gz

#Config php
COPY	/conf/wordpress.conf /etc/php/7.4/fpm/pool.d/
RUN	chmod 644 /etc/php/7.4/fpm/pool.d/wordpress.conf

#installi WP-CLI
RUN	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN	chmod +x wp-cli.phar
RUN	mv wp-cli.phar /usr/local/bin/wp

COPY	/conf/init_wordpress.sh /
RUN	chmod +x init_wordpress.sh

RUN	chown -R www-data:www-data /var/www/wordpress
RUN	chmod -R 755 /var/www/wordpress

RUN	mkdir -p /run/php
RUN	chown www-data:www-data /run/php
RUN	chmod 755 /run/php

RUN	service php7.4-fpm restart

EXPOSE	9000

STOPSIGNAL	SIGQUIT

ENTRYPOINT	["/init_wordpress.sh"]
