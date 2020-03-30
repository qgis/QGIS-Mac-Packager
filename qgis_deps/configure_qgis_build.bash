#!/usr/bin/env bash

PWD=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

source $DIR/config.conf

if [ ! -d $ROOT_OUT_PATH ]; then
  echo "The root ROOT_OUT_PATH output directory '$ROOT_OUT_PATH' not found."
  exit 1
fi

if [ ! -d $QT_BASE/clang_64 ]; then
  echo "The qt QT_BASE/clang_64 directory '$QT_BASE/clang_64' not found."
  exit 1
fi

if (( $# < 2 )); then
    echo "usage: $0 qgis_dir build_dir"
    echo "qgis_dir: Directory with cloned qgis/QGIS source code"
    echo "build_dir: Where you want to build QGIS"
    exit 1
fi

QGIS_DIR=$1
BUILD_DIR=$2
CORES=$(sysctl -n hw.ncpu)

echo "Preparing build from $QGIS_DIR to $BUILD_DIR"

mkdir -p $BUILD_DIR

cd $BUILD_DIR

CMD="""
PATH=$ROOT_OUT_PATH/stage/bin:$PATH \
cmake -DQGIS_MAC_DEPS_DIR=$ROOT_OUT_PATH/stage \
      -DCMAKE_PREFIX_PATH=$QT_BASE/clang_64 \
      -DQGIS_MACAPP_BUNDLE=0 \
      -DWITH_QTWEBKIT=FALSE \
      -DWITH_QT5SERIALPORT=FALSE \
      -DWITH_GRASS=OFF \
      $QGIS_DIR
"""

echo "$CMD"
eval "$CMD"


echo "Your QGIS build directory is prepared at $BUILD_DIR"
echo "To build QGIS, run"
echo "cd $BUILD_DIR; make -j $CORES"

cd $PWD