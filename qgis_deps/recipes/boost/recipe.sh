#!/bin/bash

DESC_boost="Collection of portable C++ source libraries"

DEPS_boost=(zlib python libicu)

LINK_boost=libboost_python${VERSION_major_python//./}.dylib

# default build path
BUILD_boost=${DEPS_BUILD_PATH}/boost/$(get_directory $URL_boost)

# default recipe path
RECIPE_boost=$RECIPES_PATH/boost

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_boost() {
  cd $BUILD_boost

  # https://github.com/boostorg/python/pull/344
  #try patch --verbose --forward -p1 < ${RECIPE_boost}/patches/python310.patch
  try rsync -a $BUILD_boost/ ${DEPS_BUILD_PATH}/boost/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_boost() {
  verify_binary lib/$LINK_boost
}

# function to append information to config file
function add_config_info_boost() {
  append_to_config_file "# boost-${VERSION_boost}: ${DESC_boost}"
  append_to_config_file "export VERSION_boost=${VERSION_boost}"
}
