#!/bin/bash

DESC_uriparser="uriparser is a strictly RFC 3986 compliant URI parsing and handling library written in C89"

# version of your package
VERSION_uriparser=0.9.7

LINK_liburiparser=liburiparser.1.dylib

# dependencies of this recipe
DEPS_uriparser=()

# url of the package
URL_uriparser=https://github.com/uriparser/uriparser/archive/uriparser-$VERSION_uriparser.tar.gz

# md5 of the package
MD5_uriparser=5a8e579864fc43b418ebf45b159cbcc8

# default build path
BUILD_uriparser=$BUILD_PATH/uriparser/$(get_directory $URL_uriparser)

# default recipe path
RECIPE_uriparser=$RECIPES_PATH/uriparser

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_uriparser() {
  cd $BUILD_uriparser

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_uriparser() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_liburiparser} -nt $BUILD_uriparser/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_uriparser() {
  try mkdir -p $BUILD_PATH/uriparser/build-$ARCH
  try cd $BUILD_PATH/uriparser/build-$ARCH
  push_env

  try ${CMAKE} \
    -DURIPARSER_BUILD_DOCS=OFF \
    -DURIPARSER_BUILD_TESTS=OFF \
    $BUILD_uriparser

  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  install_name_tool -id $STAGE_PATH/lib/$LINK_liburiparser $STAGE_PATH/lib/$LINK_liburiparser
  try fix_install_name bin/uriparse

  pop_env
}

# function called after all the compile have been done
function postbuild_uriparser() {
  verify_binary lib/${LINK_liburiparser}
  verify_binary bin/uriparse
}

# function to append information to config file
function add_config_info_uriparser() {
  append_to_config_file "# uriparser-${VERSION_uriparser}: ${DESC_uriparser}"
  append_to_config_file "export VERSION_uriparser=${VERSION_uriparser}"
  append_to_config_file "export LINK_liburiparser=${LINK_liburiparser}"
}