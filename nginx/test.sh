#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

${DIR}/build/nginx/sbin/nginx -versionon

${DIR}/build/python/bin/python -c 'import ssl; print(ssl.OPENSSL_VERSION)'
${DIR}/build/python/bin/python -c 'import urllib.request; print(urllib.request.urlopen("https://google.com"))'

${DIR}/build/python/bin/pip install pytest
${DIR}/build/python/bin/pip install beautifulsoup4==4.3.2
${DIR}/build/python/bin/py.test.sh --help
ython/bin/pip install beautifulsoup4==4.3.2
${DIR}/build/python/bin/py.test.sh --help
