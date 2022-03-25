#!/bin/bash

DESC_python_gast="gast is an ahead of time compiler for a subset of the Python language, with a focus on scientific computing."

DEPS_python_gast=(
  python
  python_packages
)

# default build path
BUILD_python_gast=${DEPS_BUILD_PATH}/python_gast/${VERSION_python_gast}

# default recipe path
RECIPE_python_gast=$RECIPES_PATH/python_gast

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_gast() {
  cd $BUILD_python_gast
  try rsync -a $BUILD_python_gast/ ${DEPS_BUILD_PATH}/python_gast/build-${ARCH}
}

function shouldbuild_python_gast() {
  if python_package_installed gast; then
    DO_BUILD=0
  fi
}

# function called after all the compile have been done
function postbuild_python_gast() {
   if ! python_package_installed_verbose gast; then
      error "Missing python package gast"
   fi
}

# function to append information to config file
function add_config_info_python_gast() {
  append_to_config_file "# python_gast-${VERSION_python_gast}: ${DESC_python_gast}"
  append_to_config_file "export VERSION_python_gast=${VERSION_python_gast}"
}