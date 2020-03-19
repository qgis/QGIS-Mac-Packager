#!/bin/bash

# version of your package
VERSION_png=1.6.37

# dependencies of this recipe
DEPS_png=()

# url of the package
URL_png=https://downloads.sourceforge.net/libpng/libpng-${VERSION_png}.tar.xz

# md5 of the package
MD5_png=015e8e15db1eecde5f2eb9eb5b6e59e9

# default build path
BUILD_png=$BUILD_PATH/png/$(get_directory $URL_png)

# default recipe path
RECIPE_png=$RECIPES_PATH/png

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_png() {
  cd $BUILD_png

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_png() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libpng.dylib -nt $BUILD_png/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_png() {
  try rsync -a $BUILD_png/ $BUILD_PATH/png/build-$ARCH/
  try cd $BUILD_PATH/png/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-debug

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  install_name_tool -id "@rpath/libpng.dylib" ${STAGE_PATH}/lib/libpng.dylib

  pop_env
}

# function called after all the compile have been done
function postbuild_png() {
  verify_lib "libpng.dylib"
}
