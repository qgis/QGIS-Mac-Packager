#!/bin/bash

DESC_jpeg="Image manipulation library"


LINK_jpeg=libjpeg.9.dylib

DEPS_jpeg=()

# default build path
BUILD_jpeg=${DEPS_BUILD_PATH}/jpeg/$(get_directory $URL_jpeg)

# default recipe path
RECIPE_jpeg=$RECIPES_PATH/jpeg

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_jpeg() {
  cd $BUILD_jpeg
    patch_configure_file configure
  try rsync  -a $BUILD_jpeg/ ${DEPS_BUILD_PATH}/jpeg/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_jpeg() {
  verify_binary lib/$LINK_jpeg
}

# function to append information to config file
function add_config_info_jpeg() {
  append_to_config_file "# jpeg-${VERSION_jpeg}: ${DESC_jpeg}"
  append_to_config_file "export VERSION_jpeg=${VERSION_jpeg}"
  append_to_config_file "export LINK_jpeg=${LINK_jpeg}"
}