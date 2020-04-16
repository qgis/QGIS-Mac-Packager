#!/bin/bash

DESC_python_h5py="Python binding of HDF5"

# version of your package
# need to keep in sync with hdf5
VERSION_python_h5py=2.10.0

# dependencies of this recipe
DEPS_python_h5py=(python python_packages hdf5)

# url of the package
URL_python_h5py=

# md5 of the package
MD5_python_h5py=

# default build path
BUILD_python_h5py=$BUILD_PATH/python_h5py/v${VERSION_python_h5py}

# default recipe path
RECIPE_python_h5py=$RECIPES_PATH/python_h5py

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_h5py() {
  mkdir -p $BUILD_python_h5py
  cd $BUILD_python_h5py

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_h5py() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed h5py; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_h5py() {
  try cd $BUILD_python_h5py
  push_env

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PIP_NO_BINARY h5py==${VERSION_python_h5py}

  pop_env
}

# function called after all the compile have been done
function postbuild_python_h5py() {
   if ! python_package_installed owslib.wms; then
      error "Missing python package h5py"
   fi
}

# function to append information to config file
function add_config_info_python_h5py() {
  append_to_config_file "# python_h5py-${VERSION_python_h5py}: ${DESC_python_h5py}"
  append_to_config_file "export VERSION_python_h5py=${VERSION_python_h5py}"
}