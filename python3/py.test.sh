#!/bin/bash -e
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
${DIR}/python ${DIR}/../usr/local/bin/py.test "$@"
