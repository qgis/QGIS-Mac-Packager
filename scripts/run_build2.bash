#!/bin/bash

set -o pipefail

PWD=`pwd`
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if (( $# < 4 )); then
    echo "usage: $0 build_dir git_tag release_name qgisapp_name [no-upload]"
    exit 1
fi

BUILD_DIR=$1
GIT=$2
RELEASE=$3
QGISAPP=$4
PACKAGE=qgis_${RELEASE}_${GIT}_${TIMESTAMP}.dmg
STATUS_PNG=$BUILD_DIR/qgis_${RELEASE}_${GIT}_${TIMESTAMP}.png
DEPS=$BUILD_DIR/qgis_${RELEASE}_${GIT}_${TIMESTAMP}.deps
LOG=$BUILD_DIR/qgis_${RELEASE}_${GIT}_${TIMESTAMP}.log
CONFIG_FILE=$DIR/../config/$RELEASE.conf

if (( $# == 4 )); then
    UPLOAD=1
else
    UPLOAD=0
fi

echo "Building & Packaging QGIS to $BUILD_DIR"
mkdir -p $BUILD_DIR

echo "Building QGIS $GIT for $RELEASE"

echo "Please update qgis-deps package manually to get new deps"
$DIR/deps.bash $CONFIG_FILE | tee $DEPS

cd $DIR/..
echo "Run"

res=0

if qgis-mac-packager.bash \
  $BUILD_DIR \
  $GIT \
  $RELEASE \
  $PACKAGE \
  $CONFIG_FILE
2>&1 | tee -a $LOG; then
    echo "SUCCESS" | tee -a $LOG
    python3 $DIR/image_creator.py --text "$RELEASE-$GIT" --out $STATUS_PNG --success
else
    res=$?
    echo "FAIL" | tee -a $LOG
    python3 $DIR/image_creator.py --text "$RELEASE-$GIT" --out $STATUS_PNG
fi

if (( $UPLOAD > 0 )); then
    $DIR/upload_to_qgis2.bash $RELEASE $LOG $BUILD_DIR/$PACKAGE $DEPS $STATUS_PNG $BUILD_DIR/$PACKAGE.sha256sum
fi

echo "All done (scripts/run_build2.bash)"
cd $PWD

exit $res
