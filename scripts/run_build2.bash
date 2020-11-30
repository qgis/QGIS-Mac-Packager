#!/bin/bash

set -eo pipefail

PWD=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if (( $# < 5 )); then
    echo "usage: $0 git_tag release_name major minor patch [no-upload]"
    echo "example: ./$0 master nightly 3 18 0 no-upload"
    exit 1
fi

GIT=$1
RELEASE=$2
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
QGIS_MAJOR_VERSION=$3
QGIS_MINOR_VERSION=$4
QGIS_PATCH_VERSION=$5

CONFIG_FILE=$DIR/../config/$RELEASE.conf
if [ ! -f "$CONFIG_FILE" ]; then
  echo "invalid config file (1st argument) $CONFIG_FILE"
fi
source $CONFIG_FILE

BUILD_DIR=$QGIS_BUILD_DIR/../
PACKAGE=$BUILD_DIR/qgis_${RELEASE}_${GIT}_${TIMESTAMP}.dmg
STATUS_PNG=$BUILD_DIR/qgis_${RELEASE}_${GIT}_${TIMESTAMP}.png
DEPS=$BUILD_DIR/qgis_${RELEASE}_${GIT}_${TIMESTAMP}.deps
LOG=$BUILD_DIR/qgis_${RELEASE}_${GIT}_${TIMESTAMP}.log

if (( $# == 6 )); then
    UPLOAD=1
else
    UPLOAD=0
fi

echo "Building & Packaging QGIS in $BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "Building QGIS $GIT for $RELEASE"

echo "Please update qgis-deps package manually to get new deps"
$DIR/deps.bash $CONFIG_FILE | tee $DEPS

cd $DIR/..
echo "Run qgis-mac-packager.bash"

res=0
if $DIR/../qgis-mac-packager.bash \
  $PACKAGE \
  $CONFIG_FILE \
  $QGIS_MAJOR_VERSION \
  $QGIS_MINOR_VERSION \
  $QGIS_PATCH_VERSION \
2>&1 | tee -a $LOG; then
    echo "SUCCESS" | tee -a $LOG
    python3 $DIR/image_creator.py --text "$RELEASE-$GIT" --out $STATUS_PNG --success
else
    res=$?
    echo "FAIL" | tee -a $LOG
    python3 $DIR/image_creator.py --text "$RELEASE-$GIT" --out $STATUS_PNG
fi

if (( $UPLOAD > 0 )); then
    $DIR/upload_to_qgis2.bash $RELEASE $LOG $PACKAGE $DEPS $STATUS_PNG $PACKAGE.sha256sum
fi

echo "All done (scripts/run_build2.bash)"
cd $PWD

exit $res
