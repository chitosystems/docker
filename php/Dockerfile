ARG PHP_VERSION
FROM php:${PHP_VERSION}

ARG ENVIRONMENT
ARG APP_DIRECTORY
ARG TZ

ENV TZ $TZ

RUN apt-get update && apt-get install -y --no-install-recommends \
    nano curl libcurl4-openssl-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev libxpm-dev \
    zlib1g-dev libzip-dev unzip acl libicu-dev git gnupg2 wget software-properties-common nodejs vim g++ \
    libldap2-dev libtidy-dev libxslt1-dev libgmp-dev bash openssh-client \
    && git config --global --add safe.directory ${APP_DIRECTORY} \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) bcmath mysqli pdo_mysql zip intl ldap soap tidy xsl exif gmp opcache \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install opcache

COPY ./php.ini /usr/local/etc/php/
COPY ./root/.ssh/id_rsa /root/.ssh/id_rsa
COPY ./root/.ssh/id_rsa.pub /root/.ssh/id_rsa.pub
COPY ./root/.bashrc /root/.bashrc
COPY ./sync_me.sh /usr/local/bin/sync_me.sh

RUN chmod 600 /root/.ssh/id_rsa /root/.ssh/id_rsa.pub \
    && chmod +x /usr/local/bin/sync_me.sh

ENV APP_DIRECTORY $APP_DIRECTORY
WORKDIR ${APP_DIRECTORY}

COPY . ${APP_DIRECTORY}

RUN chown -R www-data:www-data ${APP_DIRECTORY} \
    && chmod -R 755 ${APP_DIRECTORY} \
    && find ${APP_DIRECTORY} -type f -exec chmod 0664 {} \;

EXPOSE 9000

CMD ["php-fpm"]
