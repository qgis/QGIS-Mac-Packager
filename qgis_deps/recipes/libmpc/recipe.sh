#!/bin/bash

DESC_libmpc="C library for the arithmetic of high precision complex numbers"

# version of your package
VERSION_libmpc=1.1.0
LINK_libmpc=libmpc.3.dylib

# dependencies of this recipe
DEPS_libmpc=(gmp mpfr)

# url of the package
URL_libmpc=https://ftp.gnu.org/gnu/mpc/mpc-$VERSION_libmpc.tar.gz

# md5 of the package
MD5_libmpc=4125404e41e482ec68282a2e687f6c73

# default build path
BUILD_libmpc=$BUILD_PATH/libmpc/$(get_directory $URL_libmpc)

# default recipe path
RECIPE_libmpc=$RECIPES_PATH/libmpc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libmpc() {
  cd $BUILD_libmpc
  try rsync -a $BUILD_libmpc/ ${BUILD_PATH}/libmpc/build-${ARCH}


  patch_configure_file configure

}

function shouldbuild_libmpc() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libmpc -nt $BUILD_libmpc/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_libmpc() {
  verify_binary lib/$LINK_libmpc
}

# function to append information to config file
function add_config_info_libmpc() {
  append_to_config_file "# libmpc-${VERSION_libmpc}: ${DESC_libmpc}"
  append_to_config_file "export VERSION_libmpc=${VERSION_libmpc}"
  append_to_config_file "export LINK_libmpc=${LINK_libmpc}"
}
