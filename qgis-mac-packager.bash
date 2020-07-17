#!/bin/bash

set -eo pipefail

PWD=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if (( $# < 2 )); then
    echo "usage: $0 package_name config_file"
    echo "example: ./$0 /path/to/qgis_nightly2_master_20200717_024956.dmg config/nightly2.conf"
    exit 1
fi

PACKAGE=$1
CONFIG_FILE=$2

echo "Checking config file $CONFIG_FILE"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "invalid config file (1st argument) $CONFIG_FILE"
fi
shift
source $CONFIG_FILE

echo "Verifying the QGIS repo is cloned locally in $QGIS_SOURCE_DIR"
if [ ! -f "$QGIS_SOURCE_DIR/INSTALL.md" ]; then
  error "missing $QGIS_SOURCE_DIR/INSTALL.md"
fi

echo "Verifying the Qt package installation"
if [ ! -d "$QT_BASE" ]; then
  error "missing QT in $QT_BASE, install version ${VERSION_qt} from ${QGIS_DOWNLOAD_ROOT_URL}/deps/"
fi

echo "Verifying the qgis-deps package installation"
if [ ! -d "$QGIS_DEPS_STAGE_PATH" ]; then
  error "missing QGIS-DEPS in $QGIS_DEPS_STAGE_PATH, install version ${QGIS_DEPS_SDK_VERSION} from ${QGIS_DOWNLOAD_ROOT_URL}/deps/"
fi

echo "Building QGIS"
$DIR/qgis_build/qgis_build.bash "$CONFIG_FILE"

echo "Bundle QGIS"
$DIR/qgis_bundle/qgis_bundle.bash "$CONFIG_FILE"

echo "Package QGIS to $PACKAGE"
$DIR/qgis_package/qgis_package.bash "$CONFIG_FILE" "$PACKAGE"

echo "All done (qgis-mac-packager.bash)"
cd "$PWD"

exit 0