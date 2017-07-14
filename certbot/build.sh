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

apt-get -y install git

rm -rf build
mkdir build
cd build

git clone https://github.com/certbot/certbot/tree/v${VERSION} certbot
cd certbot
export VENV_PATH=${DIR}/build/certbot/venv
./certbot-auto

rm -rf ${NAME}-${ARCH}.tar.gz
tar cpzf ${NAME}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}