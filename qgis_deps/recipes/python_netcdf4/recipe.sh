#!/bin/bash

DESC_python_netcdf4="Python binding of HDF5"

# need to keep in sync with compatible version of netcdf lib

DEPS_python_netcdf4=(python python_packages netcdf hdf5 python_numpy libcurl python_cftime)



# default build path
BUILD_python_netcdf4=${DEPS_BUILD_PATH}/python_netcdf4/$(get_directory $URL_python_netcdf4)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_netcdf4() {
  mkdir -p $BUILD_python_netcdf4
  cd $BUILD_python_netcdf4
  try rsync -a $BUILD_python_netcdf4/ ${DEPS_BUILD_PATH}/python_netcdf4/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_netcdf4() {
   if ! python_package_installed_verbose netCDF4; then
      error "Missing python package netCDF4"
   fi
}

# function to append information to config file
function add_config_info_python_netcdf4() {
  append_to_config_file "# python_netcdf4-${VERSION_python_netcdf4}: ${DESC_python_netcdf4}"
  append_to_config_file "export VERSION_python_netcdf4=${VERSION_python_netcdf4}"
}