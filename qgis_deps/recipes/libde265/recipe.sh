#!/bin/bash

DESC_libde265="GNOME XML library"

# version of your package
VERSION_libde265=1.0.8
LINK_libde265=libde265.0.dylib

# dependencies of this recipe
DEPS_libde265=()

# url of the package
URL_libde265=https://github.com/strukturag/libde265/releases/download/v${VERSION_libde265}/libde265-${VERSION_libde265}.tar.gz

# md5 of the package
MD5_libde265=e5a8c91c533ae5926e5118087f78930f

# default build path
BUILD_libde265=$BUILD_PATH/libde265/$(get_directory $URL_libde265)

# default recipe path
RECIPE_libde265=$RECIPES_PATH/libde265

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libde265() {
  cd $BUILD_libde265
  try rsync  -a $BUILD_libde265/ ${BUILD_PATH}/libde265/build-${ARCH}
}

function shouldbuild_libde265() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libde265 -nt $BUILD_libde265/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libde265() {
  verify_binary lib/$LINK_libde265
}

# function to append information to config file
function add_config_info_libde265() {
  append_to_config_file "# libde265-${VERSION_libde265}: ${DESC_libde265}"
  append_to_config_file "export VERSION_libde265=${VERSION_libde265}"
  append_to_config_file "export LINK_libde265=${LINK_libde265}"
}