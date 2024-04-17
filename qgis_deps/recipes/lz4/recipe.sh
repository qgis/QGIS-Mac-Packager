#!/bin/bash

DESC_lz4="Extremely Fast Compression algorithm"

# version of your package
VERSION_lz4=1.9.4
LINK_lz4_version=1.9.4
LINK_lz4=liblz4.${LINK_lz4_version}.dylib

# dependencies of this recipe
DEPS_lz4=()

# url of the package
URL_lz4=https://github.com/lz4/lz4/archive/v${VERSION_lz4}.tar.gz

# md5 of the package
MD5_lz4=e9286adb64040071c5e23498bf753261

# default build path
BUILD_lz4=$BUILD_PATH/lz4/$(get_directory $URL_lz4)

# default recipe path
RECIPE_lz4=$RECIPES_PATH/lz4

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_lz4() {
  cd $BUILD_lz4

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_lz4() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_lz4 -nt $BUILD_lz4/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_lz4() {
  try cd $BUILD_lz4
  push_env

  try make install prefix=${STAGE_PATH}

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/liblz4*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done
  pop_env
}

# function called after all the compile have been done
function postbuild_lz4() {
  verify_binary lib/$LINK_lz4
}

# function to append information to config file
function add_config_info_lz4() {
  append_to_config_file "# lz4-${VERSION_lz4}: ${DESC_lz4}"
  append_to_config_file "export VERSION_lz4=${VERSION_lz4}"
  append_to_config_file "export LINK_lz4=${LINK_lz4}"
}