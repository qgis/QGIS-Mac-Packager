#!/bin/bash

DESC_libzip="C library for reading, creating, and modifying zip archives"

# version of your package
VERSION_libzip=1.6.1

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

patch_zip_linker_links () {
  targets=(
    bin/zipcmp
    bin/zipmerge
    bin/ziptool
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -delete_rpath $BUILD_PATH/libzip/build-$ARCH/lib ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}

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
  if [ ${STAGE_PATH}/lib/libzip.dylib -nt $BUILD_libzip/.patched ]; then
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
    ENABLE_GNUTLS=FALSE \
    $BUILD_libzip

  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  patch_zip_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_libzip() {
  verify_lib "libzip.dylib"
  verify_bin ziptool
}

# function to append information to config file
function add_config_info_libzip() {
  append_to_config_file "# libzip-${VERSION_libzip}: ${DESC_libzip}"
  append_to_config_file "export VERSION_libzip=${VERSION_libzip}"
}