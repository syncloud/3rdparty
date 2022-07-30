#!/bin/bash -e
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
LIBS=${DIR}/lib
exec ${DIR}/lib/*-linux*/ld-*.so --library-path $LIBS ${DIR}/bin/mysqld "$@"