#!/bin/bash

DESC_python_tobler="areal interpolation for intensive and extensive variables"

DEPS_python_tobler=(
  python_packages
  python_numpy
  python_geopandas
  python_rasterio
  python_statsmodels
  python_scipy
  python_libpysal
)

# default build path
BUILD_python_tobler=${DEPS_BUILD_PATH}/python_tobler/v${VERSION_python_tobler}

# default recipe path
RECIPE_python_tobler=$RECIPES_PATH/python_tobler

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_tobler() {
  try mkdir -p $BUILD_python_tobler
  cd $BUILD_python_tobler


}

# function called after all the compile have been done
function postbuild_python_tobler() {
   if ! python_package_installed_verbose fiona,tobler; then
      error "Missing python package tobler"
   fi
}

# function to append information to config file
function add_config_info_python_tobler() {
  append_to_config_file "# python_tobler-${VERSION_python_tobler}: ${DESC_python_tobler}"
  append_to_config_file "export VERSION_python_tobler=${VERSION_python_tobler}"
}