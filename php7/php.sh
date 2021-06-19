#!/bin/bash -xe
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
${DIR}/lib/*-linux*/ld-* --library-path ${DIR}/lib/*-linux*:${DIR}/usr/lib/*-linux* ${DIR}/usr/local/bin/php "$@"