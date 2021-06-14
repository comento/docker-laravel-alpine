FROM alpine:3.13.5

RUN adduser -D -g 'www' www

RUN apk add --update --no-cache \
    curl \
    nginx \
    supervisor

RUN mkdir /www
RUN chown -R www:www /www

# NGINX
RUN chown -R www:www /var/lib/nginx
RUN mkdir -p /run/nginx

COPY ./.docker/nginx.conf /etc/nginx/nginx.conf
COPY ./.docker/default.conf /etc/nginx/conf.d/default.conf

# LARAVEL
COPY . /www
WORKDIR /www

# PHP
RUN apk add --no-cache \
    php8 \
    php8-ctype \
    php8-curl \
    php8-dom \
    php8-fpm \
    php8-gd \
    php8-intl \
    php8-json \
    php8-mbstring \
    php8-mysqli \
    php8-opcache \
    php8-openssl \
    php8-phar \
    php8-session \
    php8-xml \
    php8-xmlreader \
    php8-zlib \
    php8-fileinfo \
    php8-tokenizer

RUN ln -s /usr/bin/php8 /usr/bin/php

# PHP-FPM
RUN mkdir -p /run/php/
RUN touch /run/php/php8.0-fpm.pid
RUN touch /run/php/php8.0-fpm.sock

COPY ./.docker/php-fpm.conf /etc/php8/php-fpm.conf

# COMPOSER
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN composer install --prefer-dist --optimize-autoloader --no-dev

RUN chmod -R 777 /www/storage

COPY ./.docker/supervisord.conf /
CMD ["supervisord", "-n", "-c", "/supervisord.conf"]
