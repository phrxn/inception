FROM alpine:3.21.3

#MariaDB variables
ARG DATABASE
ARG DATABASE_USER
ARG DATABASE_USER_PASSWORD
ARG DATABASE_HOST

#Wordpress variables
ARG WORDPRESS_TITLE
ARG WORDPRESS_ADMIN_USER
ARG WORDPRESS_ADMIN_PASSWORD
ARG WORDPRESS_ADMIN_EMAIL
ARG WORDPRESS_USER_USER
ARG WORDPRESS_USER_PASSWORD
ARG WORDPRESS_USER_EMAIL
ARG DOMAIN

RUN \
  apk update \
  && \
  apk add --no-cache \
    php \
    php-phar \
    php-fpm \
    php-mysqli \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-json \
    php-session \
    php-opcache \
    php-zip \
    php-tokenizer \
    mariadb-client \
  && \
  sed -i 's/^memory_limit = .*/memory_limit = 512M/' /etc/php83/php.ini \
  && \
  wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && \
  chmod +x wp-cli.phar \
  && \
  mv wp-cli.phar /usr/local/bin/wp \
  && \
  mkdir -p /var/www/wordpress \
  && \
  cd /var/www/wordpress \
  && \
  chown -R nobody:nobody /var/www/wordpress \
  && \
  wp core download --allow-root --path=/var/www/wordpress

COPY ./conf/wp-fpm.conf /etc/php83/php-fpm.d/www.conf

COPY ./tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

CMD ["/usr/local/bin/setup.sh"]
