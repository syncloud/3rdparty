#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}


if [[ -z "$1" ]]; then
    echo "usage $0 architecture"
    exit 1
fi

ARCH=$1

OPENSSL_VERSION=1.0.2h

apt-get install libffi-dev

coin --to=lib raw http://build.syncloud.org:8111/guestAuth/repository/download/thirdparty_openssl_${ARCH}/lastSuccessful/openssl-${ARCH}.tar.gz

CFLAGS="-I${DIR}/lib/openssl/include" LDFLAGS="-L${DIR}/lib/openssl/lib" pip wheel  --no-binary :all: cryptography
