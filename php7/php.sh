#!/bin/bash -xe
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
LIBS=$(echo ${DIR}/lib/*-linux*)
LIBS=$LIBS:$(echo ${DIR}/usr/lib/*-linux*)
${DIR}/lib/*-linux*/ld-*.so --library-path $LIBS ${DIR}/usr/local/bin/php "$@"