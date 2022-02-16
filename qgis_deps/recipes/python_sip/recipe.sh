#!/bin/bash

DESC_python_sip="SIP bindings package for python"

# version of your package
# we need SIP 4.x and the version is not longer updated in pip
# so we need to compile directly
VERSION_python_sip=4.19.25

# dependencies of this recipe
DEPS_python_sip=(python qtwebkit qscintilla qtwebkit)

# url of the package
URL_python_sip=https://www.riverbankcomputing.com/static/Downloads/sip/${VERSION_python_sip}/sip-${VERSION_python_sip}.tar.gz

# md5 of the package
MD5_python_sip=1891a7b71c72d83951d5851ae10b2f0c

# default build path
BUILD_python_sip=$BUILD_PATH/python_sip/$(get_directory $URL_python_sip)

# default recipe path
RECIPE_python_sip=$RECIPES_PATH/python_sip

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_sip() {
  try mkdir -p $BUILD_python_sip
  cd $BUILD_python_sip
  try rsync -a $BUILD_python_sip/ ${BUILD_PATH}/python_sip/build-${ARCH}


}

function shouldbuild_python_sip() {
   if python_package_installed sipconfig; then
      DO_BUILD=0
   fi
}



function postbuild_python_sip() {
   # if ! python_package_installed sip ${VERSION_python_sip} sipconfig; then
   if ! python_package_installed_verbose sipconfig; then
      error "Missing python package sip"
   fi
}

# function to append information to config file
function add_config_info_python_sip() {
  append_to_config_file "# python_sip-${VERSION_python_sip}: ${DESC_python_sip}"
  append_to_config_file "export VERSION_python_sip=${VERSION_python_sip}"
}