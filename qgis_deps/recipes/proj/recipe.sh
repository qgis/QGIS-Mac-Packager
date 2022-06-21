#!/bin/bash

DESC_proj="Cartographic Projections Library"

# keep in SYNC with python_pyproj receipt

LINK_libproj=libproj.${LIB_VERSION_proj}.dylib

DEPS_proj=(sqlite libxml2 openssl libtiff libcurl)

# default build path
BUILD_proj=${DEPS_BUILD_PATH}/proj/$(get_directory $URL_proj)

# default recipe path
RECIPE_proj=$RECIPES_PATH/proj

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_proj() {
  cd $BUILD_proj
}

# function called after all the compile have been done
function postbuild_proj() {
  verify_binary lib/$LINK_libproj

  verify_binary bin/proj
}

# function to append information to config file
function add_config_info_proj() {
  append_to_config_file "# proj-${VERSION_proj}: ${DESC_proj}"
  append_to_config_file "export VERSION_proj=${VERSION_proj}"
  append_to_config_file "export LINK_libproj=${LINK_libproj}"
}