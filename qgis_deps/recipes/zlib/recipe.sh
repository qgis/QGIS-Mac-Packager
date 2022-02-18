#!/bin/bash

DESC_zlib="General-purpose lossless data-compression library"

# version of your package
VERSION_zlib=1.2.11
LINK_zlib=libz.1.dylib

# dependencies of this recipe
DEPS_zlib=()

# url of the package
URL_zlib=https://zlib.net/zlib-${VERSION_zlib}.tar.gz

# md5 of the package
MD5_zlib=1c9f62f0778697a09d36121ead88e08e

# default build path
BUILD_zlib=${DEPS_BUILD_PATH}/zlib/$(get_directory $URL_zlib)

# default recipe path
RECIPE_zlib=$RECIPES_PATH/zlib

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_zlib() {
  cd $BUILD_zlib
    patch_configure_file configure
  try rsync  -a $BUILD_zlib/ ${DEPS_BUILD_PATH}/zlib/build-${ARCH}

}

function shouldbuild_zlib() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_zlib -nt $BUILD_zlib/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_zlib() {
  verify_binary lib/$LINK_zlib
}

# function to append information to config file
function add_config_info_zlib() {
  append_to_config_file "# zlib-${VERSION_zlib}: ${DESC_zlib}"
  append_to_config_file "export VERSION_zlib=${VERSION_zlib}"
  append_to_config_file "export LINK_zlib=${LINK_zlib}"
}