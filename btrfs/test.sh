#!/bin/bash -xe

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

${DIR}/build/btrfs/bin/btrfs.sh --help || true
${DIR}/build/btrfs/bin/btrfs.sh version
