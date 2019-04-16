#!/bin/bash

set -o pipefail

# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

TAG=master
QGISAPP="QGIS3.7.app"

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BD=$DIR/../../builds/nightly
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG=$BD/nightly_${TIMESTAMP}.log

echo "BUILDING NIGHTLY"
mkdir -p $BD

$DIR/run_build.bash \
  $BD \
  $TAG \
  nightly \
  ${QGISAPP} \
2>&1 | tee $LOG

exit_status=$?
if [ $exit_status -eq 0 ]; then
    echo "SUCCESS" | tee -a $LOG
else
    echo "FAIL" | tee -a $LOG
fi
exit $exit_status