#!/bin/bash

DESC_jpeg="Image manipulation library"

# version of your package
VERSION_jpeg=9d

LINK_jpeg_version=9

# dependencies of this recipe
DEPS_jpeg=()

# url of the package
URL_jpeg=https://www.ijg.org/files/jpegsrc.v${VERSION_jpeg}.tar.gz

# md5 of the package
MD5_jpeg=693a4e10906e66467ca21f045547fe15

# default build path
BUILD_jpeg=$BUILD_PATH/jpeg/$(get_directory $URL_jpeg)

# default recipe path
RECIPE_jpeg=$RECIPES_PATH/jpeg

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_jpeg() {
  cd $BUILD_jpeg

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_jpeg() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libjpeg.dylib -nt $BUILD_jpeg/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_jpeg() {
  try rsync -a $BUILD_jpeg/ $BUILD_PATH/jpeg/build-$ARCH/
  try cd $BUILD_PATH/jpeg/build-$ARCH
  push_env

  try ${CONFIGURE} \
    --disable-debug

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_jpeg() {
  verify_lib "libjpeg.dylib"
}

# function to append information to config file
function add_config_info_jpeg() {
  append_to_config_file "# jpeg-${VERSION_jpeg}: ${DESC_jpeg}"
  append_to_config_file "export VERSION_jpeg=${VERSION_jpeg}"
}