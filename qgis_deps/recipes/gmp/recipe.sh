#!/bin/bash

DESC_gmp="Arithmetic without limitations"

# version of your package
VERSION_gmp=6.2.1
LINK_gmp=libgmpxx.4.dylib

# dependencies of this recipe
DEPS_gmp=()

# url of the package
URL_gmp=https://gmplib.org/download/gmp/gmp-$VERSION_gmp.tar.lz

# md5 of the package
MD5_gmp=03a31d8cbaf29d136252f8f38875ed82

# default build path
BUILD_gmp=$BUILD_PATH/gmp/$(get_directory $URL_gmp)

# default recipe path
RECIPE_gmp=$RECIPES_PATH/gmp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gmp() {
  cd $BUILD_gmp

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_gmp() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_gmp -nt $BUILD_gmp/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_gmp() {
  try rsync -a $BUILD_gmp/ $BUILD_PATH/gmp/build-$ARCH/
  try cd $BUILD_PATH/gmp/build-$ARCH
  push_env

  export CFLAGS="$CFLAGS -fno-stack-check"

  try ${CONFIGURE} --enable-cxx --with-pic

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_gmp() {
  verify_binary lib/$LINK_gmp
}

# function to append information to config file
function add_config_info_gmp() {
  append_to_config_file "# gmp-${VERSION_gmp}: ${DESC_gmp}"
  append_to_config_file "export VERSION_gmp=${VERSION_gmp}"
  append_to_config_file "export LINK_gmp=${LINK_gmp}"
}
