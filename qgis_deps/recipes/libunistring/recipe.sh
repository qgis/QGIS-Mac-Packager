#!/bin/bash

DESC_libunistring="C string library for manipulating Unicode strings"

# version of your package
VERSION_libunistring=1.1

LINK_libunistring=libunistring.5.dylib

# dependencies of this recipe
DEPS_libunistring=()

# url of the package
URL_libunistring=https://ftp.gnu.org/gnu/libunistring/libunistring-$VERSION_libunistring.tar.xz

# md5 of the package
MD5_libunistring=0dfba19989ae06b8e7a49a7cd18472a1

# default build path
BUILD_libunistring=$BUILD_PATH/libunistring/$(get_directory $URL_libunistring)

# default recipe path
RECIPE_libunistring=$RECIPES_PATH/libunistring

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libunistring() {
  cd $BUILD_libunistring

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_libunistring() {
  if [ ${STAGE_PATH}/lib/${LINK_libunistring} -nt $BUILD_libunistring/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libunistring() {
  try rsync -a $BUILD_libunistring/ $BUILD_PATH/libunistring/build-$ARCH/
  try cd $BUILD_PATH/libunistring/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-dependency-tracking \
    --disable-silent-rules

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_libunistring() {
  verify_binary lib/$LINK_libunistring
}

# function to append information to config file
function add_config_info_libunistring() {
  append_to_config_file "# libunistring-${VERSION_libunistring}: ${DESC_libunistring}"
  append_to_config_file "export VERSION_libunistring=${VERSION_libunistring}"
  append_to_config_file "export LINK_libunistring=${LINK_libunistring}"
}