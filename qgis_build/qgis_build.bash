#!/usr/bin/env bash

set -euo pipefail

# load configuration
if (( $# < 1 )); then
    error "qgis_build: $0 <path/to>/config/<my>.conf ..."
fi
CONFIG_FILE=$1
if [ ! -f "$CONFIG_FILE" ]; then
  error "invalid config file (1st argument) $CONFIG_FILE"
fi
shift
source $CONFIG_FILE

# create build dirs
OLD_PATH=$PATH
try mkdir -p "$QGIS_BUILD_DIR"
try mkdir -p "$QGIS_INSTALL_DIR"

# run cmake
try cd $QGIS_BUILD_DIR
PATH=$ROOT_OUT_PATH/stage/bin:$PATH \
cmake -DQGIS_MAC_DEPS_DIR=$ROOT_OUT_PATH/stage \
      -DCMAKE_PREFIX_PATH=$QT_BASE/clang_64 \
      -DQGIS_MACAPP_BUNDLE=-1 \
      -DWITH_GEOREFERENCER=TRUE \
      -DWITH_3D=TRUE \
      -DWITH_BINDINGS=TRUE \
      -DENABLE_TESTS=FALSE \
      -DCMAKE_OSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET \
      -DCMAKE_INSTALL_PREFIX:PATH=$QGIS_INSTALL_DIR\
      "$QGIS_SOURCE_DIR" > cmake.configure 2>&1

# check we use correct deps
cat cmake.configure

targets=(
    libgdal.dylib
    libgeos_c.dylib
    libproj.dylib
)
for i in ${targets[*]}
do
    if grep -q /usr/local/lib/$i cmake.configure
    then
      error "CMake configured QGIS build with /usr/local/lib/$i.dylib string -- we should be using qgis_deps version of this library"
    fi
done

targets=(
    libz
    libssl
    libcrypto
    libpq
    libxml2
    libsqlite3
)
for i in ${targets[*]}
do
    if grep -q /usr/lib/$i cmake.configure
    then
      error "CMake configured QGIS build with /usr/lib/$i.dylib string -- we should be using qgis_deps version of this library"
    fi
done

# make
try cd $QGIS_BUILD_DIR
try make -j ${CORES}
try make install

echo "build done"