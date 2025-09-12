FROM php:8.0.30-fpm
COPY supervisord.conf /etc/supervisor/supervisord.conf

WORKDIR /var/www/html

# Instalar dependencias del sistema y extensiones PHP
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install -y nano
RUN apt-get install -y procps grep
RUN apt-get install -y libssl-dev
RUN apt-get install -y supervisor -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
RUN apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libpq-dev
RUN apt-get install -y libonig-dev
RUN rm -rf /var/lib/apt/lists/*

COPY supervisor/conf.d/queues_horizon.conf /etc/supervisor/conf.d/queues_horizon.conf

RUN docker-php-ext-install pdo pdo_pgsql pgsql
RUN docker-php-ext-install mbstring exif pcntl bcmath
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd
RUN docker-php-ext-install zip
# Instalar la extensión redis a través de PECL
RUN pecl install redis-5.3.7 || true
RUN docker-php-ext-enable redis

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalar Node.js y npm (para desarrollo frontend si es necesario)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Configurar usuario www y permisos
RUN usermod -u 1000 www-data
RUN mkdir -p /var/www/html/queues_horizon/storage/logs




# Exponer el puerto de PHP-FPM
EXPOSE 9000

# Comando de inicio: Supervisor gestiona php-fpm y Horizon
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

