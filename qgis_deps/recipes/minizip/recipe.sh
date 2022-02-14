#!/bin/bash

DESC_minizip="zip manipulation library written in C"

source $RECIPES_PATH/zlib/recipe.sh

# version of your package
VERSION_minizip=3.0.4

LINK_libminizip=libminizip.dylib

# dependencies of this recipe
DEPS_minizip=(zlib zstd)

# url of the package
URL_minizip=https://github.com/zlib-ng/minizip-ng/archive/refs/tags/${VERSION_minizip}.tar.gz

# md5 of the package
MD5_minizip=0e7102ec06a69895a26c491c6fcca983

# default build path
BUILD_minizip=$BUILD_PATH/minizip/$(get_directory $URL_minizip)

# default recipe path
RECIPE_minizip=$RECIPES_PATH/minizip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_minizip() {
  cd $BUILD_minizip

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_minizip() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_libminizip} -nt $BUILD_minizip/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_minizip() {
  try mkdir -p $BUILD_PATH/minizip/build-$ARCH
  try cd $BUILD_PATH/minizip/build-$ARCH
  push_env

  try ${CMAKE} \
    -DBUILD_SHARED_LIBS=ON \
    -DZLIB_INCLUDE_DIR=$STAGE_PATH/include \
    -DZLIB_LIBRARY=$STAGE_PATH/lib/$LINK_zlib \
    $BUILD_minizip

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  install_name_tool -id $STAGE_PATH/lib/$LINK_libminizip $STAGE_PATH/lib/$LINK_libminizip

  pop_env
}

# function called after all the compile have been done
function postbuild_minizip() {
  verify_binary lib/${LINK_libminizip}
}

# function to append information to config file
function add_config_info_minizip() {
  append_to_config_file "# minizip-${VERSION_minizip}: ${DESC_minizip}"
  append_to_config_file "export VERSION_minizip=${VERSION_minizip}"
  append_to_config_file "export LINK_libminizip=${LINK_libminizip}"
}