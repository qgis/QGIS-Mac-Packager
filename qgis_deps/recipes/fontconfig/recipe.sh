#!/bin/bash

DESC_fontconfig="fontconfig"

# version of your package
VERSION_fontconfig=2.14.2

LINK_fontconfig=libfontconfig.1.dylib

# dependencies of this recipe
DEPS_fontconfig=(python libtool gettext freetype png brotli libjsonc)

# url of the package
URL_fontconfig=https://www.freedesktop.org/software/fontconfig/release/fontconfig-$VERSION_fontconfig.tar.gz

# md5 of the package
MD5_fontconfig=c5536d897c5d52422a00ecee742ccf47

# default build path
BUILD_fontconfig=$BUILD_PATH/fontconfig/$(get_directory $URL_fontconfig)

# default recipe path
RECIPE_fontconfig=$RECIPES_PATH/fontconfig


# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_fontconfig() {
  cd $BUILD_fontconfig

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

# function called before build_fontconfig
# set DO_BUILD=0 if you know that it does not require a rebuild
function shouldbuild_fontconfig() {
# If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/$LINK_fontconfig" -nt $BUILD_fontconfig/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_fontconfig() {
  try rsync -a $BUILD_fontconfig/ $BUILD_PATH/fontconfig/build-$ARCH/
  try cd $BUILD_PATH/fontconfig/build-$ARCH

  push_env

  export LIBTOOLIZE="glibtoolize"
  export GETTEXTIZE="ggettextize"
  export AUTOPOINT="gautopoint"
  export PKG_CONFIG_PATH=$STAGE_PATH/lib/pkgconfig

  try ${CONFIGURE}

  check_file_configuration config.status

  try $MAKESMP
  try $MAKE install RUN_FC_CACHE_TEST=false

  unset LIBTOOLIZE
  unset GETTEXTIZE
  unset AUTOPOINT
  unset PKG_CONFIG_PATH

  pop_env
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