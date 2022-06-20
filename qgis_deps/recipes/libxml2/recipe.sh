#!/bin/bash

DESC_libxml2="GNOME XML library"

LINK_libxml2=libxml2.2.dylib

DEPS_libxml2=()

# default build path
BUILD_libxml2=${DEPS_BUILD_PATH}/libxml2/$(get_directory $URL_libxml2)

# default recipe path
RECIPE_libxml2=$RECIPES_PATH/libxml2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libxml2() {
  cd $BUILD_libxml2
    patch_configure_file configure
  try rsync  -a $BUILD_libxml2/ ${DEPS_BUILD_PATH}/libxml2/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_libxml2() {
  verify_binary lib/$LINK_libxml2
}

# function to append information to config file
function add_config_info_libxml2() {
  append_to_config_file "# libxml2-${VERSION_libxml2}: ${DESC_libxml2}"
  append_to_config_file "export VERSION_libxml2=${VERSION_libxml2}"
  append_to_config_file "export LINK_libxml2=${LINK_libxml2}"
}