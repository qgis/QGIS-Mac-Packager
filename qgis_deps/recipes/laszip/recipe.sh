#!/bin/bash

DESC_laszip="Lossless LiDAR compression"

LINK_liblaszip_api=liblaszip_api.8.dylib
LINK_liblaszip=liblaszip.8.dylib

DEPS_laszip=()

# default build path
BUILD_laszip=${DEPS_BUILD_PATH}/laszip/$(get_directory $URL_laszip)

# default recipe path
RECIPE_laszip=$RECIPES_PATH/laszip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_laszip() {
  cd $BUILD_laszip
}

# function called after all the compile have been done
function postbuild_laszip() {
  verify_binary lib/${LINK_liblaszip_api}
  verify_binary lib/${LINK_liblaszip}
}

# function to append information to config file
function add_config_info_laszip() {
  append_to_config_file "# laszip-${VERSION_laszip}: ${DESC_laszip}"
  append_to_config_file "export VERSION_laszip=${VERSION_laszip}"
  append_to_config_file "export LINK_liblaszip_api=${LINK_liblaszip_api}"
  append_to_config_file "export LINK_liblaszip=${LINK_liblaszip}"
}