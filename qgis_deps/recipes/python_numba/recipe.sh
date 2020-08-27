#!/bin/bash

DESC_python_numba="A Just-In-Time Compiler for Numerical Functions in Python"

# version of your package
VERSION_python_numba=0.50.1

# dependencies of this recipe
DEPS_python_numba=(python python_packages python_numpy python_scipy python_llvmlite )

# url of the package
URL_python_numba=https://github.com/numba/numba/archive/${VERSION_python_numba}.tar.gz

# md5 of the package
MD5_python_numba=0cfb6b45282f4d6b9793a17588de180b

# default build path
BUILD_python_numba=$BUILD_PATH/python_numba/$(get_directory $URL_python_numba)

# default recipe path
RECIPE_python_numba=$RECIPES_PATH/python_numba

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_numba() {
  cd $BUILD_python_numba

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_numba() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed numba; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_numba() {
  try rsync -a $BUILD_python_numba/ $BUILD_PATH/python_numba/build-$ARCH/
  try cd $BUILD_PATH/python_numba/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
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