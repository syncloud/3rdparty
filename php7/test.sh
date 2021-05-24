#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

PHP=${DIR}/build/php
export LD_LIBRARY_PATH=${PHP}/lib:${PHP}/lib/private
ldd ${PHP}/sbin/php-fpm

${PHP}/lib/ld.so ${PHP}/bin/php -i

${PHP}/lib/ld.so ${PHP}/bin/php -i | grep SVG