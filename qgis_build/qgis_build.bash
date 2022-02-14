#!/usr/bin/env bash

set -euo pipefail
# set -o verbose

QGIS_BUILD_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# load configuration
if (( $# < 4 )); then
    echo "qgis_build: $0 <path/to>/config/<my>.conf major minor patch ..."
    exit 1
fi

CONFIG_FILE=$1
if [ ! -f "$CONFIG_FILE" ]; then
  echo "invalid config file (1st argument) $CONFIG_FILE"
  exit 1
fi
shift
export QGIS_MAJOR_VERSION=$1
shift
export QGIS_MINOR_VERSION=$1
shift
export QGIS_PATCH_VERSION=$1
shift
source $CONFIG_FILE

CC="/usr/bin/clang"
CXX="/usr/bin/clang++"

if [ ! -f "$QGIS_SOURCE_DIR/CMakeLists.txt" ]; then
  error "QGIS repo is not available at $QGIS_SOURCE_DIR"
fi

# source the ENV vars from the qgis_deps
if [ ! -f "$QGIS_DEPS_STAGE_PATH/qgis-deps.config" ]; then
  error "missing $QGIS_DEPS_STAGE_PATH/qgis-deps.config"
fi
source $QGIS_DEPS_STAGE_PATH/qgis-deps.config

# create build dirs
OLD_PATH=$PATH
try mkdir -p "$QGIS_BUILD_DIR"
try mkdir -p "$QGIS_INSTALL_DIR"

# run cmake
cd $QGIS_BUILD_DIR

if [[ "$WITH_HANA" == "true" ]]; then
  HANA_CMAKE="-DWITH_HANA=TRUE"
else
  HANA_CMAKE="-DWITH_HANA=FALSE"
fi

if [[ "$WITH_ORACLE" == "true" ]]; then
  ORACLE_SDK="${QGIS_PRIVATE_SDKS_PATH}/oracle/sdk"
  if [ ! -d "$ORACLE_SDK" ]; then
    error "missing oracle SDK $ORACLE_SDK"
  fi
  ORACLE_CLIENT="${QGIS_PRIVATE_SDKS_PATH}/oracle/instantclient"
  if [ ! -d "$ORACLE_CLIENT" ]; then
    error "invalid oracle basic-light client $ORACLE_CLIENT"
  fi
  ORACLE_CMAKE="-DWITH_ORACLE=TRUE -DORACLE_INCLUDEDIR=$ORACLE_SDK/include -DORACLE_LIBDIR=$ORACLE_CLIENT"
else
  ORACLE_CMAKE="-DWITH_ORACLE=FALSE"
fi

if [[ "$WITH_PDAL" == "true" ]]; then
  PDAL_CMAKE="-DWITH_EPT=TRUE -DWITH_PDAL=TRUE"
else
  PDAL_CMAKE="-DWITH_EPT=FALSE -DWITH_PDAL=FALSE"
fi

echo "Running CMAKE command, check $QGIS_BUILD_DIR/cmake.configure in case of error!"
echo "Using $CXX compiler"
# SERVER_SKIP_ECW == ECW in server apps requires a special license
PATH=$ROOT_OUT_PATH/stage/bin:$PATH \
cmake -DCMAKE_BUILD_TYPE=Release \
      $HANA_CMAKE \
      $ORACLE_CMAKE \
      -DQGIS_MAC_DEPS_DIR=$ROOT_OUT_PATH/stage \
      -DODBC_CONFIG=$ROOT_OUT_PATH/stage/unixodbc/bin/odbc_config \
      -DODBC_INCLUDE_DIR=$ROOT_OUT_PATH/stage/unixodbc/include \
      -DODBC_LIBRARY=$ROOT_OUT_PATH/stage/unixodbc/lib/$LINK_unixodbc \
      -DCMAKE_PREFIX_PATH=$QT_BASE/clang_64 \
      -DQGIS_MACAPP_BUNDLE=-1 \
      -DWITH_GEOREFERENCER=TRUE \
      -DWITH_3D=TRUE \
      $PDAL_CMAKE \
      -DWITH_BINDINGS=TRUE \
      -DSERVER_SKIP_ECW=TRUE \
      -DWITH_SERVER=TRUE \
      -DWITH_CUSTOM_WIDGETS=ON \
      -DQT_PLUGINS_DIR:PATH=$QGIS_INSTALL_DIR/plugins \
      -DENABLE_TESTS=FALSE \
      -GNinja -DCMAKE_MAKE_PROGRAM=/usr/local/bin/ninja\
      -DCMAKE_OSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET \
      -DCMAKE_INSTALL_PREFIX:PATH=$QGIS_INSTALL_DIR \
      -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX \
      "$QGIS_SOURCE_DIR" > cmake.configure 2>&1

# check we use correct deps
cat cmake.configure

targets=(
    lib/libgdal.dylib
    lib/libgeos_c.dylib
    lib/libproj.dylib
    opt/unixodbc/lib/libodbc
)
for i in ${targets[*]}
do
    if grep -q /usr/local/$i cmake.configure
    then
      error "CMake configured QGIS build with /usr/local/$i.dylib string -- we should be using qgis_deps version of this library"
    fi
done

targets=(
    libz
    libssl
    libcrypto
    libpq
    libxml2
    libsqlite3
    libexpat
    libiconv
    liblzma
    libarchive
    libbz2
    libiodbc
)
for i in ${targets[*]}
do
    if grep -q /usr/lib/$i cmake.configure
    then
      error "CMake configured QGIS build with /usr/lib/$i.dylib string -- we should be using qgis_deps version of this library"
    fi
done

# make
try rm -rf $QGIS_INSTALL_DIR/*
try cd $QGIS_BUILD_DIR
try ninja
try ninja install

echo "build done"
