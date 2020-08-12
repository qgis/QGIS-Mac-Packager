#!/bin/bash

DESC_python_numpy="python numpy"

# version of your package
# keep in SYNC with proj receipt
VERSION_python_numpy=1.19.1

# dependencies of this recipe
DEPS_python_numpy=(python python_packages openblas)

# url of the package
URL_python_numpy=https://github.com/numpy/numpy/archive/v${VERSION_python_numpy}.tar.gz

# md5 of the package
MD5_python_numpy=df258dde5dace1d43d152ecfbb812088

# default build path
BUILD_python_numpy=$BUILD_PATH/python_numpy/$(get_directory $URL_python_numpy)

# default recipe path
RECIPE_python_numpy=$RECIPES_PATH/python_numpy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_numpy() {
  cd $BUILD_python_numpy

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_numpy() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed numpy; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_numpy() {
  try rsync -a $BUILD_python_numpy/ $BUILD_PATH/python_numpy/build-$ARCH/
  try cd $BUILD_PATH/python_numpy/build-$ARCH
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  pop_env
}

# function called after all the compile have been done
function postbuild_python_numpy() {
   if ! python_package_installed numpy; then
      error "Missing python package numpy"
   fi
}

# function to append information to config file
function add_config_info_python_numpy() {
  append_to_config_file "# python_numpy-${VERSION_python_numpy}: ${DESC_python_numpy}"
  append_to_config_file "export VERSION_python_numpy=${VERSION_python_numpy}"
}