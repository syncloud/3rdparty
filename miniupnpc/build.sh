#!/bin/bash -x

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export TMPDIR=/tmp
export TMP=/tmp

echo "building miniupnpc"

apt-get -y install python
wget -O get-pip.py https://bootstrap.pypa.io/get-pip.py
python get-pip.py
rm get-pip.py
pip install wheel

apt-get install -y python-dev

rm -rf build
mkdir build

cd ${DIR}/build
mkdir miniupnp
wget -O miniupnp.tar.gz https://github.com/syncloud/miniupnp/archive/miniupnpc_1_9.tar.gz
tar zxvf miniupnp.tar.gz -C miniupnp --strip-components=1
rm miniupnp.tar.gz

mv miniupnp/miniupnpc miniupnpc
rm -r miniupnp

cd miniupnpc
make
python setup.py bdist_wheel

