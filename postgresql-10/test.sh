#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}

${DIR}/build/postgresql-10/bin/pg_ctl.sh --help
${DIR}/build/postgresql-10/bin/pg_dumpall.sh --help
${DIR}/build/postgresql-10/bin/psql.sh --help
