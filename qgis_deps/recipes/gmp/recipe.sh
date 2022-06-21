#!/bin/bash

DESC_gmp="Arithmetic without limitations"

LINK_gmp=libgmpxx.4.dylib

DEPS_gmp=()



# default build path
BUILD_gmp=${DEPS_BUILD_PATH}/gmp/$(get_directory $URL_gmp)

# default recipe path
RECIPE_gmp=$RECIPES_PATH/gmp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gmp() {
  cd $BUILD_gmp
    patch_configure_file configure
  try rsync   -a $BUILD_gmp/ ${DEPS_BUILD_PATH}/gmp/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_gmp() {
  verify_binary lib/$LINK_gmp
}

# function to append information to config file
function add_config_info_gmp() {
  append_to_config_file "# gmp-${VERSION_gmp}: ${DESC_gmp}"
  append_to_config_file "export VERSION_gmp=${VERSION_gmp}"
  append_to_config_file "export LINK_gmp=${LINK_gmp}"
}
