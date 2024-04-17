#!/bin/bash

DESC_minizip="zip manipulation library written in C"

# version of your package
source $RECIPES_PATH/libkml/recipe.sh
source $RECIPES_PATH/zlib/recipe.sh
VERSION_minizip=1.3.0

LINK_libminizip=libminizip.dylib

# dependencies of this recipe
DEPS_minizip=(
 zlib
)

# url of the package
URL_minizip=http://sourceforge.net/projects/libkml-files/files/${VERSION_libkml}/minizip.tar.gz

# md5 of the package
MD5_minizip=d5f74eff74e03e497ea60b2c43623416

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