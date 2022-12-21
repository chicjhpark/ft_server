FROM	debian:buster

RUN	apt-get update && \
	apt-get -y install \
	wget \
	nginx \
	openssl \
	mariadb-server\
	php-mysql \
	php7.3-fpm
RUN	wget https://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz -C /var/www/html && \
	chown -R www-data:www-data /var/www/html/wordpress && \
	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz && \
	tar -xzvf phpMyAdmin-5.0.2-all-languages.tar.gz -C /var/www/html/ && \
	mv /var/www/html/phpMyAdmin-5.0.2-all-languages /var/www/html/phpmyadmin
RUN	service mysql start && \
	echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password && \
	echo "CREATE USER 'jaehpark'@'localhost' IDENTIFIED BY 'jaehpark';" | mysql -u root --skip-password && \
	echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'jaehpark'@'localhost';" | mysql -u root --skip-password

COPY	./srcs/default ./etc/nginx/sites-available/
COPY	./srcs/wp-config.php ./var/www/html/wordpress/
COPY	./srcs/config.inc.php ./var/www/html/phpmyadmin/
COPY	./srcs/localhost.crt ./etc/ssl/certs/
COPY	./srcs/localhost.key ./etc/ssl/private/

EXPOSE 80 443

CMD	service nginx start && service mysql start && service php7.3-fpm start && bash
