# Usar una imagen base de PHP con Apache
FROM php:8.0-apache

# Instalación de dependencias necesarias
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    git \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install intl

# Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Descargar Moodle y descomprimirlo
RUN curl -L https://download.moodle.org/download.php/direct/stable39/moodle-3.9.tgz | tar -xz -C /var/www/html/

# Establecer permisos adecuados para el directorio Moodle
RUN chown -R www-data:www-data /var/www/html/moodle
RUN chmod -R 755 /var/www/html/moodle

# Exponer el puerto 80 para acceso web
EXPOSE 80

# Configuración para Apache (asegúrate de cambiar los valores según tu entorno)
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Iniciar Apache en el contenedor
CMD ["apache2-foreground"]
