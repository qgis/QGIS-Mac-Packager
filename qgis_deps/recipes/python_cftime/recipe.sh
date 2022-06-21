#!/bin/bash

DESC_python_cftime="Python binding of HDF5"

# need to keep in sync with compatible version of netcdf lib

DEPS_python_cftime=(python python_packages netcdf hdf5 python_numpy libcurl)



# default build path
BUILD_python_cftime=${DEPS_BUILD_PATH}/python_cftime/$(get_directory $URL_python_cftime)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_cftime() {
  mkdir -p $BUILD_python_cftime
  cd $BUILD_python_cftime
  try rsync -a $BUILD_python_cftime/ ${DEPS_BUILD_PATH}/python_cftime/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_cftime() {
   if ! python_package_installed_verbose cftime; then
      error "Missing python package cftime"
   fi
}

# function to append information to config file
function add_config_info_python_cftime() {
  append_to_config_file "# python_cftime-${VERSION_python_cftime}: ${DESC_python_cftime}"
  append_to_config_file "export VERSION_python_cftime=${VERSION_python_cftime}"
}