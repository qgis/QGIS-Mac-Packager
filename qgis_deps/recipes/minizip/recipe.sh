#!/bin/bash

DESC_minizip="zip manipulation library written in C"

source $RECIPES_PATH/libkml/recipe.sh
source $RECIPES_PATH/zlib/recipe.sh

LINK_libminizip=libminizip.dylib

DEPS_minizip=(
 zlib
)

# default build path
BUILD_minizip=${DEPS_BUILD_PATH}/minizip/$(get_directory $URL_minizip)

# default recipe path
RECIPE_minizip=$RECIPES_PATH/minizip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_minizip() {
  cd $BUILD_minizip
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