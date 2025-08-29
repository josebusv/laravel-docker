
FROM php:8.0.30-fpm
RUN mkdir -p /etc/supervisor/conf.d

WORKDIR /var/www/html

# Instalar dependencias del sistema y extensiones PHP
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    libpq-dev \
    postgresql-client \
    nano \
    libssl-dev \
    supervisor \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql pgsql \
    && docker-php-ext-install mbstring exif pcntl bcmath gd zip \
    # Instalar la extensión redis a través de PECL
    && pecl install redis-5.3.7 || true \
    && docker-php-ext-enable redis

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalar Node.js y npm (para desarrollo frontend si es necesario)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Configurar usuario www y permisos
RUN usermod -u 1000 www-data


# Copiar configuración de Supervisor
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisor/conf.d /etc/supervisor/conf.d

# Exponer el puerto de PHP-FPM
EXPOSE 9000

# Comando de inicio: Supervisor gestiona php-fpm y los queues
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]