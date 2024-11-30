#!/bin/bash

DESC_mpfr="C library for multiple-precision floating-point computations"

# version of your package
VERSION_mpfr=4.2.0
LINK_mpfr=libmpfr.6.dylib

# dependencies of this recipe
DEPS_mpfr=(gmp)

# url of the package
URL_mpfr=https://ftp.gnu.org/gnu/mpfr/mpfr-$VERSION_mpfr.tar.xz

# md5 of the package
MD5_mpfr=a25091f337f25830c16d2054d74b5af7

# default build path
BUILD_mpfr=$BUILD_PATH/mpfr/$(get_directory $URL_mpfr)

# default recipe path
RECIPE_mpfr=$RECIPES_PATH/mpfr

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_mpfr() {
  cd $BUILD_mpfr

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_mpfr() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_mpfr -nt $BUILD_mpfr/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_mpfr() {
  try rsync -a $BUILD_mpfr/ $BUILD_PATH/mpfr/build-$ARCH/
  try cd $BUILD_PATH/mpfr/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-dependency-tracking \
    --disable-silent-rules

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_mpfr() {
  verify_binary lib/$LINK_mpfr
}

# function to append information to config file
function add_config_info_mpfr() {
  append_to_config_file "# mpfr-${VERSION_mpfr}: ${DESC_mpfr}"
  append_to_config_file "export VERSION_mpfr=${VERSION_mpfr}"
  append_to_config_file "export LINK_mpfr=${LINK_mpfr}"
}
