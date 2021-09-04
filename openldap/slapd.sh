#!/bin/bash -e
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
LIBS=$(echo ${DIR}/lib/*-linux-gnu*)
LIBS=$LIBS:$(echo ${DIR}/usr/lib/*-linux-gnu*)
LIBS=$LIBS:$(echo ${DIR}/usr/lib)
MODULES_RID=$DIR/usr/lib/ldap
PRELOAD=$MODULES_RID/back_mdb.so:$MODULES_RID/ppolicy.so
${DIR}/lib/*-linux*/ld-*.so --library-path $LIBS ${DIR}/usr/sbin/slapd "$@"
