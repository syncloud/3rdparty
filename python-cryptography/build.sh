#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

OPENSSL_VERSION=1.0.2h

rm -rf openssl-${OPENSSL_VERSION}
curl -O https://openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
tar xvf openssl-${OPENSSL_VERSION}.tar.gz
cd openssl-${OPENSSL_VERSION}

./config -Wl,--version-script=openssl.ld -Wl,-Bsymbolic-functions -fPIC shared

./config no-shared no-ssl2 -fPIC --prefix=${DIR}/openssl
make && make install
cd ..

CFLAGS="-I${DIR}/openssl/include" LDFLAGS="-L${DIR}/openssl/lib" pip wheel --no-use-wheel cryptography

cp ${DIR}/dist/*.whl ${DIR}/
