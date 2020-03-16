#!/bin/bash

# version of your package
VERSION_libtiff=4.0.10

# dependencies of this recipe
DEPS_libtiff=(xz zstd jpeg webp)

# url of the package
URL_libtiff=http://download.osgeo.org/libtiff/tiff-${VERSION_libtiff}.tar.gz

# md5 of the package
MD5_libtiff=114192d7ebe537912a2b97408832e7fd

# default build path
BUILD_libtiff=$BUILD_PATH/libtiff/$(get_directory $URL_libtiff)

# default recipe path
RECIPE_libtiff=$RECIPES_PATH/libtiff

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtiff() {
  cd $BUILD_libtiff

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

# function called before build_libtiff
# set DO_BUILD=0 if you know that it does not require a rebuild
function shouldbuild_libtiff() {
# If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/libtiff.dylib" -nt $BUILD_libtiff/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libtiff() {
  try mkdir -p $BUILD_PATH/libtiff/build-$ARCH
  try cd $BUILD_PATH/libtiff/build-$ARCH

  push_env

  try $CMAKE $BUILD_libtiff .
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKE install

  pop_env
}

# function called after all the compile have been done
function postbuild_libtiff() {
  verify_lib "${STAGE_PATH}/lib/libtiff.dylib"
}
