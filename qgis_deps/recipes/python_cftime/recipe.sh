#!/bin/bash

DESC_python_cftime="Python binding of HDF5"

# version of your package
# need to keep in sync with compatible version of netcdf lib
VERSION_python_cftime=1.2.1

# dependencies of this recipe
DEPS_python_cftime=(python python_packages netcdf hdf5 python_numpy libcurl)

# url of the package
URL_python_cftime=https://files.pythonhosted.org/packages/0b/e6/2508d15ffa91c512ff9f6c9d9070c675c7fc2d6866adef6f44292623b09d/cftime-${VERSION_python_cftime}.tar.gz

# md5 of the package
MD5_python_cftime=0952f5f0952bc606f73ddc5228d04d0e

# default build path
BUILD_python_cftime=$BUILD_PATH/python_cftime/$(get_directory $URL_python_cftime)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_cftime() {
  mkdir -p $BUILD_python_cftime
  cd $BUILD_python_cftime
  try rsync -a $BUILD_python_cftime/ ${BUILD_PATH}/python_cftime/build-${ARCH}


}

function shouldbuild_python_cftime() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed cftime; then
    DO_BUILD=0
  fi
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