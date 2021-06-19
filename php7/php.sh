#!/bin/bash -xe
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
${DIR}/lib/ld-* --library-path ${DIR}/lib:${DIR}/usr/lib ${DIR}/usr/local/bin/php "$@"