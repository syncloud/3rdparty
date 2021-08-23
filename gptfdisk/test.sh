#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

export LD_LIBRARY_PATH=${DIR}/build/gptfdisk/lib
#ldd ${DIR}/build/gptfdisk/bin/gdisk
${DIR}/build/gptfdisk/bin/gdisk --help
