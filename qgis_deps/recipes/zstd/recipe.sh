#!/bin/bash

DESC_zstd="Zstandard is a real-time compression algorithm"

LINK_zstd=libzstd.1.dylib

DEPS_zstd=()

# default build path
BUILD_zstd=${DEPS_BUILD_PATH}/zstd/$(get_directory $URL_zstd)

# default recipe path
RECIPE_zstd=$RECIPES_PATH/zstd

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_zstd() {
  cd $BUILD_zstd
  try rsync -a $BUILD_zstd/ ${DEPS_BUILD_PATH}/zstd/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_zstd() {
  verify_binary lib/$LINK_zstd
}

# function to append information to config file
function add_config_info_zstd() {
  append_to_config_file "# zstd-${VERSION_zstd}: ${DESC_zstd}"
  append_to_config_file "export VERSION_zstd=${VERSION_zstd}"
  append_to_config_file "export LINK_zstd=${LINK_zstd}"
}