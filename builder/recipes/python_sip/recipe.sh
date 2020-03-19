#!/bin/bash

# version of your package
# we need SIP 4.x and the version is not longer updated in pip
# so we need to compile directly
VERSION_python_sip=4.19.21

# dependencies of this recipe
DEPS_python_sip=()

# url of the package
URL_python_sip=https://www.riverbankcomputing.com/static/Downloads/sip/${VERSION_python_sip}/sip-${VERSION_python_sip}.tar.gz

# md5 of the package
MD5_python_sip=dad2afc3d8dfc0d681f3cb87eb2e55aa

# default build path
BUILD_python_sip=$BUILD_PATH/python_sip/$(get_directory $URL_python_sip)

# default recipe path
RECIPE_python_sip=$RECIPES_PATH/python_sip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_sip() {
  try mkdir -p $BUILD_python_sip
  cd $BUILD_python_sip

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_sip() {
   if python_package_installed sip ${VERSION_python_sip} sipconfig; then
      DO_BUILD=0
   fi
}

# function called to build the source code
function build_python_sip() {
  try rsync -a $BUILD_python_sip/ $BUILD_PATH/python_sip/build-$ARCH/
  try cd $BUILD_PATH/python_sip/build-$ARCH

  push_env

  # TODO put sip.so in the /lib directory?
  $PYTHON ./configure.py
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

function postbuild_python_sip() {
   if ! python_package_installed sip ${VERSION_python_sip} sipconfig; then
      error "Missing python package sip"
   fi
}
