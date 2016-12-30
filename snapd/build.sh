#!/bin/bash -ex

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [[ -z "$1" ]]; then
    echo "usage $0 version"
    exit 1
fi

VERSION=$1
TESTS=$2

cd ${DIR}

export GOPATH=${DIR}
export PATH=${PATH}:${GOPATH}/bin
NAME=snapd
BUILD_DIR=${DIR}/build/${NAME}
ARCH=$(dpkg-architecture -q DEB_HOST_ARCH)

go get -d -v github.com/snapcore/snapd/...
cd src/github.com/snapcore/snapd

echo "snapd (${VERSION}) xenial; urgency=medium" > debian/changelog
echo "" >> debian/changelog
echo "  * New upstream release, LP: #1644625" >> debian/changelog
echo " -- team city <support@syncloud.it>  $(date -R)" >> debian/changelog
echo "" >> debian/changelog
./mkversion.sh

go get -u github.com/kardianos/govendor
govendor sync
if [[ ${TESTS} != "skip-tests" ]]; then
    ./run-checks
fi

cd ${DIR}
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}

mkdir ${BUILD_DIR}/bin
go build -o ${BUILD_DIR}/bin/snapd github.com/snapcore/snapd/cmd/snapd
go build -o ${BUILD_DIR}/bin/snap github.com/snapcore/snapd/cmd/snap
go build -o ${BUILD_DIR}/bin/snap-exec github.com/snapcore/snapd/cmd/snap-exec
go build -o ${BUILD_DIR}/bin/snapctl github.com/snapcore/snapd/cmd/snapctl

cd  ${DIR}/src/github.com/snapcore/snapd/cmd
autoreconf -i -f
./configure --disable-apparmor
make
cp snap-confine/snap-confine ${BUILD_DIR}/bin/snap-confine
cp snap-confine/snap-discard-ns ${BUILD_DIR}/bin/snap-discard-ns

cp /usr/bin/mksquashfs ${BUILD_DIR}/bin
cp /usr/bin/unsquashfs ${BUILD_DIR}/bin

mkdir ${BUILD_DIR}/conf
cp ${DIR}/src/github.com/snapcore/snapd/debian/snapd.service ${BUILD_DIR}/conf/
cp ${DIR}/src/github.com/snapcore/snapd/debian/snapd.socket ${BUILD_DIR}/conf/

mkdir ${BUILD_DIR}/scripts
cp ${DIR}/src/github.com/snapcore/snapd/tests/lib/prepare.sh ${BUILD_DIR}/scripts/
cp ${DIR}/src/github.com/snapcore/snapd/tests/lib/apt.sh ${BUILD_DIR}/scripts/

cd ${DIR}

rm -rf ${NAME}-${VERSION}-${ARCH}.tar.gz
tar cpzf ${NAME}-${VERSION}-${ARCH}.tar.gz -C ${DIR}/build ${NAME}
