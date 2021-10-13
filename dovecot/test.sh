#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
${DIR}/build/dovecot/bin/dovecot.sh --version
${DIR}/build/dovecot/bin/doveadm.sh --version || true