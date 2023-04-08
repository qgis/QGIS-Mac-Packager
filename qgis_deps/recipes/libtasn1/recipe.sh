#!/bin/bash

DESC_libtasn1="ASN.1 structure parser library"

# version of your package
VERSION_libtasn1=4.16.0

LINK_libtasn1=libtasn1.6.dylib

# dependencies of this recipe
DEPS_libtasn1=(gettext)

# url of the package
URL_libtasn1=https://ftp.gnu.org/gnu/libtasn1/libtasn1-${VERSION_libtasn1}.tar.gz

# md5 of the package
MD5_libtasn1=531208de3729d42e2af0a32890f08736

# default build path
BUILD_libtasn1=$BUILD_PATH/libtasn1/$(get_directory $URL_libtasn1)

# default recipe path
RECIPE_libtasn1=$RECIPES_PATH/libtasn1

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libtasn1() {
  cd $BUILD_libtasn1

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_libtasn1() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libtasn1 -nt $BUILD_libtasn1/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libtasn1() {
  try rsync -a $BUILD_libtasn1/ $BUILD_PATH/libtasn1/build-$ARCH/
  try cd $BUILD_PATH/libtasn1/build-$ARCH
  push_env

  export CFLAGS="$CFLAGS -O2 -DPIC"
  patch_configure_file configure

  try ${CONFIGURE} --disable-debug

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_libtasn1() {
  verify_binary lib/$LINK_libtasn1
}

# function to append information to config file
function add_config_info_libtasn1() {
  append_to_config_file "# libtasn1-${VERSION_libtasn1}: ${DESC_libtasn1}"
  append_to_config_file "export VERSION_libtasn1=${VERSION_libtasn1}"
  append_to_config_file "export LINK_libtasn1=${LINK_libtasn1}"
}