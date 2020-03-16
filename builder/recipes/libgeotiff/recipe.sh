#!/bin/bash

# version of your package
VERSION_libgeotiff=1.5.1

# dependencies of this recipe
DEPS_libgeotiff=(libtiff)

# url of the package
URL_libgeotiff=https://github.com/OSGeo/libgeotiff/releases/download/${VERSION_libgeotiff}/libgeotiff-${VERSION_libgeotiff}.tar.gz

# md5 of the package
MD5_libgeotiff=6d0fa650c206791bc7d5e60ef625ea77

# default build path
BUILD_libgeotiff=$BUILD_PATH/libgeotiff/$(get_directory $URL_libgeotiff)

# default recipe path
RECIPE_libgeotiff=$RECIPES_PATH/libgeotiff

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libgeotiff() {
  cd $BUILD_libgeotiff

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

# function called before build_libgeotiff
# set DO_BUILD=0 if you know that it does not require a rebuild
function shouldbuild_libgeotiff() {
# If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/libgeotiff.a" -nt $BUILD_libgeotiff/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libgeotiff() {
  try mkdir -p $BUILD_PATH/libgeotiff/build-$ARCH
  try cd $BUILD_PATH/libgeotiff/build-$ARCH

  push_env

  try $CMAKE $BUILD_libgeotiff .
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKE install

  pop_env
}

# function called after all the compile have been done
function postbuild_libgeotiff() {
  verify_lib "${STAGE_PATH}/lib/libgeotiff.a"
}
