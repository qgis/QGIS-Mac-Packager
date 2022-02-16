#!/bin/bash

DESC_netcdf="Libraries and data formats for array-oriented scientific data"

# version of your package
VERSION_netcdf=4.7.3
LINK_netcdf=libnetcdf.15.dylib

# dependencies of this recipe
DEPS_netcdf=(libcurl)

# url of the package
URL_netcdf=https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-${VERSION_netcdf}.tar.gz

# md5 of the package
MD5_netcdf=9e1d7f13c2aef921c854d87037bcbd96

# default build path
BUILD_netcdf=$BUILD_PATH/netcdf/$(get_directory $URL_netcdf)

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