FROM php:8.2.13-fpm

#Instalación de php extensiones principales de php
RUN apt-get update \
        && apt-get install -y zlib1g-dev g++ git libicu-dev zip libzip-dev zip libcurl4-openssl-dev curl libxml2-dev acl libpng-dev\
    && docker-php-ext-install intl opcache  \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-install curl \
    && docker-php-ext-install xml \
    && docker-php-ext-install simplexml \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-configure gd \
    && docker-php-ext-install gd

RUN ln -snf /usr/share/zoneinfo/Europe/Rome /etc/localtime && echo 'Europe/Rome' > /etc/timezone \
    && printf '[PHP]\ndate.timezone = "%s"\n', 'Europe/Rome' > /usr/local/etc/php/conf.d/tzone.ini


#Instalación de Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

#Instalación de VIM PING curl
RUN apt-get update && apt-get install -y vim iputils-ping curl


#Instalación de NODE
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash
RUN apt-get install -yq nodejs build-essential
RUN npm install -g npm@10.2.5
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


#Creación de usuario para no usar root
RUN useradd -rm -d /home/workspace/ -s /bin/bash -g root -G sudo -u 1001 workspace
USER workspace

WORKDIR /var/www/

