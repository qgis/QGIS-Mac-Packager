#!/bin/bash

DESC_wxmac="Cross-platform C++ GUI toolkit (wxWidgets for macOS)"

# version of your package
VERSION_wxmac_major=3.2
VERSION_wxmac=${VERSION_wxmac_major}.2.1
LINK_wxmac_version=3.2.0.2.1

# dependencies of this recipe
DEPS_wxmac=( pcre jpeg png libtiff )

# url of the package
URL_wxmac=https://github.com/wxWidgets/wxWidgets/releases/download/v${VERSION_wxmac}/wxWidgets-${VERSION_wxmac}.tar.bz2

# md5 of the package
MD5_wxmac=45bd5f56a06e7c4ca7caf6c0b4d5d506

# default build path
BUILD_wxmac=$BUILD_PATH/wxmac/$(get_directory $URL_wxmac)

# default recipe path
RECIPE_wxmac=$RECIPES_PATH/wxmac

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_wxmac() {
  cd $BUILD_wxmac

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_wxmac() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libwx_baseu-${VERSION_wxmac_major}.dylib -nt $BUILD_wxmac/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_wxmac() {
  try rsync -a $BUILD_wxmac/ $BUILD_PATH/wxmac/build-$ARCH/
  try cd $BUILD_PATH/wxmac/build-$ARCH
  push_env

  try ${CONFIGURE} \
     --enable-clipboard \
     --enable-controls \
     --enable-dataviewctrl \
     --enable-display \
     --enable-dnd \
     --enable-graphics_ctx \
     --enable-std_string \
     --enable-svg \
     --enable-unicode \
     --with-expat \
     --with-libjpeg \
     --with-libpng \
     --with-libtiff \
     --with-opengl \
     --with-osx_cocoa \
     --with-zlib \
     --disable-precomp-headers \
     --disable-monolithic \
     --with-macosx-version-min=${MACOSX_DEPLOYMENT_TARGET}


  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
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