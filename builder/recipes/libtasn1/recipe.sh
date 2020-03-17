#!/bin/bash

# version of your package
VERSION_libtasn1=4.16.0

# dependencies of this recipe
DEPS_libtasn1=()

# url of the package
URL_libtasn1=https://gitlab.com/gnutls/libtasn1/-/archive/libtasn1_${VERSION_libtasn1//./_}/libtasn1-libtasn1_${VERSION_libtasn1//./_}.tar.gz

# md5 of the package
MD5_libtasn1=48fc92bd4ef633dc66ea413bf684763c

# default build path
BUILD_libtasn1=$BUILD_PATH/libtasn1/$(get_directory $URL_libtasn1)

# default recipe path
RECIPE_libtasn1=$RECIPES_PATH/libtasn1

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtasn1() {
  cd $BUILD_libtasn1

  # check marker
  if [ -f .patched ]; then
    return
  fi

  try git clone https://gitlab.com/libidn/gnulib-mirror.git gnulib-mirror
  cd gnulib-mirror
  git checkout 4c1009ec93e12ee34acd27f6d7e25442bedc16f2

  # patch_configure_file configure

  touch .patched
}

function shouldbuild_libtasn1() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libtasn1.dylib -nt $BUILD_libtasn1/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libtasn1() {
  try rsync -a $BUILD_libtasn1/ $BUILD_PATH/libtasn1/build-$ARCH/
  try cd $BUILD_PATH/libtasn1/build-$ARCH
  push_env

  try ./bootstrap --no-git --gnulib-srcdir=$BUILD_PATH/libtasn1/build-$ARCH/gnulib-mirror
  # try autoreconf



  try $BUILD_PATH/libtasn1/build-$ARCH/${CONFIGURE}
  patch_configure_file configure

  #  --disable-dependency-tracking

  # check_file_configuration config.status

  try $MAKESMP VERBOSE=1
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_libtasn1() {
  verify_lib "${STAGE_PATH}/lib/libtasn1.dylib"
}
