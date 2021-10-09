#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export LD_LIBRARY_PATH=/snap/mail/current/dovecot/lib
ldd /snap/mail/current/dovecot/sbin/dovecot
