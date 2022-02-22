#!/bin/bash

DESC_wxmac="Cross-platform C++ GUI toolkit (wxWidgets for macOS)"

VERSION_wxmac_major=3.1
LINK_wxmac_version=3.1.5.0.0

DEPS_wxmac=( jpeg png libtiff )


# md5 of the package

# default build path
BUILD_wxmac=${DEPS_BUILD_PATH}/wxmac/$(get_directory $URL_wxmac)

# default recipe path
RECIPE_wxmac=$RECIPES_PATH/wxmac

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_wxmac() {
  cd $BUILD_wxmac
    patch_configure_file configure
  try rsync   -a $BUILD_wxmac/ ${DEPS_BUILD_PATH}/wxmac/build-${ARCH}
}

function shouldbuild_wxmac() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libwx_baseu-${VERSION_wxmac_major}.dylib -nt $BUILD_wxmac/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_wxmac() {
  verify_binary lib/"libwx_baseu-${VERSION_wxmac_major}.dylib"
  verify_binary lib/"libwx_baseu_net-${VERSION_wxmac_major}.dylib"
  verify_binary lib/"libwx_baseu_xml-${VERSION_wxmac_major}.dylib"
  verify_binary lib/"libwx_osx_cocoau_html-${VERSION_wxmac_major}.dylib"
  verify_binary lib/"libwx_osx_cocoau_html-${LINK_wxmac_version}.dylib"
}

# function to append information to config file
function add_config_info_wxmac() {
  append_to_config_file "# wxmac-${VERSION_wxmac}: ${DESC_wxmac}"
  append_to_config_file "export VERSION_wxmac=${VERSION_wxmac}"
  append_to_config_file "export VERSION_wxmac_major=${VERSION_wxmac_major}"
  append_to_config_file "export LINK_wxmac_version=${LINK_wxmac_version}"
}