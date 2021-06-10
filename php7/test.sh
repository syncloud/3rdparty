#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

PHP=${DIR}/build/php

find ${DIR}/build/php -name "libunwind.so.8"
find ${DIR}/build/php -name "libc*"
${PHP}/lib/ld.so --library-path ${PHP}/lib:${PHP}/lib/private ${PHP}/bin/php -i

${PHP}/lib/ld.so --library-path ${PHP}/lib:${PHP}/lib/private ${PHP}/bin/php -i | grep SVG
${PHP}/lib/ld.so --library-path ${PHP}/lib:${PHP}/lib/private ${PHP}/bin/php -r "echo gethostbyname('apps.nextcloud.com');"
${PHP}/lib/ld.so --library-path ${PHP}/lib:${PHP}/lib/private ${PHP}/bin/php -r "echo gethostbyname('apps.nextcloud.com');" | grep -v apps.nextcloud.com
