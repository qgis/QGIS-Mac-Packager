#!/bin/bash

DESC_python_pyqt5_sip="The sip extension module provides support for the PyQt5 package."

DEPS_python_pyqt5_sip=(python)

# default build path
BUILD_python_pyqt5_sip=${DEPS_BUILD_PATH}/python_pyqt5_sip/v${VERSION_python_pyqt5_sip}

# default recipe path
RECIPE_python_pyqt5_sip=$RECIPES_PATH/python_pyqt5_sip

# function called after all the compile have been done
function postbuild_python_pyqt5_sip() {
  :
}

# function to append information to config file
function add_config_info_python_pyqt5_sip() {
  append_to_config_file "# python_pyqt5_sip-${VERSION_python_pyqt5_sip}: ${DESC_python_pyqt5_sip}"
  append_to_config_file "export VERSION_python_pyqt5_sip=${VERSION_python_pyqt5_sip}"
}