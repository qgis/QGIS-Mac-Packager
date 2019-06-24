#!/bin/bash

set -e

# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

TAG=final-3_8_0
QGISAPP="QGIS3.8.app"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BD=$DIR/../../builds/pr

echo "BUILDING PR"
$DIR/run_build.bash \
  $BD \
  $TAG \
  pr \
  ${QGISAPP} "$@"
