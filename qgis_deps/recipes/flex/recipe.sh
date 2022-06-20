#!/bin/bash

DESC_flex="Fast Lexical Analyzer, generates Scanners (tokenizers)"

LINK_flex_version=2

DEPS_flex=( bison )

# default build path
BUILD_flex=${DEPS_BUILD_PATH}/flex/$(get_directory $URL_flex)

# default recipe path
RECIPE_flex=$RECIPES_PATH/flex

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_flex() {
  cd $BUILD_flex
    patch_configure_file configure
  try rsync  -a $BUILD_flex/ ${DEPS_BUILD_PATH}/flex/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_flex() {
  verify_binary "lib/libfl.dylib"
}

# function to append information to config file
function add_config_info_flex() {
  append_to_config_file "# flex-${VERSION_flex}: ${DESC_flex}"
  append_to_config_file "export VERSION_flex=${VERSION_flex}"
}
