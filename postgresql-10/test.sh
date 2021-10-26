#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

PREFIX=${DIR}/build/postgresql
export LD_LIBRARY_PATH=${PREFIX}/lib
ldd ${PREFIX}/bin/psql.bin
