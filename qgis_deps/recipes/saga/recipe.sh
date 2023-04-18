#!/bin/bash

DESC_saga="System for Automated Geoscientific Analyses"

# version of your package
# see https://github.com/qgis/QGIS/blob/master/python/plugins/sagaprovider/SagaAlgorithmProvider.py
# for supported versions
VERSION_saga=9.0.0

LINK_saga_version=${VERSION_saga}

# dependencies of this recipe
DEPS_saga=( proj gdal python geos libtiff xz sqlite hdf5 netcdf postgres wxmac )

# url of the package
URL_saga=https://downloads.sourceforge.net/project/saga-gis/SAGA%20-%209/SAGA%20-%20${VERSION_saga}/saga-${VERSION_saga}.tar.gz

# md5 of the package
MD5_saga=285a70b514a38f2609b76a5acbc67cd1

# default build path
BUILD_saga=$BUILD_PATH/saga/$(get_directory $URL_saga)

# default recipe path
RECIPE_saga=$RECIPES_PATH/saga

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_saga() {
  cd $BUILD_saga

  # check marker
  if [ -f .patched ]; then
    return
  fi

  # patch_configure_file configure

  touch .patched
}

function shouldbuild_saga() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libsaga_api.dylib -nt $BUILD_saga/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_saga() {
  try rsync -a $BUILD_saga/ $BUILD_PATH/saga/build-$ARCH/
  try cd $BUILD_PATH/saga/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --disable-dependency-tracking \
    --disable-openmp \
    --disable-libfire \
    --enable-shared \
    --disable-gui \
    --disable-odbc \
    --with-postgresql=$STAGE_PATH/bin/pg_config

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_saga() {
  verify_binary "lib/libsaga_api.dylib"
  verify_binary bin/saga_cmd
}

# function to append information to config file
function add_config_info_saga() {
  append_to_config_file "# saga-${VERSION_saga}: ${DESC_saga}"
  append_to_config_file "export VERSION_saga=${VERSION_saga}"
}