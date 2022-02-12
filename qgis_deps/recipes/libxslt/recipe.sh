#!/bin/bash

DESC_libxslt="C XSLT library for GNOME"

# version of your package
VERSION_libxslt=1.1.34
LINK_libxslt=libxslt.1.dylib
LINK_libexslt=libexslt.0.dylib

# dependencies of this recipe
DEPS_libxslt=(libxml2)

# url of the package
URL_libxslt=http://xmlsoft.org/sources/libxslt-${VERSION_libxslt}.tar.gz

# md5 of the package
MD5_libxslt=db8765c8d076f1b6caafd9f2542a304a

# default build path
BUILD_libxslt=$BUILD_PATH/libxslt/$(get_directory $URL_libxslt)

# default recipe path
RECIPE_libxslt=$RECIPES_PATH/libxslt

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libxslt() {
  cd $BUILD_libxslt

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_libxslt() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_libxslt -nt $BUILD_libxslt/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libxslt() {
  try rsync -a $BUILD_libxslt/ $BUILD_PATH/libxslt/build-$ARCH/
  try cd $BUILD_PATH/libxslt/build-$ARCH
  push_env

  patch_configure_file configure

  try ${CONFIGURE} \
    --disable-silent-rules \
    --disable-dependency-tracking \
    --without-python \
    --with-libxml-prefix=${STAGE_PATH} \
    --with-libxml-include-prefix=${STAGE_PATH} \
    --with-libxml-libs-prefix=${STAGE_PATH}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_libxslt() {
  verify_binary lib/$LINK_libxslt
  verify_binary lib/libexslt.dylib
}

# function to append information to config file
function add_config_info_libxslt() {
  append_to_config_file "# libxslt-${VERSION_libxslt}: ${DESC_libxslt}"
  append_to_config_file "export VERSION_libxslt=${VERSION_libxslt}"
  append_to_config_file "export LINK_libxslt=${LINK_libxslt}"
  append_to_config_file "export LINK_libexslt=${LINK_libexslt}"
}