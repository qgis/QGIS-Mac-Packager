#!/bin/bash

DESC_libffi="libffi: Portable Foreign Function Interface library"

# version of your package
VERSION_libffi=3.2.1

# dependencies of this recipe
DEPS_libffi=()

LINK_libffi_version=6

# url of the package
URL_libffi=https://sourceware.org/pub/libffi/libffi-${VERSION_libffi}.tar.gz

# md5 of the package
MD5_libffi=83b89587607e3eb65c70d361f13bab43

# default build path
BUILD_libffi=$BUILD_PATH/libffi/$(get_directory $URL_libffi)

# default recipe path
RECIPE_libffi=$RECIPES_PATH/libffi

patch_libffi_linker_links () {
  install_name_tool -id "@rpath/libffi.dylib" ${STAGE_PATH}/lib/libffi.dylib
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libffi() {
  cd $BUILD_libffi

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_libffi() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libffi.dylib -nt $BUILD_libffi/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libffi() {
  try rsync -a $BUILD_libffi/ $BUILD_PATH/libffi/build-$ARCH/
  try cd $BUILD_PATH/libffi/build-$ARCH
  push_env


  try ${CONFIGURE} \
    --disable-debug

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  patch_libffi_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_libffi() {
  verify_lib "libffi.dylib"
}
