#!/bin/bash

DESC_netcdf="Libraries and data formats for array-oriented scientific data"

# version of your package
VERSION_netcdf=4.7.3

# dependencies of this recipe
DEPS_netcdf=()

# url of the package
URL_netcdf=https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-${VERSION_netcdf}.tar.gz

# md5 of the package
MD5_netcdf=9e1d7f13c2aef921c854d87037bcbd96

# default build path
BUILD_netcdf=$BUILD_PATH/netcdf/$(get_directory $URL_netcdf)

# default recipe path
RECIPE_netcdf=$RECIPES_PATH/netcdf

patch_nc_linker_links () {
  targets=(
    bin/nc-config
    bin/nccopy
    bin/ncdump
    bin/ncgen
    bin/ncgen3
  )

  # Change linked libs
  for i in ${targets[*]}
  do
      install_name_tool -delete_rpath $BUILD_PATH/netcdf/build-$ARCH/liblib ${STAGE_PATH}/$i
      install_name_tool -add_rpath @executable_path/../lib ${STAGE_PATH}/$i
  done
}

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_netcdf() {
  cd $BUILD_netcdf

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_netcdf() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libnetcdf.dylib -nt $BUILD_netcdf/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_netcdf() {
  try mkdir -p $BUILD_PATH/netcdf/build-$ARCH
  try cd $BUILD_PATH/netcdf/build-$ARCH
  push_env

  try ${CMAKE} $BUILD_netcdf
  check_file_configuration CMakeCache.txt

  try $MAKESMP
  try $MAKESMP install

  patch_nc_linker_links

  pop_env
}

# function called after all the compile have been done
function postbuild_netcdf() {
  verify_lib "libnetcdf.dylib"
}

# function to append information to config file
function add_config_info_netcdf() {
  append_to_config_file "# netcdf-${VERSION_netcdf}: ${DESC_netcdf}"
  append_to_config_file "export VERSION_netcdf=${VERSION_netcdf}"
}