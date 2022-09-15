#!/bin/bash

DESC_python_pyqt_builder="pyqt_builder bindings package for python"


DEPS_python_pyqt_builder=(python python_sip)

# default build path
BUILD_python_pyqt_builder=${DEPS_BUILD_PATH}/python_pyqt_builder/v${VERSION_python_pyqt_builder}

# default recipe path
RECIPE_python_pyqt_builder=$RECIPES_PATH/python_pyqt_builder

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pyqt_builder() {
  try mkdir -p $BUILD_python_pyqt_builder
  cd $BUILD_python_pyqt_builder
}

function postbuild_python_pyqt_builder() {
  test_binary_output "./bin/pyqt-bundle -V" $VERSION_python_pyqt_builder
}

# function to append information to config file
function add_config_info_python_pyqt_builder() {
  append_to_config_file "# python_pyqt_builder-${VERSION_python_pyqt_builder}: ${DESC_python_pyqt_builder}"
  append_to_config_file "export VERSION_python_pyqt_builder=${VERSION_python_pyqt_builder}"
}