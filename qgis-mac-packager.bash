#!/bin/bash

set -eo pipefail

PWD=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if (( $# < 5 )); then
    echo "usage: $0 package_name config_file major minor patch"
    echo "example: ./$0 /path/to/qgis_nightly_master_20200717_024956.dmg config/nightly.conf 3 18 0"
    exit 1
fi

PACKAGE=$1
CONFIG_FILE=$2
export QGIS_MAJOR_VERSION=$3
export QGIS_MINOR_VERSION=$4
export QGIS_PATCH_VERSION=$5

echo "qgis-mac-packager.bash QGIS $QGIS_MAJOR_VERSION.$QGIS_MINOR_VERSION.$QGIS_PATCH_VERSION"

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
  error "missing QT in $QT_BASE, install version ${VERSION_QT} from ${QGIS_DOWNLOAD_ROOT_URL}/deps/"
fi

echo "Verifying the qgis-deps package installation"
if [ ! -d "$QGIS_DEPS_STAGE_PATH" ]; then
  error "missing QGIS-DEPS in $QGIS_DEPS_STAGE_PATH, install version ${QGIS_DEPS_SDK_VERSION} from ${QGIS_DOWNLOAD_ROOT_URL}/deps/"
fi

echo "Building QGIS"
$DIR/qgis_build/qgis_build.bash "$CONFIG_FILE" $QGIS_MAJOR_VERSION $QGIS_MINOR_VERSION $QGIS_PATCH_VERSION

echo "Bundle QGIS"
$DIR/qgis_bundle/qgis_bundle.bash "$CONFIG_FILE" $QGIS_MAJOR_VERSION $QGIS_MINOR_VERSION $QGIS_PATCH_VERSION

echo "Package QGIS to $PACKAGE"
$DIR/qgis_package/qgis_package.bash "$CONFIG_FILE" $QGIS_MAJOR_VERSION $QGIS_MINOR_VERSION $QGIS_PATCH_VERSION "$PACKAGE"

echo "All done (qgis-mac-packager.bash)"
cd "$PWD"

exit 0