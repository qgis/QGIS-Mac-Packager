#!/bin/bash

DESC_netcdf="Libraries and data formats for array-oriented scientific data"

LINK_netcdf=libnetcdf.15.dylib

DEPS_netcdf=(libcurl libzip)


# md5 of the package

# default build path
BUILD_netcdf=${DEPS_BUILD_PATH}/netcdf/$(get_directory $URL_netcdf)

# default recipe path
RECIPE_netcdf=$RECIPES_PATH/netcdf

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_netcdf() {
  cd $BUILD_netcdf


}

function shouldbuild_netcdf() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/$LINK_netcdf -nt $BUILD_netcdf/.patched ]; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_netcdf() {
  verify_binary lib/$LINK_netcdf
}

# function to append information to config file
function add_config_info_netcdf() {
  append_to_config_file "# netcdf-${VERSION_netcdf}: ${DESC_netcdf}"
  append_to_config_file "export VERSION_netcdf=${VERSION_netcdf}"
  append_to_config_file "export LINK_netcdf=${LINK_netcdf}"
}