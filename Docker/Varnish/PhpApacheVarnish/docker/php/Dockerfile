FROM php:8.2.13-fpm

RUN apt-get update && apt-get install -y \
    zlib1g-dev g++ git libicu-dev zip libzip-dev libcurl4-openssl-dev curl libxml2-dev acl libpng-dev \
    gnupg software-properties-common vim iputils-ping \
    && docker-php-ext-install intl opcache zip curl xml simplexml pdo_mysql \
    && docker-php-ext-configure zip \
    && docker-php-ext-configure gd \
    && docker-php-ext-install gd \
    && pecl install apcu xdebug \
    && docker-php-ext-enable apcu xdebug \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs build-essential \
    && npm install -g npm@10.2.5 \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && rm -rf /var/lib/apt/lists/*

RUN echo "date.timezone = Europe/Rome" > /usr/local/etc/php/conf.d/tzone.ini

RUN useradd -rm -d /home/workspace/ -s /bin/bash -g root -G sudo -u 1001 workspace
USER workspace

WORKDIR /var/www/html
