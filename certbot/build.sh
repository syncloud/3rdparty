#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

VERSION=0.16.0

export TMPDIR=/tmp
export TMP=/tmp

NAME=certbot

rm -rf build
mkdir -p build/certbot
cd build

wget https://github.com/certbot/certbot/archive/v${VERSION}.tar.gz
tar xf v${VERSION}.tar.gz
export VENV_PATH=${DIR}/build/certbot
cd certbot-${VERSION}
./certbot-auto --non-interactive --verbose

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}