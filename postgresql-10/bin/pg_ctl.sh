#!/bin/bash -e
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
LIBS=$(echo ${DIR}/lib)
exec ${DIR}/lib/ld.so --library-path $LIBS ${DIR}/bin/pg_ctl "$@"