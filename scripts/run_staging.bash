#!/bin/bash

set -o pipefail

# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

TAG=master
QGISAPP="QGISDEV.app"

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BD=$DIR/../../builds/staging
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG=$BD/staging_${TIMESTAMP}.log

echo "BUILDING STAGING"
mkdir -p $BD

$DIR/run_build.bash \
  $BD \
  $TAG \
  staging \
  $QGISAPP \
2>&1 | tee $LOG

exit_status=$?
if [ $exit_status -eq 0 ]; then
    echo "SUCCESS" | tee -a $LOG
else
    echo "FAIL" | tee -a $LOG
fi
exit $exit_status