#!/bin/bash

DESC_saga="System for Automated Geoscientific Analyses"

# see https://github.com/qgis/QGIS/blob/master/python/plugins/sagaprovider/SagaAlgorithmProvider.py
# for supported versions

LINK_saga_version=${VERSION_saga}

DEPS_saga=( proj gdal python geos libtiff xz sqlite hdf5 netcdf postgres wxmac )


# md5 of the package

# default build path
BUILD_saga=${DEPS_BUILD_PATH}/saga/$(get_directory $URL_saga)

# default recipe path
RECIPE_saga=$RECIPES_PATH/saga

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_saga() {
  cd $BUILD_saga
    patch_configure_file configure
  try rsync  -a $BUILD_saga/ ${DEPS_BUILD_PATH}/saga/build-${ARCH}

}

function shouldbuild_saga() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libsaga_api.dylib -nt $BUILD_saga/.patched ]; then
    DO_BUILD=0
  fi
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