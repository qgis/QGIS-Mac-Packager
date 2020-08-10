#!/bin/bash

DESC_geos="Geometry Engine"

# version of your package
VERSION_geos=3.8.1

LINK_libgeos_c=libgeos_c.1.dylib
LINK_libgeos=libgeos.${VERSION_geos}.dylib

# dependencies of this recipe
DEPS_geos=()

# url of the package
URL_geos=http://download.osgeo.org/geos/geos-${VERSION_geos}.tar.bz2

# md5 of the package
MD5_geos=9d25df02a2c4fcc5a59ac2fb3f0bd977

# default build path
BUILD_geos=$BUILD_PATH/geos/$(get_directory $URL_geos)

# default recipe path
RECIPE_geos=$RECIPES_PATH/geos

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_geos() {
  cd $BUILD_geos

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_geos() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/${LINK_libgeos_c} -nt $BUILD_geos/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_geos() {
  try mkdir -p $BUILD_PATH/geos/build-$ARCH
  try cd $BUILD_PATH/geos/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_geos
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  try install_name_tool -id $STAGE_PATH/lib/$LINK_libgeos $STAGE_PATH/lib/$LINK_libgeos
  try install_name_tool -id $STAGE_PATH/lib/$LINK_libgeos_c $STAGE_PATH/lib/$LINK_libgeos_c
  try install_name_tool -change $BUILD_PATH/geos/build-$ARCH/lib/$LINK_libgeos $STAGE_PATH/lib/$LINK_libgeos $STAGE_PATH/lib/$LINK_libgeos_c

  pop_env
}

# function called after all the compile have been done
function postbuild_geos() {
  verify_binary lib/${LINK_libgeos_c}
  verify_binary lib/${LINK_libgeos}
}

# function to append information to config file
function add_config_info_geos() {
  append_to_config_file "# geos-${VERSION_geos}: ${DESC_geos}"
  append_to_config_file "export VERSION_geos=${VERSION_geos}"
  append_to_config_file "export LINK_libgeos_c=${LINK_libgeos_c}"
  append_to_config_file "export LINK_libgeos=${LINK_libgeos}"
}