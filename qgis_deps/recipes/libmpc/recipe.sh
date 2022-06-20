#!/bin/bash

DESC_libmpc="C library for the arithmetic of high precision complex numbers"

LINK_libmpc=libmpc.3.dylib

DEPS_libmpc=(gmp mpfr)
# default build path
BUILD_libmpc=${DEPS_BUILD_PATH}/libmpc/$(get_directory $URL_libmpc)

# default recipe path
RECIPE_libmpc=$RECIPES_PATH/libmpc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libmpc() {
  cd $BUILD_libmpc
    patch_configure_file configure
  try rsync  -a $BUILD_libmpc/ ${DEPS_BUILD_PATH}/libmpc/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_libmpc() {
  verify_binary lib/$LINK_libmpc
}

# function to append information to config file
function add_config_info_libmpc() {
  append_to_config_file "# libmpc-${VERSION_libmpc}: ${DESC_libmpc}"
  append_to_config_file "export VERSION_libmpc=${VERSION_libmpc}"
  append_to_config_file "export LINK_libmpc=${LINK_libmpc}"
}
