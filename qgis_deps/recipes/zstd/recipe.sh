#!/bin/bash

DESC_zstd="Zstandard is a real-time compression algorithm"

# version of your package
VERSION_zstd=1.5.5
LINK_zstd=libzstd.1.dylib

# dependencies of this recipe
DEPS_zstd=()

# url of the package
URL_zstd=https://github.com/facebook/zstd/archive/v${VERSION_zstd}.tar.gz

# md5 of the package
MD5_zstd=4ff0ee1965ab161bc55be7c9dcd1f7f9

# default build path
BUILD_zstd=$BUILD_PATH/zstd/$(get_directory $URL_zstd)

# default recipe path
RECIPE_zstd=$RECIPES_PATH/zstd

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_zstd() {
  cd $BUILD_zstd

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_zstd() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_zstd -nt $BUILD_zstd/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_zstd() {
  try rsync -a $BUILD_zstd/ $BUILD_PATH/zstd/build-$ARCH/
  try cd $BUILD_PATH/zstd/build-$ARCH
  push_env

  try $MAKE install PREFIX=$STAGE_PATH

  pop_env
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