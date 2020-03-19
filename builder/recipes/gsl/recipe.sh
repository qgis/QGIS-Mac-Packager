#!/bin/bash

# version of your package
VERSION_gsl=2.6

# dependencies of this recipe
DEPS_gsl=()

# url of the package
URL_gsl=https://ftp.gnu.org/gnu/gsl/gsl-${VERSION_gsl}.tar.gz

# md5 of the package
MD5_gsl=bda73a3dd5ff2f30b5956764399db6e7

# default build path
BUILD_gsl=$BUILD_PATH/gsl/$(get_directory $URL_gsl)

# default recipe path
RECIPE_gsl=$RECIPES_PATH/gsl

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gsl() {
  cd $BUILD_gsl

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_gsl() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libgsl.dylib -nt $BUILD_gsl/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_gsl() {
  try rsync -a $BUILD_gsl/ $BUILD_PATH/gsl/build-$ARCH/
  try cd $BUILD_PATH/gsl/build-$ARCH
  push_env

  try ${CONFIGURE}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_gsl() {
  verify_lib "${STAGE_PATH}/lib/libgsl.dylib"
}
