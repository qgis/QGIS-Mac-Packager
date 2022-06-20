#!/bin/bash

DESC_libtiff="TIFF library and utilities"


LINK_libtiff=libtiff.5.dylib
LINK_libtiffxx=libtiffxx.5.dylib

DEPS_libtiff=(xz zstd webp jpeg lerc zlib)

# default build path
BUILD_libtiff=${DEPS_BUILD_PATH}/libtiff/$(get_directory $URL_libtiff)

# default recipe path
RECIPE_libtiff=$RECIPES_PATH/libtiff


# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtiff() {
  cd $BUILD_libtiff
  patch_configure_file configure
}

# function called after all the compile have been done
function postbuild_libtiff() {
  verify_binary lib/$LINK_libtiff
  verify_binary lib/${LINK_libtiffxx}
  verify_binary bin/tiffsplit
}

# function to append information to config file
function add_config_info_libtiff() {
  append_to_config_file "# libtiff-${VERSION_libtiff}: ${DESC_libtiff}"
  append_to_config_file "export VERSION_libtiff=${VERSION_libtiff}"
  append_to_config_file "export LINK_libtiff=${LINK_libtiff}"
  append_to_config_file "export LINK_libtiffxx=${LINK_libtiffxx}"
}