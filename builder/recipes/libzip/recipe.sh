#!/bin/bash

# version of your package
VERSION_libzip=1.6.1

# dependencies of this recipe
DEPS_libzip=(xz)

# url of the package
URL_libzip=https://libzip.org/download/libzip-${VERSION_libzip}.tar.xz

# md5 of the package
MD5_libzip=f9a228619aab2446addc9c9e0e2de149

# default build path
BUILD_libzip=$BUILD_PATH/libzip/$(get_directory $URL_libzip)

# default recipe path
RECIPE_libzip=$RECIPES_PATH/libzip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libzip() {
  cd $BUILD_libzip

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_libzip() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libzip.dylib -nt $BUILD_libzip/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libzip() {
  try mkdir -p $BUILD_PATH/libzip/build-$ARCH
  try cd $BUILD_PATH/libzip/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_libzip
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_libzip() {
  verify_lib "libzip.dylib"
}
