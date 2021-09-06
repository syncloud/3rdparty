#!/bin/bash -xe
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
LIBS=$(echo ${DIR}/lib/*-linux-gnu*)
LIBS=$LIBS:$(echo ${DIR}/usr/lib/*-linux-gnu*)
LIBS=$LIBS:$(echo ${DIR}/usr/lib)
MODULES_DIR=$DIR/usr/lib/ldap
PRELOAD=$MODULES_DIR/$(readlink $MODULES_DIR/back_mdb.so):$MODULES_DIR/$(readlink $MODULES_DIR/ppolicy.so)
${DIR}/lib/*-linux*/ld-*.so --library-path $LIBS --preload $PRELOAD ${DIR}/usr/sbin/slapd "$@"
