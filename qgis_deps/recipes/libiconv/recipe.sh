#!/bin/bash

DESC_libiconv="Conversion library"

# version of your package
VERSION_libiconv=1.16

LINK_libiconv=libiconv.2.dylib

# dependencies of this recipe
DEPS_libiconv=()

# url of the package
URL_libiconv=https://ftp.gnu.org/gnu/libiconv/libiconv-$VERSION_libiconv.tar.gz

# md5 of the package
MD5_libiconv=7d2a800b952942bb2880efb00cfd524c

# default build path
BUILD_libiconv=$BUILD_PATH/libiconv/$(get_directory $URL_libiconv)

# default recipe path
RECIPE_libiconv=$RECIPES_PATH/libiconv

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libiconv() {
  cd $BUILD_libiconv

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_libiconv() {
  if [ ${STAGE_PATH}/lib/${LINK_libiconv} -nt $BUILD_libiconv/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libiconv() {
  try rsync -a $BUILD_libiconv/ $BUILD_PATH/libiconv/build-$ARCH/
  try cd $BUILD_PATH/libiconv/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug \
    --disable-dependency-tracking \
    --enable-extra-encodings

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_libiconv() {
  verify_binary lib/$LINK_libiconv
}

# function to append information to config file
function add_config_info_libiconv() {
  append_to_config_file "# libiconv-${VERSION_libiconv}: ${DESC_libiconv}"
  append_to_config_file "export VERSION_libiconv=${VERSION_libiconv}"
  append_to_config_file "export LINK_libiconv=${LINK_libiconv}"
}