#!/bin/bash

DESC_libmpc="C library for the arithmetic of high precision complex numbers"

# version of your package
VERSION_libmpc=1.3.1
LINK_libmpc=libmpc.3.dylib

# dependencies of this recipe
DEPS_libmpc=(gmp mpfr)

# url of the package
URL_libmpc=https://ftp.gnu.org/gnu/mpc/mpc-$VERSION_libmpc.tar.gz

# md5 of the package
MD5_libmpc=5c9bc658c9fd0f940e8e3e0f09530c62

# default build path
BUILD_libmpc=$BUILD_PATH/libmpc/$(get_directory $URL_libmpc)

# default recipe path
RECIPE_libmpc=$RECIPES_PATH/libmpc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libmpc() {
  cd $BUILD_libmpc

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_libmpc() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libmpc -nt $BUILD_libmpc/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libmpc() {
  try rsync -a $BUILD_libmpc/ $BUILD_PATH/libmpc/build-$ARCH/
  try cd $BUILD_PATH/libmpc/build-$ARCH
  push_env

  try ${CONFIGURE} \
      --disable-dependency-tracking \
      --with-gmp=$STAGE_PATH \
      --with-mpfr=$STAGE_PATH

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
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
