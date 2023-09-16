#!/bin/bash

DESC_rapidjson="JSON parser/generator for C++ with SAX and DOM style APIs"

# version of your package
VERSION_rapidjson=1.1.0
LINK_rapidjson_version=1.1.0
LINK_rapidjson=

# dependencies of this recipe
DEPS_rapidjson=()

# url of the package
URL_rapidjson=https://github.com/Tencent/rapidjson/archive/v${VERSION_rapidjson}.tar.gz

# md5 of the package
MD5_rapidjson=52b9786ca6fbc679869fee2b6fef25a5

# default build path
BUILD_rapidjson=$BUILD_PATH/rapidjson/$(get_directory $URL_rapidjson)

# default recipe path
RECIPE_rapidjson=$RECIPES_PATH/rapidjson

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_rapidjson() {
  cd $BUILD_rapidjson

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_rapidjson() {
  # If lib is newer than the sourcecode skip build
  if [ -nt $BUILD_glog/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_rapidjson() {
  try mkdir -p $BUILD_PATH/rapidjson/build-$ARCH
  try cd $BUILD_PATH/rapidjson/build-$ARCH
  push_env

  try ${CMAKE} \
    $BUILD_rapidjson
  check_file_configuration CMakeCache.txt

  # try $NINJA
  try $NINJA install

  pop_env
}

# # function called after all the compile have been done
# function postbuild_rapidjson() {
#   # nothing to do
# }

# function to append information to config file
function add_config_info_rapidjson() {
  append_to_config_file "# rapidjson-${VERSION_rapidjson}: ${DESC_rapidjson}"
  append_to_config_file "export VERSION_rapidjson=${VERSION_rapidjson}"
}