#!/bin/bash

DESC_python_sip="SIP bindings package for python"

# version of your package
# we need SIP 4.x and the version is not longer updated in pip
# so we need to compile directly
VERSION_python_sip=6.7.8
VERSION_python_sip_hash=68bfefcdc48875e66aabafc946620483d0cd93aba52dde37d2059e5bf927

# dependencies of this recipe
DEPS_python_sip=(python qtwebkit qscintilla qtwebkit)

# url of the package
URL_python_sip=https://files.pythonhosted.org/packages/c7/09/${VERSION_python_sip_hash}/sip-${VERSION_python_sip}.tar.gz

# md5 of the package
MD5_python_sip=e9838b911b296f944ce5848b60f01f61

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
   if python_package_installed sipbuild; then
      DO_BUILD=0
   fi
}

# function called to build the source code
function build_python_sip() {
  try rsync -a $BUILD_python_sip/ $BUILD_PATH/python_sip/build-$ARCH/
  try cd $BUILD_PATH/python_sip/build-$ARCH

  push_env

  try $PYTHON setup.py install

  pop_env
}

function postbuild_python_sip() {
   # if ! python_package_installed sip ${VERSION_python_sip} sipbuild; then
   if ! python_package_installed_verbose sipbuild; then
      error "Missing python package sip"
   fi
}

# function to append information to config file
function add_config_info_python_sip() {
  append_to_config_file "# python_sip-${VERSION_python_sip}: ${DESC_python_sip}"
  append_to_config_file "export VERSION_python_sip=${VERSION_python_sip}"
}