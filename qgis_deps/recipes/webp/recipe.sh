#!/bin/bash

DESC_webp="Image format providing lossless and lossy compression for web images"

# version of your package
VERSION_webp=1.3.0

LINK_libwebp=libwebp.7.dylib
LINK_libwebpdemux=libwebpdemux.2.dylib

# dependencies of this recipe
DEPS_webp=(png)

# url of the package
URL_webp=https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${VERSION_webp}.tar.gz

# md5 of the package
MD5_webp=994cf2efb664ef5140fa0b56b83fa721

# default build path
BUILD_webp=$BUILD_PATH/webp/$(get_directory $URL_webp)

# default recipe path
RECIPE_webp=$RECIPES_PATH/webp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_webp() {
  cd $BUILD_webp

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_webp() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libwebp -nt $BUILD_webp/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_webp() {
  try rsync -a $BUILD_webp/ $BUILD_PATH/webp/build-$ARCH/
  try cd $BUILD_PATH/webp/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_webp() {
  verify_binary lib/$LINK_libwebp
  verify_binary lib/$LINK_libwebpdemux
  verify_binary bin/dwebp
}

# function to append information to config file
function add_config_info_webp() {
  append_to_config_file "# webp-${VERSION_webp}: ${DESC_webp}"
  append_to_config_file "export VERSION_webp=${VERSION_webp}"
  append_to_config_file "export LINK_libwebp=${LINK_libwebp}"
  append_to_config_file "export LINK_libwebpdemux=${LINK_libwebpdemux}"
}