#!/bin/bash

DESC_pdal="Point data abstraction library"


LINK_libpdalcpp=libpdalcpp.13.dylib
LINK_libpdal_plugin_kernel_fauxplugin=libpdal_plugin_kernel_fauxplugin.13.dylib
LINK_libpdal_util=libpdal_util.13.dylib

DEPS_pdal=(
  gdal
  libgeotiff
  laszip
  libxml2
  zstd
  xz
  hdf5
  zlib
  libcurl
)

# default build path
BUILD_pdal=${DEPS_BUILD_PATH}/pdal/$(get_directory $URL_pdal)

# default recipe path
RECIPE_pdal=$RECIPES_PATH/pdal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_pdal() {
  cd $BUILD_pdal
}

# function called after all the compile have been done
function postbuild_pdal() {
  verify_binary lib/${LINK_libpdalcpp}
  verify_binary lib/${LINK_libpdal_plugin_kernel_fauxplugin}
  verify_binary lib/${LINK_libpdal_util}
  verify_binary bin/pdal
}

# function to append information to config file
function add_config_info_pdal() {
  append_to_config_file "# pdal-${VERSION_pdal}: ${DESC_pdal}"
  append_to_config_file "export VERSION_pdal=${VERSION_pdal}"
  append_to_config_file "export LINK_libpdalcpp=${LINK_libpdalcpp}"
  append_to_config_file "export LINK_libpdal_plugin_kernel_fauxplugin=${LINK_libpdal_plugin_kernel_fauxplugin}"
  append_to_config_file "export LINK_libpdal_util=${LINK_libpdal_util}"
}
