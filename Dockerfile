FROM php:8-fpm

# Установка расширений mysqli, pdo_mysql и других необходимых зависимостей
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Установка расширений GD и FreeType Library
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Изменение настроек php.ini для отображения ошибок
RUN echo "display_errors = On" >> /usr/local/etc/php/php.ini \
    && echo "error_reporting = E_ALL" >> /usr/local/etc/php/php.ini

WORKDIR /var/www/html
