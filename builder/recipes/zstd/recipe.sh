#!/bin/bash

# version of your package
VERSION_zstd=1.4.4

# dependencies of this recipe
DEPS_zstd=()

# url of the package
URL_zstd=https://github.com/facebook/zstd/archive/v${VERSION_zstd}.tar.gz

# md5 of the package
MD5_zstd=532aa7b3a873e144bbbedd9c0ea87694

# default build path
BUILD_zstd=$BUILD_PATH/zstd/$(get_directory $URL_zstd)

# default recipe path
RECIPE_zstd=$RECIPES_PATH/zstd

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_zstd() {
  cd $BUILD_zstd

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_zstd() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libzstd.dylib -nt $BUILD_zstd/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_zstd() {
  try rsync -a $BUILD_zstd/ $BUILD_PATH/zstd/build-$ARCH/
  try cd $BUILD_PATH/zstd/build-$ARCH
  push_env

  try $MAKE install PREFIX=$STAGE_PATH

  install_name_tool -id "@rpath/libzstd.dylib" ${STAGE_PATH}/lib/libzstd.dylib

  pop_env
}

# function called after all the compile have been done
function postbuild_zstd() {
  verify_lib "libzstd.dylib"
}
