#!/usr/bin/env bash

CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export SOURCE_PACKAGES_PATH=${CUR_DIR}/../build/.packages
./distribute.sh dev -mqgis_deps