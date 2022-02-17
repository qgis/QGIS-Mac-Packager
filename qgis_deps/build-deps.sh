#!/usr/bin/env bash

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export DEPS_BUILD_PATH=${CUR_DIR}/build
./distribute.sh dev -mqgis_deps