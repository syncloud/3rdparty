#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export LD_LIBRARY_PATH=${DIR}/build/opendkim/lib
ldd ${DIR}/build/opendkim/sbin/opendkim

${DIR}/build/opendkim/sbin/opendkim --help || true
${DIR}/build/opendkim/bin/opendkim-genkey --help || true
