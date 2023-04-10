#!/bin/bash

DESC_libjsonc="JSON parser for C"

# version of your package
VERSION_libjsonc=0.16
VERSION_libjsonc_commit=d0f32a5a43d1b9dc0b2cd6af310e5f09b97c3423

LINK_libjsonc="libjson-c.5.dylib"

# dependencies of this recipe
DEPS_libjsonc=()

# url of the package
URL_libjsonc=https://github.com/json-c/json-c/archive/${VERSION_libjsonc_commit}.tar.gz

# md5 of the package
MD5_libjsonc=8390725e692bdcfb6b171387243f7649

# default build path
BUILD_libjsonc=$BUILD_PATH/libjsonc/$(get_directory $URL_libjsonc)

# default recipe path
RECIPE_libjsonc=$RECIPES_PATH/libjsonc


# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_libjsonc() {
  cd $BUILD_libjsonc

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

# function called before build_libjsonc
# set DO_BUILD=0 if you know that it does not require a rebuild
function shouldbuild_libjsonc() {
# If lib is newer than the sourcecode skip build
  if [ "${STAGE_PATH}/lib/$LINK_libjsonc" -nt $BUILD_libjsonc/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_libjsonc() {
  try mkdir -p $BUILD_PATH/libjsonc/build-$ARCH
  try cd $BUILD_PATH/libjsonc/build-$ARCH

  push_env

  try $CMAKE $BUILD_libjsonc .
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_jsonc $STAGE_PATH/lib/$LINK_libjsonc
  try install_name_tool -change $BUILD_PATH/libjsonc/build-$ARCH/$LINK_libjsonc $STAGE_PATH/lib/$LINK_libjsonc $STAGE_PATH/lib/$LINK_libjsonc

  pop_env
}

# function called after all the compile have been done
function postbuild_libjsonc() {
  verify_binary lib/$LINK_libjsonc
}

# function to append information to config file
function add_config_info_libjsonc() {
  append_to_config_file "# libjsonc-${VERSION_libjsonc}: ${DESC_libjsonc}"
  append_to_config_file "export VERSION_libjsonc=${VERSION_libjsonc}"
}