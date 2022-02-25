#!/bin/bash

DESC_flex="Fast Lexical Analyzer, generates Scanners (tokenizers)"

# version of your package
VERSION_flex=2.6.4
LINK_flex_version=2

# dependencies of this recipe
DEPS_flex=( bison )

# url of the package
URL_flex=https://github.com/westes/flex/releases/download/v${VERSION_flex}/flex-${VERSION_flex}.tar.gz

# md5 of the package
MD5_flex=2882e3179748cc9f9c23ec593d6adc8d

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

function shouldbuild_flex() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libfl.dylib -nt $BUILD_flex/.patched ]; then
    DO_BUILD=0
  fi
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
