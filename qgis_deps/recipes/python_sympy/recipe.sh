#!/bin/bash

DESC_python_sympy="A library of spatial analysis functions."

DEPS_python_sympy=(
  python
  python_packages
)

# default build path
BUILD_python_sympy=${DEPS_BUILD_PATH}/python_sympy/$(get_directory $URL_python_sympy)

# default recipe path
RECIPE_python_sympy=$RECIPES_PATH/python_sympy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_sympy() {
  cd $BUILD_python_sympy
  try rsync -a $BUILD_python_sympy/ ${DEPS_BUILD_PATH}/python_sympy/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_sympy() {
   if ! python_package_installed_verbose sympy; then
      error "Missing python package sympy"
   fi
}

# function to append information to config file
function add_config_info_python_sympy() {
  append_to_config_file "# python_sympy-${VERSION_python_sympy}: ${DESC_python_sympy}"
  append_to_config_file "export VERSION_python_sympy=${VERSION_python_sympy}"
}