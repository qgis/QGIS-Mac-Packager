#!/bin/bash

DESC_libtiff="TIFF library and utilities"

# version of your package
VERSION_libtiff=4.1.0

LINK_libtiff_version=5

# dependencies of this recipe
DEPS_libtiff=(xz zstd webp jpeg)

# url of the package
URL_libtiff=http://download.osgeo.org/libtiff/tiff-${VERSION_libtiff}.tar.gz

# md5 of the package
MD5_libtiff=2165e7aba557463acc0664e71a3ed424

# default build path
BUILD_libtiff=$BUILD_PATH/libtiff/$(get_directory $URL_libtiff)

# default recipe path
RECIPE_libtiff=$RECIPES_PATH/libtiff


# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtiff() {
  cd $BUILD_libtiff

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

# function called before build_libtiff
# set DO_BUILD=0 if you know that it does not require a rebuild
function shouldbuild_libtiff() {
# If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/libtiff.dylib" -nt $BUILD_libtiff/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libtiff() {
  try rsync -a $BUILD_libtiff/ $BUILD_PATH/libtiff/build-$ARCH/
  try cd $BUILD_PATH/libtiff/build-$ARCH

  push_env

  try ${CONFIGURE} \
      --disable-debug \
      --disable-dependency-tracking \
      --disable-lzma \
      --with-jpeg-include-dir=$STAGE_PATH/include \
      --with-jpeg-lib-dir=$STAGE_PATH/lib \
      --without-x

  check_file_configuration config.status

  try $MAKESMP
  try $MAKE install

  pop_env
}

# function called after all the compile have been done
function postbuild_libtiff() {
  verify_lib "libtiff.dylib"
  verify_lib "libtiffxx.dylib"

  verify_bin tiffsplit
}

# function to append information to config file
function add_config_info_libtiff() {
  append_to_config_file "# libtiff-${VERSION_libtiff}: ${DESC_libtiff}"
  append_to_config_file "export VERSION_libtiff=${VERSION_libtiff}"
}