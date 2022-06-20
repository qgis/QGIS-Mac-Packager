#!/bin/bash

DESC_rttopo="RT Topology Library"

LINK_rttopo=librttopo.1.dylib

DEPS_rttopo=(geos)

# default build path
BUILD_rttopo=${DEPS_BUILD_PATH}/rttopo/$(get_directory $URL_rttopo)

# default recipe path
RECIPE_rttopo=$RECIPES_PATH/rttopo

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_rttopo() {
  cd $BUILD_rttopo
  try rsync -a $BUILD_rttopo/ ${DEPS_BUILD_PATH}/rttopo/build-${ARCH}
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