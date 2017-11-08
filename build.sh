#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

PROJECT=$1
ARCH=$(uname -m)

cd ${DIR}/${PROJECT}
if [ -f deps.sh ]; then
    echo "deps"
    ./deps.sh
fi

echo "building"
./build.sh ${ARCH}
