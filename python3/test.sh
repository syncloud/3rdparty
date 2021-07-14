#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

apt update
apt install -y ca-certificates

./build/python/bin/python --version

./build/python/bin/python -c 'import urllib.request; print(urllib.request.urlopen("https://google.com"))'
./build/python/bin/python -c 'import ssl; print(ssl.OPENSSL_VERSION)'

./build/python/bin/pip install pytest
./build/python/bin/py.test.sh --help
