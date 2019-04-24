#!/bin/bash

set -e

# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

TAG=master
QGISAPP="QGISDEV.app"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BD=$DIR/../../builds/staging

echo "BUILDING STAGING"
$DIR/run_build.bash \
  $BD \
  $TAG \
  staging \
  $QGISAPP "$@"
