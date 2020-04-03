#!/bin/bash

DESC_proj="Cartographic Projections Library"

# version of your package
VERSION_proj=6.3.1

LINK_libproj=libproj.18.dylib

# dependencies of this recipe
DEPS_proj=()

# url of the package
URL_proj=https://github.com/OSGeo/PROJ/releases/download/$VERSION_proj/proj-$VERSION_proj.tar.gz

# md5 of the package
MD5_proj=c44c694cf569a74880e5fbac566d54d6

# default build path
BUILD_proj=$BUILD_PATH/proj/$(get_directory $URL_proj)

# default recipe path
RECIPE_proj=$RECIPES_PATH/proj

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_proj() {
  cd $BUILD_proj

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_proj() {
  if [ ${STAGE_PATH}/lib/${LINK_libproj} -nt $BUILD_proj/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_proj() {
  try mkdir -p $BUILD_PATH/proj/build-$ARCH
  try cd $BUILD_PATH/proj/build-$ARCH

  push_env

  try $CMAKE $BUILD_proj .
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKE install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libproj $STAGE_PATH/lib/$LINK_libproj
  try install_name_tool -change $BUILD_PATH/proj/build-$ARCH/lib/$LINK_libproj $STAGE_PATH/lib/$LINK_libproj $STAGE_PATH/bin/proj

  pop_env
}

# function called after all the compile have been done
function postbuild_proj() {
  verify_binary lib/$LINK_libproj

  verify_binary bin/proj
}

# function to append information to config file
function add_config_info_proj() {
  append_to_config_file "# proj-${VERSION_proj}: ${DESC_proj}"
  append_to_config_file "export VERSION_proj=${VERSION_proj}"
  append_to_config_file "export LINK_libproj=${LINK_libproj}"
}