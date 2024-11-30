#!/bin/bash

DESC_python_pyqt_builder="Tool to build PyQt"

# version of your package
# we need SIP 4.x and the version is not longer updated in pip
# so we need to compile directly
VERSION_python_pyqt_builder=1.15.0

# dependencies of this recipe
DEPS_python_pyqt_builder=(python_sip)

# url of the package
URL_python_pyqt_builder=https://files.pythonhosted.org/packages/ee/37/06bc9491c7f84ca776658106a59d3064b1c4c7533a35d547e85fc1e8087f/PyQt-builder-${VERSION_python_pyqt_builder}.tar.gz

# md5 of the package
MD5_python_pyqt_builder=280e427ad991db84e50b86e150503548

# default build path
BUILD_python_pyqt_builder=$BUILD_PATH/python_pyqt_builder/$(get_directory $URL_python_pyqt_builder)

# default recipe path
RECIPE_python_pyqt_builder=$RECIPES_PATH/python_pyqt_builder

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pyqt_builder() {
  try mkdir -p $BUILD_python_pyqt_builder
  cd $BUILD_python_pyqt_builder

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_pyqt_builder() {
   if python_package_installed pyqtbuild; then
      DO_BUILD=0
   fi
}

# function called to build the source code
function build_python_pyqt_builder() {
  try rsync -a $BUILD_python_pyqt_builder/ $BUILD_PATH/python_pyqt_builder/build-$ARCH/
  try cd $BUILD_PATH/python_pyqt_builder/build-$ARCH

  push_env

  try $PYTHON setup.py install

  pop_env
}

function postbuild_python_pyqt_builder() {
   if ! python_package_installed_verbose pyqtbuild; then
      error "Missing python package sip"
   fi
}

# function to append information to config file
function add_config_info_python_pyqt_builder() {
  append_to_config_file "# python_pyqt_builder-${VERSION_python_pyqt_builder}: ${DESC_python_pyqt_builder}"
  append_to_config_file "export VERSION_python_pyqt_builder=${VERSION_python_pyqt_builder}"
}