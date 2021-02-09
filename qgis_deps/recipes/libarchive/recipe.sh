#!/bin/bash

DESC_libarchive="Multi-format archive and compression library"

# version of your package
VERSION_libarchive=3.5.1

LINK_libarchive=libarchive.13.dylib

# dependencies of this recipe
DEPS_libarchive=(xz zstd bz2 expat zlib libiconv)

# url of the package
URL_libarchive=https://www.libarchive.org/downloads/libarchive-${VERSION_libarchive}.tar.xz

# md5 of the package
MD5_libarchive=1f8c29149832baff8bae232fd2f9b0ec

# default build path
BUILD_libarchive=$BUILD_PATH/libarchive/$(get_directory $URL_libarchive)

# default recipe path
RECIPE_libarchive=$RECIPES_PATH/libarchive

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libarchive() {
  cd $BUILD_libarchive

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_libarchive() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libarchive -nt $BUILD_libarchive/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libarchive() {
  try rsync -a $BUILD_libarchive/ $BUILD_PATH/libarchive/build-$ARCH/
  try cd $BUILD_PATH/libarchive/build-$ARCH
  push_env

  try ${CONFIGURE} \
           --without-lzo2 \
           --without-nettle \
           --without-xml2 \
           --without-openssl \
           --with-expat

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_libarchive() {
  verify_binary lib/$LINK_libarchive
}

# function to append information to config file
function add_config_info_libarchive() {
  append_to_config_file "# libarchive-${VERSION_libarchive}: ${DESC_libarchive}"
  append_to_config_file "export VERSION_libarchive=${VERSION_libarchive}"
  append_to_config_file "export LINK_libarchive=${LINK_libarchive}"
}
