#!/bin/bash

set -o pipefail

# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

PWD=`pwd`
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if (( $# < 5 )); then
    echo "run_build build_dir git_tag release_name qgisapp_name [no-upload]"
fi

BUILD_DIR=$1
GIT=$2
RELEASE=$3
QGISAPP=$4
PACKAGE=qgis_${RELEASE}_${GIT}_${TIMESTAMP}.dmg
STATUS_PNG=$BUILD_DIR/qgis_${RELEASE}_${GIT}_${TIMESTAMP}.png
DEPS=$BUILD_DIR/qgis_${RELEASE}_${GIT}_${TIMESTAMP}.deps
LOG=$BUILD_DIR/qgis_${RELEASE}_${GIT}_${TIMESTAMP}.log

if (( $# == 4 )); then
    UPLOAD=1
else
    UPLOAD=0
fi

echo "Building & Packaging QGIS to $BUILD_DIR"
mkdir -p $BUILD_DIR

echo "Building QGIS $GIT for $RELEASE"

echo "Please run brew update manually to get new deps"
python3 $DIR/deps.py | tee $DEPS

cd $DIR/..
echo "Run"

python3 qgis-mac-packager.py \
    --output_directory $BUILD_DIR \
    --git $GIT \
    --release_type $RELEASE \
    --qgisapp_name ${QGISAPP} \
    --dmg_name $PACKAGE \
    -vv \
2>&1 | tee -a $LOG

exit_status=$?
if [ $exit_status -eq 0 ]; then
    echo "SUCCESS" | tee -a $LOG
    python3 $DIR/image_creator.py --text "$RELEASE-$GIT" --out $STATUS_PNG --success
else
    echo "FAIL" | tee -a $LOG
    python3 $DIR/image_creator.py --text "$RELEASE-$GIT" --out $STATUS_PNG
fi

if (( $UPLOAD > 0 )); then
    $DIR/upload_to_qgis2.bash $RELEASE $LOG $BUILD_DIR/$PACKAGE $DEPS $STATUS_PNG $BUILD_DIR/$PACKAGE.md5sum
fi

echo "All done"
cd $PWD
