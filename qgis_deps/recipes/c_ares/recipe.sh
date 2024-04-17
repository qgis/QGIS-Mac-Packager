#!/bin/bash

DESC_c_ares="Asynchronous DNS library"

# version of your package
VERSION_c_ares=1.21.0
LINK_c_ares_version=2.7.2
LINK_c_ares=libcares.${LINK_c_ares_version}.dylib

# dependencies of this recipe
DEPS_c_ares=(pkg_config)

# url of the package
URL_c_ares=https://github.com/c-ares/c-ares/releases/download/cares-1_21_0/c-ares-${VERSION_c_ares}.tar.gz

# md5 of the package
MD5_c_ares=cf0808e65175571ef23d7c4a6d4673d6

# default build path
BUILD_c_ares=$BUILD_PATH/c_ares/$(get_directory $URL_c_ares)

# default recipe path
RECIPE_c_ares=$RECIPES_PATH/c_ares

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_c_ares() {
  cd $BUILD_c_ares

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_c_ares() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_c_ares -nt $BUILD_c_ares/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_c_ares() {
  try mkdir -p $BUILD_PATH/c_ares/build-$ARCH
  try cd $BUILD_PATH/c_ares/build-$ARCH
  push_env

  try ${CMAKE} \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_CXX_STANDARD=17 \
    $BUILD_c_ares
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libcares*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_c_ares() {
  verify_binary lib/$LINK_c_ares
}

# function to append information to config file
function add_config_info_c_ares() {
  append_to_config_file "# c_ares-${VERSION_c_ares}: ${DESC_c_ares}"
  append_to_config_file "export VERSION_c_ares=${VERSION_c_ares}"
  append_to_config_file "export LINK_c_ares=${LINK_c_ares}"
}