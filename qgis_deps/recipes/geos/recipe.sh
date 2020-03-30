#!/bin/bash

DESC_geos="Geometry Engine"

# version of your package
VERSION_geos=3.8.1

# dependencies of this recipe
DEPS_geos=()

# url of the package
URL_geos=http://download.osgeo.org/geos/geos-${VERSION_geos}.tar.bz2

# md5 of the package
MD5_geos=9d25df02a2c4fcc5a59ac2fb3f0bd977

# default build path
BUILD_geos=$BUILD_PATH/geos/$(get_directory $URL_geos)

# default recipe path
RECIPE_geos=$RECIPES_PATH/geos

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_geos() {
  cd $BUILD_geos

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_geos() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libgeos_c.dylib -nt $BUILD_geos/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_geos() {
  try mkdir -p $BUILD_PATH/geos/build-$ARCH
  try cd $BUILD_PATH/geos/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_geos
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_geos() {
  verify_lib "libgeos_c.dylib"
}
