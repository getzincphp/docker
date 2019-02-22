FROM php:7.2-apache
ENV APACHE_DOCUMENT_ROOT=/var/www/html/zincphp/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update \
  && docker-php-ext-install mysqli pdo pdo_mysql mbstring \
  && apt-get install zip unzip git -y

RUN a2enmod rewrite && service apache2 restart

# Installing composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --filename=composer --install-dir=/bin
RUN php -r "unlink('composer-setup.php');"

ENV COMPOSER_ALLOW_SUPERUSER=1