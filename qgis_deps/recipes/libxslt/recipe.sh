#!/bin/bash

DESC_libxslt="C XSLT library for GNOME"

# version of your package
VERSION_libxslt=1.1.35
LINK_libxslt=libxslt.1.dylib
LINK_libexslt=libexslt.0.dylib

# dependencies of this recipe
DEPS_libxslt=(libxml2)

# url of the package
URL_libxslt=https://github.com/GNOME/libxslt/archive/refs/tags/v${VERSION_libxslt}.tar.gz

# md5 of the package
MD5_libxslt=98d74d5fe8d4084eab8f089edb232e28

# default build path
BUILD_libxslt=${DEPS_BUILD_PATH}/libxslt/$(get_directory $URL_libxslt)

# default recipe path
RECIPE_libxslt=$RECIPES_PATH/libxslt

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libxslt() {
  cd $BUILD_libxslt
  try rsync -a $BUILD_libxslt/ ${DEPS_BUILD_PATH}/libxslt/build-${ARCH}
}

function shouldbuild_libxslt() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libxslt -nt $BUILD_libxslt/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libxslt() {
  verify_binary lib/$LINK_libxslt
  verify_binary lib/libexslt.dylib
}

# function to append information to config file
function add_config_info_libxslt() {
  append_to_config_file "# libxslt-${VERSION_libxslt}: ${DESC_libxslt}"
  append_to_config_file "export VERSION_libxslt=${VERSION_libxslt}"
  append_to_config_file "export LINK_libxslt=${LINK_libxslt}"
  append_to_config_file "export LINK_libexslt=${LINK_libexslt}"
}