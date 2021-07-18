#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

apt update
apt install -y ca-certificates file

file ./build/python/bin/python3

./build/python/bin/python --version

./build/python/bin/python -c 'import ssl; print(ssl.OPENSSL_VERSION)'
./build/python/bin/python -c 'import urllib.request; print(urllib.request.urlopen("https://google.com"))'

./build/python/bin/pip install pytest
./build/python/bin/pip install beautifulsoup4==4.3.2
./build/python/bin/py.test.sh --help
