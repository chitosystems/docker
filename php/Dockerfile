# Use the PHP_VERSION argument from the build environment
ARG PHP_VERSION
ARG ENVIRONMENT
ARG REPOSITORY_BRANCH
ARG TZ

FROM php:${PHP_VERSION}-fpm
ARG ENVIRONMENT
ARG APP_DIRECTORY=/var/www/app

# Set environment variables
ENV TZ $TZ
ENV APP_DIRECTORY $APP_DIRECTORY
ENV ENVIRONMENT $ENVIRONMENT

COPY ./app-php.ini /usr/local/etc/php/conf.d/app-php.ini

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nano \
    curl \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    zlib1g-dev \
    libzip-dev \
    unzip \
    acl \
    libicu-dev \
    git \
    gnupg2 \
    wget \
    software-properties-common \
    nodejs \
    vim \
    g++ \
    libldap2-dev \
    libtidy-dev \
    libxslt1-dev \
    libgmp-dev \
    bash \
    openssh-client

# Add safe.directory configuration for Git
RUN git config --global --add safe.directory ${APP_DIRECTORY}

# Configure and Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) \
        bcmath \
        mysqli \
        pdo_mysql \
        zip \
        intl \
        ldap \
        soap \
        tidy \
        xsl \
        exif \
        gmp \
        opcache

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clear the apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy SSH keys
COPY ./root/.ssh/id_rsa /root/.ssh/id_rsa
COPY ./root/.ssh/id_rsa.pub /root/.ssh/id_rsa.pub
COPY ./root/.bashrc /root/.bashrc
COPY ./sync_me.sh /usr/local/bin/sync_me.sh

RUN chmod 600 /root/.ssh/id_rsa && chmod 600 /root/.ssh/id_rsa.pub

# Set working directory
ENV APP_DIRECTORY $APP_DIRECTORY
WORKDIR ${APP_DIRECTORY}

# Copy application files
COPY . ${APP_DIRECTORY}/

RUN chmod +x /usr/local/bin/sync_me.sh

# List the contents of the current directory to ensure files are copied
RUN ls -la ${APP_DIRECTORY}

# Set appropriate permissions
RUN chown -R www-data:www-data ${APP_DIRECTORY}
RUN chmod -R 755 ${APP_DIRECTORY}
RUN find ${APP_DIRECTORY} -type f -exec sudo chmod 0664 {} \;

# Expose port 9000
EXPOSE 9000

# Start php-fpm server
CMD ["php-fpm"]
