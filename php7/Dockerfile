FROM php:7.4-fpm
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
		libzip-dev \
		libsmbclient-dev \
		libxml2-dev \
		libsqlite3-dev \
		libpq-dev \
		libldap2-dev \
		libsasl2-dev \
		libfreetype6-dev \
		liblqr-1-0-dev \
		libfftw3-dev \
		libjbig-dev \
		libtiff5-dev \
		libwebp-dev \
		libmemcached-dev \
                libmcrypt-dev \
		zip \
		wget \
		unzip \
        libgmp-dev \
        libmagickwand-dev --no-install-recommends

RUN mkdir -p /usr/src/php/ext/memcached
WORKDIR /usr/src/php/ext/memcached
RUN wget https://github.com/php-memcached-dev/php-memcached/archive/v3.1.3.zip; unzip /usr/src/php/ext/memcached/v3.1.3.zip
RUN mv /usr/src/php/ext/memcached/php-memcached-3.1.3/* /usr/src/php/ext/memcached/

RUN docker-php-ext-configure memcached && docker-php-ext-install memcached \
    && pecl install imagick \
    && pecl install smbclient \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-install ldap \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install opcache \
    && docker-php-ext-install zip \
    && docker-php-ext-enable imagick \
    && docker-php-ext-enable smbclient \
    && docker-php-ext-install pdo pdo_pgsql \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j2 gd \
    && rm -rf /var/lib/apt/lists/*
