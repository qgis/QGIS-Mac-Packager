#!/bin/bash

DESC_gflags="Library for processing command-line flags"

# version of your package
VERSION_gflags=2.2.2
LINK_gflags_version=2.2.2
LINK_gflags=libgflags.${LINK_gflags_version}.dylib

# dependencies of this recipe
DEPS_gflags=()

# url of the package
URL_gflags=https://github.com/gflags/gflags/archive/v${VERSION_gflags}.tar.gz

# md5 of the package
MD5_gflags=1a865b93bacfa963201af3f75b7bd64c

# default build path
BUILD_gflags=$BUILD_PATH/gflags/$(get_directory $URL_gflags)

# default recipe path
RECIPE_gflags=$RECIPES_PATH/gflags

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_gflags() {
  cd $BUILD_gflags

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_gflags() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_gflags -nt $BUILD_gflags/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_gflags() {
  try mkdir -p $BUILD_PATH/gflags/build-$ARCH
  try cd $BUILD_PATH/gflags/build-$ARCH
  push_env

  try ${CMAKE} \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_STATIC_LIBS=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    $BUILD_gflags
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libgflags*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_gflags() {
  verify_binary lib/$LINK_gflags
}

# function to append information to config file
function add_config_info_gflags() {
  append_to_config_file "# gflags-${VERSION_gflags}: ${DESC_gflags}"
  append_to_config_file "export VERSION_gflags=${VERSION_gflags}"
  append_to_config_file "export LINK_gflags=${LINK_gflags}"
}