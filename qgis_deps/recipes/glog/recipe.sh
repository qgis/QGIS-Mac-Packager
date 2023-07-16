#!/bin/bash

DESC_glog="Application-level logging library"

# version of your package
VERSION_glog=0.6.0
LINK_glog_version=0.6.0
LINK_glog=libglog.${LINK_glog_version}.dylib

# dependencies of this recipe
DEPS_glog=(gflags)

# url of the package
URL_glog=https://github.com/google/glog/archive/v${VERSION_glog}.tar.gz

# md5 of the package
MD5_glog=52b9786ca6fbc679869fee2b6fef25a5

# default build path
BUILD_glog=$BUILD_PATH/glog/$(get_directory $URL_glog)

# default recipe path
RECIPE_glog=$RECIPES_PATH/glog

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_glog() {
  cd $BUILD_glog

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_glog() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_glog -nt $BUILD_glog/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_glog() {
  try mkdir -p $BUILD_PATH/glog/build-$ARCH
  try cd $BUILD_PATH/glog/build-$ARCH
  push_env

  try ${CMAKE} \
    -DBUILD_SHARED_LIBS=ON \
    $BUILD_glog
  check_file_configuration CMakeCache.txt

  try $NINJA
  try $NINJA install

  # fixes all libraries install name
  for i in `ls ${STAGE_PATH}/lib/libglog*.dylib`;
  do
    fix_install_name lib/`basename $i`
  done

  pop_env
}

# function called after all the compile have been done
function postbuild_glog() {
  verify_binary lib/$LINK_glog
}

# function to append information to config file
function add_config_info_glog() {
  append_to_config_file "# glog-${VERSION_glog}: ${DESC_glog}"
  append_to_config_file "export VERSION_glog=${VERSION_glog}"
  append_to_config_file "export LINK_glog=${LINK_glog}"
}