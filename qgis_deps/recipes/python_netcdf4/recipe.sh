#!/bin/bash

DESC_python_netcdf4="Python binding of HDF5"

# version of your package
# need to keep in sync with compatible version of netcdf lib
VERSION_python_netcdf4=1.6.3

# dependencies of this recipe
DEPS_python_netcdf4=(python python_packages netcdf hdf5 python_numpy libcurl python_cftime)

# url of the package
URL_python_netcdf4=https://github.com/Unidata/netcdf4-python/archive/refs/tags/v${VERSION_python_netcdf4}rel.tar.gz

# md5 of the package
MD5_python_netcdf4=1bd0955c3e947edda65f4a538cbe18ff

# default build path
BUILD_python_netcdf4=$BUILD_PATH/python_netcdf4/$(get_directory $URL_python_netcdf4)

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_netcdf4() {
  mkdir -p $BUILD_python_netcdf4
  cd $BUILD_python_netcdf4

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_netcdf4() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed netCDF4; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_netcdf4() {
  try rsync -a $BUILD_python_netcdf4/ $BUILD_PATH/python_netcdf4/build-$ARCH/
  try cd $BUILD_PATH/python_netcdf4/build-$ARCH

  push_env

  export HDF5_DIR=$STAGE_PATH
  export NETCDF4_DIR=$STAGE_PATH
  export CURL_DIR=$STAGE_PATH

  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install

  unset HDF5_DIR
  unset NETCDF4_DIR
  unset CURL_DIR

  pop_env
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