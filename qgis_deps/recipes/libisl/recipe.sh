#!/bin/bash

DESC_libisl="Integer Set Library"

# version of your package
VERSION_libisl=0.24
LINK_libisl=libisl.dylib

# dependencies of this recipe
DEPS_libisl=(gmp python)

# url of the package
URL_libisl=https://libisl.sourceforge.io/isl-${VERSION_libisl}.tar.xz

# md5 of the package
MD5_libisl=fae030f604a9537adc2502990a8ab4d1

# default build path
BUILD_libisl=${DEPS_BUILD_PATH}/libisl/$(get_directory $URL_libisl)

# default recipe path
RECIPE_libisl=$RECIPES_PATH/libisl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libisl() {
  cd $BUILD_libisl
  patch_configure_file configure
  try rsync  -a $BUILD_libisl/ ${DEPS_BUILD_PATH}/libisl/build-$ARCH/
}

function shouldbuild_libisl() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libisl -nt $BUILD_libisl/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libisl() {
  verify_binary lib/$LINK_libisl
}

# function to append information to config file
function add_config_info_libisl() {
  append_to_config_file "# libisl-${VERSION_libisl}: ${DESC_libisl}"
  append_to_config_file "export VERSION_libisl=${VERSION_libisl}"
  append_to_config_file "export LINK_libisl=${LINK_libisl}"
}
