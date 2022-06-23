#!/bin/bash

DESC_python_h5py="Python binding of HDF5"

DEPS_python_h5py=(python hdf5 python_numpy python_packages)


# default build path
BUILD_python_h5py=${DEPS_BUILD_PATH}/python_h5py/v${VERSION_python_h5py}

# default recipe path
RECIPE_python_h5py=$RECIPES_PATH/python_h5py


# function called after all the compile have been done
function postbuild_python_h5py() {
   if ! python_package_installed_verbose h5py; then
      error "Missing python package h5py"
   fi
}

# function to append information to config file
function add_config_info_python_h5py() {
  append_to_config_file "# python_h5py-${VERSION_python_h5py}: ${DESC_python_h5py}"
  append_to_config_file "export VERSION_python_h5py=${VERSION_python_h5py}"
}