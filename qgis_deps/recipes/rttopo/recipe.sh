#!/bin/bash

DESC_rttopo="RT Topology Library"

# version of your package
VERSION_rttopo=1.1.0
LINK_rttopo=librttopo.1.dylib

# dependencies of this recipe
DEPS_rttopo=(geos)

# url of the package
URL_rttopo=https://gitlab.com/rttopo/rttopo/-/archive/librttopo-$VERSION_rttopo/rttopo-librttopo-$VERSION_rttopo.tar.gz

# md5 of the package
MD5_rttopo=3c92498ce25b7f086cc3cd0d8e7bafdd

# default build path
BUILD_rttopo=$BUILD_PATH/rttopo/$(get_directory $URL_rttopo)

# default recipe path
RECIPE_rttopo=$RECIPES_PATH/rttopo

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_rttopo() {
  cd $BUILD_rttopo

  # check marker
  if [ -f .patched ]; then
    return
  fi



  touch .patched
}

function shouldbuild_rttopo() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_rttopo -nt $BUILD_rttopo/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_rttopo() {
  try rsync -a $BUILD_rttopo/ $BUILD_PATH/rttopo/build-$ARCH/
  try cd $BUILD_PATH/rttopo/build-$ARCH
  push_env

  try ./autogen.sh
  patch_configure_file configure

  try ${CONFIGURE} \
    --enable-geocallbacks \
    --disable-dependency-tracking

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_rttopo() {
  verify_binary lib/$LINK_rttopo
}

# function to append information to config file
function add_config_info_rttopo() {
  append_to_config_file "# rttopo-${VERSION_rttopo}: ${DESC_rttopo}"
  append_to_config_file "export VERSION_rttopo=${VERSION_rttopo}"
  append_to_config_file "export LINK_rttopo=${LINK_rttopo}"
}