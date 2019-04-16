#!/bin/bash

set -e

# 2018 Peter Petrik (zilolv at gmail dot com)
# GNU General Public License 2 any later version

PWD=`pwd`
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if (( $# != 4 )); then
    echo "run_build build_dir git_tag release_name qgisapp_name"
fi

BUILD_DIR=$1
GIT=$2
RELEASE=$3
QGISAPP=$4
PACKAGE=qgis_${RELEASE}_${GIT}_${TIMESTAMP}.dmg

echo "Building & Packaging QGIS to $BUILD_DIR"
mkdir -p $BUILD_DIR

echo "Building QGIS $GIT for $RELEASE"

echo "Please run brew update manually to get new deps"

cd $DIR/..
echo "Run"

python3 qgis-mac-packager.py \
    --output_directory $BUILD_DIR \
    --git $GIT \
    --release_type $RELEASE \
    --qgisapp_name ${QGISAPP} \
    --dmg_name $PACKAGE \
    -vv

echo "All done"
cd $PWD
