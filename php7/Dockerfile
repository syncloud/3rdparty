FROM php:7.4-cli
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
        libgmp-dev \
        libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j2 gd \
    && rm -rf /var/lib/apt/lists/*