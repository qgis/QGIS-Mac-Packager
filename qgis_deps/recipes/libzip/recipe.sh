#!/bin/bash

DESC_libzip="C library for reading, creating, and modifying zip archives"

# version of your package
VERSION_libzip=1.6.1

LINK_libzip=libzip.5.dylib

# dependencies of this recipe
DEPS_libzip=( zlib xz openssl )

# url of the package
URL_libzip=https://libzip.org/download/libzip-${VERSION_libzip}.tar.xz

# md5 of the package
MD5_libzip=f9a228619aab2446addc9c9e0e2de149

# default build path
BUILD_libzip=$BUILD_PATH/libzip/$(get_directory $URL_libzip)

# default recipe path
RECIPE_libzip=$RECIPES_PATH/libzip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libzip() {
  cd $BUILD_libzip

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_libzip() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_libzip} -nt $BUILD_libzip/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libzip() {
  try mkdir -p $BUILD_PATH/libzip/build-$ARCH
  try cd $BUILD_PATH/libzip/build-$ARCH
  push_env

  # see issue #38: with ENABLE_GNUTLS it requires nette library
  try ${CMAKE} \
    -DENABLE_GNUTLS=FALSE \
    -DCMAKE_DISABLE_FIND_PACKAGE_NETTLE=TRUE \
    $BUILD_libzip

  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  try install_name_tool -change $BUILD_PATH/libzip/build-$ARCH/lib/$LINK_libzip $STAGE_PATH/lib/$LINK_libzip $STAGE_PATH/bin/ziptool

  pop_env
}

# function called after all the compile have been done
function postbuild_libzip() {
  verify_binary lib/$LINK_libzip
  verify_binary bin/ziptool
}

# function to append information to config file
function add_config_info_libzip() {
  append_to_config_file "# libzip-${VERSION_libzip}: ${DESC_libzip}"
  append_to_config_file "export VERSION_libzip=${VERSION_libzip}"
  append_to_config_file "export LINK_libzip=${LINK_libzip}"
}