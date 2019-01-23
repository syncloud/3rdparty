#!/bin/bash -e
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
${DIR}/bin/python ${DIR}/bin/py.test "$@"
