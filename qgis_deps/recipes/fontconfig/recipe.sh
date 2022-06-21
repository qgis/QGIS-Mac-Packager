#!/bin/bash

DESC_fontconfig="fontconfig"


LINK_fontconfig=libfontconfig.1.dylib

DEPS_fontconfig=(python libtool gettext freetype png brotli)

# default build path
BUILD_fontconfig=${DEPS_BUILD_PATH}/fontconfig/$(get_directory $URL_fontconfig)

# default recipe path
RECIPE_fontconfig=$RECIPES_PATH/fontconfig


# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_fontconfig() {
  cd $BUILD_fontconfig
  patch_configure_file configure
  try rsync -a $BUILD_fontconfig/ ${DEPS_BUILD_PATH}/fontconfig/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_fontconfig() {
  verify_binary lib/$LINK_fontconfig
}

# function to append information to config file
function add_config_info_fontconfig() {
  append_to_config_file "# fontconfig-${VERSION_fontconfig}: ${DESC_fontconfig}"
  append_to_config_file "export VERSION_fontconfig=${VERSION_fontconfig}"
  append_to_config_file "export LINK_fontconfig=${LINK_fontconfig}"
}