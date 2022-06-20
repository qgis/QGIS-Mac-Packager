#!/bin/bash

DESC_szip="Szip Compression in HDF Products"

LINK_szip=libsz.${VERSION_szip//.*/}.dylib

DEPS_szip=()

# default build path
BUILD_szip=${DEPS_BUILD_PATH}/szip/$(get_directory $URL_szip)

# default recipe path
RECIPE_szip=$RECIPES_PATH/szip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_szip() {
  cd $BUILD_szip
    patch_configure_file configure
  try rsync -a $BUILD_szip/ ${DEPS_BUILD_PATH}/szip/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_szip() {
  verify_binary lib/$LINK_szip
}

# function to append information to config file
function add_config_info_szip() {
  append_to_config_file "# szip-${VERSION_szip}: ${DESC_szip}"
  append_to_config_file "export VERSION_szip=${VERSION_szip}"
  append_to_config_file "export LINK_szip=${LINK_szip}"
}