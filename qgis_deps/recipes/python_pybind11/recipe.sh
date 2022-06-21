#!/bin/bash

DESC_python_pybind11="A library of spatial analysis functions."

DEPS_python_pybind11=(
  python
  python_packages
)

# default build path
BUILD_python_pybind11=${DEPS_BUILD_PATH}/python_pybind11/v${VERSION_python_pybind11}

# default recipe path
RECIPE_python_pybind11=$RECIPES_PATH/python_pybind11

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pybind11() {
  try mkdir -p $BUILD_python_pybind11
  try rsync -a $BUILD_python_pybind11/ ${DEPS_BUILD_PATH}/python_pybind11/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_pybind11() {
   if ! python_package_installed_verbose pybind11; then
      error "Missing python package pybind11"
   fi
}

# function to append information to config file
function add_config_info_python_pybind11() {
  append_to_config_file "# python_pybind11-${VERSION_python_pybind11}: ${DESC_python_pybind11}"
  append_to_config_file "export VERSION_python_pybind11=${VERSION_python_pybind11}"
}