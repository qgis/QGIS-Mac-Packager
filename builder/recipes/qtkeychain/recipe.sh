#!/bin/bash

# version of your package
VERSION_qtkeychain=0.10.0

# dependencies of this recipe
DEPS_qtkeychain=()

# url of the package
URL_qtkeychain=https://github.com/frankosterfeld/qtkeychain/archive/v${VERSION_qtkeychain}.tar.gz

# md5 of the package
MD5_qtkeychain=00856441d995146b11fb8cfab87b8bc6

# default build path
BUILD_qtkeychain=$BUILD_PATH/qtkeychain/$(get_directory $URL_qtkeychain)

# default recipe path
RECIPE_qtkeychain=$RECIPES_PATH/qtkeychain

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qtkeychain() {
  cd $BUILD_qtkeychain

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_qtkeychain() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libqt5keychain.dylib -nt $BUILD_qtkeychain/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_qtkeychain() {
  try mkdir -p $BUILD_PATH/qtkeychain/build-$ARCH
  try cd $BUILD_PATH/qtkeychain/build-$ARCH
  push_env

  try ${CMAKE} \
    -DQTKEYCHAIN_STATIC=OFF \
    -DBUILD_WITH_QT4=OFF \
    -DBUILD_TRANSLATIONS=OFF \
    $BUILD_qtkeychain

  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_qtkeychain() {
  verify_lib "${STAGE_PATH}/lib/libqt5keychain.dylib"
}
