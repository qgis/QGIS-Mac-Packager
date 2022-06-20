#!/bin/bash

DESC_openjpeg="Image manipulation library"


LINK_openjpeg=libopenjp2.7.dylib

DEPS_openjpeg=(
  png
  libtiff
  little_cms2
)

# default build path
BUILD_openjpeg=${DEPS_BUILD_PATH}/openjpeg/$(get_directory $URL_openjpeg)

# default recipe path
RECIPE_openjpeg=$RECIPES_PATH/openjpeg

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_openjpeg() {
  cd $BUILD_openjpeg
  try rsync -a $BUILD_openjpeg/ ${DEPS_BUILD_PATH}/openjpeg/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_openjpeg() {
  verify_binary lib/$LINK_openjpeg
}

# function to append information to config file
function add_config_info_openjpeg() {
  append_to_config_file "# openjpeg-${VERSION_openjpeg}: ${DESC_openjpeg}"
  append_to_config_file "export VERSION_openjpeg=${VERSION_openjpeg}"
  append_to_config_file "export LINK_openjpeg=${LINK_openjpeg}"
}