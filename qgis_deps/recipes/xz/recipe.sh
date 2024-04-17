#!/bin/bash

DESC_xz="General-purpose data compression with high compression ratio"

# version of your package
VERSION_xz=5.4.2

LINK_liblzma=liblzma.5.dylib

# dependencies of this recipe
DEPS_xz=(gettext)

# url of the package
URL_xz=https://downloads.sourceforge.net/project/lzmautils/xz-${VERSION_xz}.tar.gz

# md5 of the package
MD5_xz=4ac4e5da95aa8604a81e32079cb00d42

# default build path
BUILD_xz=$BUILD_PATH/xz/$(get_directory $URL_xz)

# default recipe path
RECIPE_xz=$RECIPES_PATH/xz

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_xz() {
  cd $BUILD_xz

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_xz() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_liblzma -nt $BUILD_xz/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_xz() {
  try rsync -a $BUILD_xz/ $BUILD_PATH/xz/build-$ARCH/
  try cd $BUILD_PATH/xz/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-debug

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_xz() {
  verify_binary lib/$LINK_liblzma

  verify_binary bin/lzmainfo
  verify_binary bin/xzdec
}

# function to append information to config file
function add_config_info_xz() {
  append_to_config_file "# xz-${VERSION_xz}: ${DESC_xz}"
  append_to_config_file "export VERSION_xz=${VERSION_xz}"
  append_to_config_file "export LINK_liblzma=${LINK_liblzma}"
}