#!/bin/bash

DESC_libffi="Portable Foreign Function Interface library"

# version of your package
VERSION_libffi=3.4.2
LINK_libffi=libffi.8.dylib

# dependencies of this recipe
DEPS_libffi=()

# url of the package
URL_libffi=https://github.com/libffi/libffi/releases/download/v${VERSION_libffi}/libffi-${VERSION_libffi}.tar.gz

# md5 of the package
MD5_libffi=294b921e6cf9ab0fbaea4b639f8fdbe8

# default build path
BUILD_libffi=${DEPS_BUILD_PATH}/libffi/$(get_directory $URL_libffi)

# default recipe path
RECIPE_libffi=$RECIPES_PATH/libffi

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libffi() {
  cd $BUILD_libffi
    patch_configure_file configure
  try rsync  -a $BUILD_libffi/ ${DEPS_BUILD_PATH}/libffi/build-${ARCH}
}

function shouldbuild_libffi() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libffi -nt $BUILD_libffi/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libffi() {
  verify_binary lib/$LINK_libffi
}

# function to append information to config file
function add_config_info_libffi() {
  append_to_config_file "# libffi-${VERSION_libffi}: ${DESC_libffi}"
  append_to_config_file "export VERSION_libffi=${VERSION_libffi}"
  append_to_config_file "export LINK_libffi=${LINK_libffi}"
}