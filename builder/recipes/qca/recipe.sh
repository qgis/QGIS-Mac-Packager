#!/bin/bash

# version of your package
VERSION_qca=2.1.3

# dependencies of this recipe
DEPS_qca=()

# url of the package
URL_qca=https://github.com/KDE/qca/archive/v${VERSION_qca}.tar.gz

# md5 of the package
MD5_qca=bd646d08fdc1d9be63331a836ecd528f

# default build path
BUILD_qca=$BUILD_PATH/qca/$(get_directory $URL_qca)

# default recipe path
RECIPE_qca=$RECIPES_PATH/qca

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qca() {
  cd $BUILD_qca

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_qca() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5 -nt $BUILD_qca/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_qca() {
  try mkdir -p $BUILD_PATH/qca/build-$ARCH
  try cd $BUILD_PATH/qca/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_qca
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_qca() {
  verify_lib "${STAGE_PATH}/lib/qca-qt5.framework/Versions/${VERSION_qca}/qca-qt5"
}
