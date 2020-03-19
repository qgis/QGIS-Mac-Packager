#!/bin/bash

# version of your package
VERSION_exiv2=0.27.2

# dependencies of this recipe
DEPS_exiv2=()

# url of the package
URL_exiv2=https://www.exiv2.org/builds/exiv2-${VERSION_exiv2}-Source.tar.gz

# md5 of the package
MD5_exiv2=8c39c39dc8141bb158e8e9d663bcbf21

# default build path
BUILD_exiv2=$BUILD_PATH/exiv2/$(get_directory $URL_exiv2)

# default recipe path
RECIPE_exiv2=$RECIPES_PATH/exiv2

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_exiv2() {
  cd $BUILD_exiv2

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_exiv2() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libexiv2.dylib -nt $BUILD_exiv2/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_exiv2() {
  try mkdir -p $BUILD_PATH/exiv2/build-$ARCH
  try cd $BUILD_PATH/exiv2/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_exiv2
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_exiv2() {
  verify_lib "${STAGE_PATH}/lib/libexiv2.dylib"
}
