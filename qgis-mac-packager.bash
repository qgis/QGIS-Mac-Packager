#!/bin/bash

set -o pipefail

PWD=`pwd`
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if (( $# < 5 )); then
    echo "usage: $0 build_dir git_tag release_name package_name config_file"
    exit 1
fi

BUILD_DIR=$1
GIT=$2
RELEASE=$3
PACKAGE=$4
CONFIG_FILE=$5

echo "Checking config file $CONFIG_FILE"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "invalid config file (1st argument) $CONFIG_FILE"
fi
shift
source $CONFIG_FILE

if [[ "$BUILD_DIR/build" != $QGIS_BUILD_DIR ]]; then
  echo "error $BUILD_DIR/build is not equal $QGIS_BUILD_DIR from $CONFIG_FILE"
  exit 1
fi

if [[ "$BUILD_DIR/install" != $QGIS_INSTALL_DIR ]]; then
  echo "error $BUILD_DIR/install is not equal $QGIS_INSTALL_DIR from $CONFIG_FILE"
  exit 1
fi

if [[ "$BUILD_DIR/QGIS" != $QGIS_SOURCE_DIR ]]; then
  echo "error $BUILD_DIR/QGIS is not equal $QGIS_SOURCE_DIR from $CONFIG_FILE"
  exit 1
fi

echo "Verifying the QGIS repo is cloned locally in $QGIS_SOURCE_DIR"
if [ ! -f "$QGIS_SOURCE_DIR/INSTALL.md" ]; then
  echo "missing $QGIS_SOURCE_DIR/INSTALL.md"
  exit 1
fi


echo "Verifying the Qt package installation"
if [ ! -d "$QT_BASE" ]; then
  echo "missing QT in $QT_BASE, install version ${VERSION_qt} from ${QGIS_DOWNLOAD_ROOT_URL}/deps/"
  exit 1
fi

echo "Verifying the qgis-deps package installation"
if [ ! -d "$QGIS_DEPS_STAGE_PATH" ]; then
  echo "missing QT in $QGIS_DEPS_STAGE_PATH, install version ${QGIS_DEPS_SDK_VERSION} from ${QGIS_DOWNLOAD_ROOT_URL}/deps/"
  exit 1
fi

echo "Building QGIS"
$DIR/qgis_build/qgis_build.bash $CONFIG_FILE

echo "Bundle QGIS"
$DIR/qgis_bundle/qgis_bundle.bash $CONFIG_FILE

echo "Package QGIS"
$DIR/qgis_package/qgis_package.bash $CONFIG_FILE $PACKAGE

echo "All done (qgis-mac-packager.bash)"
cd $PWD

exit 0