#!/bin/bash

DESC_laz_perf="Alternative LAZ implementation"

# version of your package
VERSION_laz_perf=1.5.0

# dependencies of this recipe
DEPS_laz_perf=()

# url of the package
URL_laz_perf=https://github.com/hobu/laz-perf/archive/1.5.0.tar.gz

# md5 of the package
MD5_laz_perf=b89a47fbbb719ef2c0df7bcf58d02563

# default build path
BUILD_laz_perf=$BUILD_PATH/laz_perf/$(get_directory $URL_laz_perf)

# default recipe path
RECIPE_laz_perf=$RECIPES_PATH/laz_perf

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_laz_perf() {
  cd $BUILD_laz_perf

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_laz_perf() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/include/laz-perf/las.hpp -nt $BUILD_laz_perf/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_laz_perf() {
  try cd $BUILD_laz_perf

  # header-only library
  try cd cpp
  try mkdir -p $STAGE_PATH/include/laz-perf
  try rsync -zarv --include "*.hpp" --exclude="*.c*" laz-perf $STAGE_PATH/include
}

# function called after all the compile have been done
function postbuild_laz_perf() {
  :
}

# function to append information to config file
function add_config_info_laz_perf() {
  append_to_config_file "# laz_perf-${VERSION_laz_perf}: ${DESC_laz_perf}"
  append_to_config_file "export VERSION_laz_perf=${VERSION_laz_perf}"
}