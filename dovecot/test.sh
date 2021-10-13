#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
${DIR}/build/dovecot/bin/dovecot.sh --help
${DIR}/build/dovecot/bin/doveadm.sh --help