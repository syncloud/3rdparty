#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
${DIR}/build/dovecot/bin/dovecot.sh --version
${DIR}/build/dovecot/bin/doveadm.sh --version || true
${DIR}/build/dovecot/libexec/dovecot/auth.sh || true

DOVECOT=${DIR}/build/dovecot
export LD_LIBRARY_PATH=${DOVECOT}/lib:${DOVECOT}/lib/dovecot:${DIR}/lib/dovecot/stats
ldd ${DOVECOT}/libexec/dovecot/auth
${DOVECOT}/libexec/dovecot/auth || true
