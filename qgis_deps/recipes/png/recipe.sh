#!/bin/bash

DESC_png="PNG Image library"

# version of your package
VERSION_png=1.6.37

LINK_libpng=libpng16.16.dylib

# dependencies of this recipe
DEPS_png=()

# url of the package
URL_png=https://downloads.sourceforge.net/libpng/libpng-${VERSION_png}.tar.xz

# md5 of the package
MD5_png=015e8e15db1eecde5f2eb9eb5b6e59e9

# default build path
BUILD_png=${DEPS_BUILD_PATH}/png/$(get_directory $URL_png)

# default recipe path
RECIPE_png=$RECIPES_PATH/png

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_png() {
  cd $BUILD_png
    patch_configure_file configure
  try rsync  -a $BUILD_png/ ${DEPS_BUILD_PATH}/png/build-${ARCH}

}

function shouldbuild_png() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libpng -nt $BUILD_png/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_png() {
  verify_binary lib/$LINK_libpng
}

# function to append information to config file
function add_config_info_png() {
  append_to_config_file "# png-${VERSION_png}: ${DESC_png}"
  append_to_config_file "export VERSION_png=${VERSION_png}"
  append_to_config_file "export LINK_libpng=${LINK_libpng}"
}