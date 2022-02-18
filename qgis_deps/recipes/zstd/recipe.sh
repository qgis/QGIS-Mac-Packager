#!/bin/bash

DESC_zstd="Zstandard is a real-time compression algorithm"

# version of your package
VERSION_zstd=1.5.2
LINK_zstd=libzstd.1.dylib

# dependencies of this recipe
DEPS_zstd=()

# url of the package
URL_zstd=https://github.com/facebook/zstd/archive/v${VERSION_zstd}.tar.gz

# md5 of the package
MD5_zstd=6dc24b78e32e7c99f80c9441e40ff8bc

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

function shouldbuild_zstd() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_zstd -nt $BUILD_zstd/.patched ]; then
    DO_BUILD=0
  fi
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