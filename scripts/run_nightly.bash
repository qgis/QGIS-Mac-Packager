#!/bin/bash

set -e

# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

TAG=master
QGISAPP="QGIS3.9.app"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BD=$DIR/../../builds/nightly

echo "BUILDING NIGHTLY"
$DIR/run_build.bash \
  $BD \
  $TAG \
  nightly \
  ${QGISAPP} "$@"
