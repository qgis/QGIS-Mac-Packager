#!/bin/bash

# version of your package
VERSION_xz=5.2.4

# dependencies of this recipe
DEPS_xz=()

# url of the package
URL_xz=https://downloads.sourceforge.net/project/lzmautils/xz-${VERSION_xz}.tar.gz

# md5 of the package
MD5_xz=5ace3264bdd00c65eeec2891346f65e6

# default build path
BUILD_xz=$BUILD_PATH/xz/$(get_directory $URL_xz)

# default recipe path
RECIPE_xz=$RECIPES_PATH/xz

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_xz() {
  cd $BUILD_xz

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_xz() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/liblzma.dylib -nt $BUILD_xz/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_xz() {
  try rsync -a $BUILD_xz/ $BUILD_PATH/xz/build-$ARCH/
  try cd $BUILD_PATH/xz/build-$ARCH
  push_env

  try ${BUILD_xz}/${CONFIGURE}

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_xz() {
  verify_lib_arch "${STAGE_PATH}/lib/liblzma.dylib"
}
