#!/bin/bash

# http://xerces.apache.org/xerces-c/index.html
# Xerces-C++ is a validating XML parser written in a portable subset of C++.

# version of your package
VERSION_xerces=3.2.2

# dependencies of this recipe
DEPS_xerces=()

# url of the package
URL_xerces=http://mirror.hosting90.cz/apache//xerces/c/3/sources/xerces-c-${VERSION_xerces}.tar.gz

# md5 of the package
MD5_xerces=7aac41029b0d7a5eadd31cc975b391c2

# default build path
BUILD_xerces=$BUILD_PATH/xerces/$(get_directory $URL_xerces)

# default recipe path
RECIPE_xerces=$RECIPES_PATH/xerces

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_xerces() {
  cd $BUILD_xerces

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_xerces() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libxerces-c.so -nt $BUILD_xerces/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_xerces() {
  try mkdir -p $BUILD_PATH/xerces/build-$ARCH
  try cd $BUILD_PATH/xerces/build-$ARCH
  push_env

  try $CMAKE $BUILD_xerces .
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_xerces() {
  verify_lib "libxerces-c.so"
}
