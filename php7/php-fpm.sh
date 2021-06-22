#!/bin/bash -e
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
LIBS=$(echo ${DIR}/lib/*-linux-gnu*)
LIBS=$LIBS:$(echo ${DIR}/usr/lib/*-linux-gnu*)
LIBS=$LIBS:$(echo ${DIR}/usr/lib)
LIBS=$LIBS:$(echo ${DIR}/usr/lib/*-linux-gnu*/samba)
MAGICK_CODER_MODULE_PATH=${DIR}/usr/lib/ImageMagick-6.9.10/modules-Q16/coders MAGICK_HOME=${DIR}/usr MAGICK_CONFIGURE_PATH=${DIR}/etc/ImageMagic-6 PHP_INI_SCAN_DIR=${DIR}/usr/local/etc/php/conf.d ${DIR}/lib/*-linux*/ld-*.so --library-path $LIBS ${DIR}/usr/local/sbin/php-fpm "$@"
