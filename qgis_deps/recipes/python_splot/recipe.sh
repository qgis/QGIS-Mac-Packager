#!/bin/bash

DESC_python_splot="A library of spatial analysis functions."

DEPS_python_splot=(
  python
  python_packages
  python_sympy
)

# default build path
BUILD_python_splot=${DEPS_BUILD_PATH}/python_splot/$(get_directory $URL_python_splot)

# default recipe path
RECIPE_python_splot=$RECIPES_PATH/python_splot

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_splot() {
  cd $BUILD_python_splot
  try rsync -a $BUILD_python_splot/ ${DEPS_BUILD_PATH}/python_splot/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_splot() {
   if ! python_package_installed_verbose splot; then
      error "Missing python package splot"
   fi
}

# function to append information to config file
function add_config_info_python_splot() {
  append_to_config_file "# python_splot-${VERSION_python_splot}: ${DESC_python_splot}"
  append_to_config_file "export VERSION_python_splot=${VERSION_python_splot}"
}