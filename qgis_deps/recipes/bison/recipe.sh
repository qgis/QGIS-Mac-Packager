#!/bin/bash

DESC_bison="Parser generator"

# version of your package
VERSION_bison=3.5.3

# dependencies of this recipe
DEPS_bison=()

# url of the package
URL_bison=https://ftp.gnu.org/gnu/bison/bison-${VERSION_bison}.tar.xz

# md5 of the package
MD5_bison=f556fdd6df5ebf0c61720928811d2986

# default build path
BUILD_bison=$BUILD_PATH/bison/$(get_directory $URL_bison)

# default recipe path
RECIPE_bison=$RECIPES_PATH/bison

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_bison() {
  cd $BUILD_bison

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_bison() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/bin/bison -nt $BUILD_bison/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_bison() {
  try rsync -a $BUILD_bison/ $BUILD_PATH/bison/build-$ARCH/
  try cd $BUILD_PATH/bison/build-$ARCH
  push_env

  try ${CONFIGURE} --disable-dependency-tracking

  check_file_configuration config.status

  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_bison() {
  verify_bin bison
}

# function to append information to config file
function add_config_info_bison() {
  append_to_config_file "# bison-${VERSION_bison}: ${DESC_bison}"
  append_to_config_file "export VERSION_bison=${VERSION_bison}"
}