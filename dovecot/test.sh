#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
${DIR}/build/dovecot/bin/dovecot.sh --version
${DIR}/build/dovecot/bin/doveadm.sh 2>&1 | grep "doveadm(init)"
${DIR}/build/dovecot/libexec/dovecot/auth.sh 2>&1 | grep "auth(init)"

DOVECOT=${DIR}/build/dovecot
export LD_LIBRARY_PATH=${DOVECOT}/lib:${DOVECOT}/lib/dovecot:${DOVECOT}/lib/dovecot/old-stats
ldd ${DOVECOT}/libexec/dovecot/auth
${DOVECOT}/libexec/dovecot/auth 2>&1 | grep "auth(init)"
