FROM "php:8.2.19-apache"

LABEL author="Eka Satria Ariaputra"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    libzip-dev \
    libicu-dev \
    libxml2-dev \
    libonig-dev \
    libxslt1-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    unzip \
    git \
    nano \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql zip intl mbstring xml xsl opcache curl

# install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Mengaktifkan modul Apache yang sering digunakan
RUN a2enmod rewrite headers

# Menyalin file konfigurasi dan skrip yang dibutuhkan
# COPY ./docker-compose/php/my-php.ini /usr/local/etc/php/php.ini
# COPY ./docker-compose/apache/my-apache.conf /etc/apache2/sites-available/000-default.conf

# Setel direktori kerja di dalam container
WORKDIR /var/www/html

# Menyalin kode aplikasi yang ada di up folder ke dalam container
# COPY ../ /var/www/html

# RUN composer install

# ubah hak akses agar bisa di edit dari komputer local
RUN chown -R www-data:www-data /var/www
RUN chmod -R 777 /var/www

# Ekspose port yang digunakan oleh Apache
EXPOSE 80

# Jalankan Apache di foreground
CMD ["apache2-foreground"]
