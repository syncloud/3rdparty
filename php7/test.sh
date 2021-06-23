#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

find $DIR/build/php -name "*.so"

echo "extension_dir=\"$DIR/build/php/lib/php/extensions\"" > php.ini

./build/php/bin/php.sh -c php.ini -i
./build/php/bin/php.sh -c php.ini -m
./build/php/bin/php.sh -c php.ini -i | grep -i svg
./build/php/bin/php.sh -c php.ini -m | grep -i smbclient
./build/php/bin/php.sh -c php.ini -m | grep -i intl
./build/php/bin/php.sh -c php.ini -m | grep -i gmp
./build/php/bin/php.sh -c php.ini -m | grep -i imagick
./build/php/bin/php.sh -c php.ini -m | grep -i gd
./build/php/bin/php.sh -c php.ini -m | grep -i pdo_mysql
./build/php/bin/php.sh -c php.ini -m | grep -i pdo_pgsql
./build/php/bin/php.sh -c php.ini -m | grep -i ldap
./build/php/bin/php.sh -c php.ini -m | grep -i zip
./build/php/bin/php.sh -c php.ini -m | grep -i memcached
./build/php/bin/php.sh -c php.ini -m | grep -i apcu
./build/php/bin/php.sh -c php.ini -m | grep -i mcrypt
./build/php/bin/php.sh -c php.ini -m | grep -i opcache
./build/php/bin/php.sh -c php.ini -r "echo gethostbyname('apps.nextcloud.com');"
./build/php/bin/php.sh -c php.ini -r "echo gethostbyname('apps.nextcloud.com');" | grep -v apps.nextcloud.com

./build/php/bin/php-fpm.sh -c php.ini -i
./build/php/bin/php-fpm.sh -c php.ini -i | grep -i svg
