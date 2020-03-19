#!/bin/bash

# version of your package
VERSION_spatialindex=1.9.3

# dependencies of this recipe
DEPS_spatialindex=()

# url of the package
URL_spatialindex=https://github.com/libspatialindex/libspatialindex/releases/download/$VERSION_spatialindex/spatialindex-src-$VERSION_spatialindex.tar.gz

# md5 of the package
MD5_spatialindex=7233d2961d42402e9e8cc1471322ca22

# default build path
BUILD_spatialindex=$BUILD_PATH/spatialindex/$(get_directory $URL_spatialindex)

# default recipe path
RECIPE_spatialindex=$RECIPES_PATH/spatialindex

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_spatialindex() {
  cd $BUILD_spatialindex

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_spatialindex() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libspatialindex.dylib -nt $BUILD_spatialindex/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_spatialindex() {
  try mkdir -p $BUILD_PATH/spatialindex/build-$ARCH
  try cd $BUILD_PATH/spatialindex/build-$ARCH

  push_env

  try $CMAKE $BUILD_spatialindex .
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKE install

  pop_env
}

# function called after all the compile have been done
function postbuild_spatialindex() {
  verify_lib "libspatialindex.dylib"
}
