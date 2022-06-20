#!/bin/bash

DESC_lerc="Limited Error Raster Compression"


LINK_liblerc=libLerc.dylib

DEPS_lerc=()

# default build path
BUILD_lerc=${DEPS_BUILD_PATH}/lerc/$(get_directory $URL_lerc)

# default recipe path
RECIPE_lerc=$RECIPES_PATH/lerc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_lerc() {
  cd $BUILD_lerc
}

# function called after all the compile have been done
function postbuild_lerc() {
  verify_binary lib/$LINK_liblerc
}

# function to append information to config file
function add_config_info_lerc() {
  append_to_config_file "# lerc-${VERSION_lerc}: ${DESC_lerc}"
  append_to_config_file "export VERSION_lerc=${VERSION_lerc}"
  append_to_config_file "export LINK_liblerc=${LINK_liblerc}"
}