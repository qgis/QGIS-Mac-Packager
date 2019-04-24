#!/bin/bash

set -e

# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

TAG=final-3_4_7
QGISAPP="QGIS3.4.app"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BD=$DIR/../../builds/ltr

echo "BUILDING LTR"
$DIR/run_build.bash \
  $BD \
  ${TAG} \
  ltr \
  ${QGISAPP} "$@"
