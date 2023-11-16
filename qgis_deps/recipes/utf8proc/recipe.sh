#!/bin/bash

DESC_utf8proc="Compression/decompression library aiming for high speed"

# version of your package
VERSION_utf8proc=2.9.0
LINK_utf8proc_version=3
LINK_utf8proc=libutf8proc.${LINK_utf8proc_version}.dylib

# dependencies of this recipe
DEPS_utf8proc=()

# url of the package
URL_utf8proc=https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v${VERSION_utf8proc}.tar.gz

# md5 of the package
MD5_utf8proc=7e4ab708f463f99cc1da799726252e7c

# default build path
BUILD_utf8proc=$BUILD_PATH/utf8proc/$(get_directory $URL_utf8proc)

# default recipe path
RECIPE_utf8proc=$RECIPES_PATH/utf8proc

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_utf8proc() {
  cd $BUILD_utf8proc

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_utf8proc() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_utf8proc -nt $BUILD_utf8proc/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_utf8proc() {
  try cd $BUILD_utf8proc
  push_env

  try make install prefix=${STAGE_PATH}

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libutf8proc*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_utf8proc() {
  verify_binary lib/$LINK_utf8proc
}

# function to append information to config file
function add_config_info_utf8proc() {
  append_to_config_file "# utf8proc-${VERSION_utf8proc}: ${DESC_utf8proc}"
  append_to_config_file "export VERSION_utf8proc=${VERSION_utf8proc}"
  append_to_config_file "export LINK_utf8proc=${LINK_utf8proc}"
}