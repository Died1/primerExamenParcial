# Usar una imagen base oficial de PHP con soporte para extensiones necesarias
FROM php:8.1-fpm

# Instalar dependencias del sistema y extensiones de PHP necesarias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip pdo pdo_pgsql \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Establecer el directorio de trabajo
WORKDIR /var/www

# Copiar los archivos del proyecto
COPY . .

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar dependencias de Composer
RUN composer install

# Establecer el puerto en el que la aplicación escuchará
EXPOSE 9000

# Comando para iniciar PHP-FPM
CMD ["php-fpm"]
