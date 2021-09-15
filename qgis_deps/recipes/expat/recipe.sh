#!/bin/bash

DESC_expat="XML 1.0 parser"

# version of your package
VERSION_expat=2.2.10
LINK_expat=libexpat.1.dylib

# dependencies of this recipe
DEPS_expat=()

# url of the package
URL_expat=https://github.com/libexpat/libexpat/releases/download/R_${VERSION_expat//./_}/expat-${VERSION_expat}.tar.xz

# md5 of the package
MD5_expat=e0fe49a6b3480827c9455e4cfc799133

# default build path
BUILD_expat=$BUILD_PATH/expat/$(get_directory $URL_expat)

# default recipe path
RECIPE_expat=$RECIPES_PATH/expat

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_expat() {
  cd $BUILD_expat

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_expat() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_expat -nt $BUILD_expat/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_expat() {
  try rsync -a $BUILD_expat/ $BUILD_PATH/expat/build-$ARCH/
  try cd $BUILD_PATH/expat/build-$ARCH
  push_env

  try ${CONFIGURE}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_expat() {
  verify_binary lib/$LINK_expat
}

# function to append information to config file
function add_config_info_expat() {
  append_to_config_file "# expat-${VERSION_expat}: ${DESC_expat}"
  append_to_config_file "export VERSION_expat=${VERSION_expat}"
  append_to_config_file "export LINK_expat=${LINK_expat}"
}
