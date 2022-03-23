#!/bin/bash

DESC_python_numba="A Just-In-Time Compiler for Numerical Functions in Python"

DEPS_python_numba=(python python_packages python_numpy python_scipy python_llvmlite )

# default build path
BUILD_python_numba=${DEPS_BUILD_PATH}/python_numba/$(get_directory $URL_python_numba)

# default recipe path
RECIPE_python_numba=$RECIPES_PATH/python_numba

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_numba() {
  cd $BUILD_python_numba
  try rsync -a $BUILD_python_numba/ ${DEPS_BUILD_PATH}/python_numba/build-$ARCH/
}

function shouldbuild_python_numba() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed numba; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_numba() {
   if ! python_package_installed_verbose numba; then
      error "Missing python package numba"
   fi
}

# function to append information to config file
function add_config_info_python_numba() {
  append_to_config_file "# python_numba-${VERSION_python_numba}: ${DESC_python_numba}"
  append_to_config_file "export VERSION_python_numba=${VERSION_python_numba}"
}