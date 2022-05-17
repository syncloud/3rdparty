#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

NAME=bind9
BUILD=${DIR}/build
PREFIX=${BUILD}/${NAME}

${PREFIX}/bin/dig.sh -v
