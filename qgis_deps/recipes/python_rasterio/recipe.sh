#!/bin/bash

DESC_python_rasterio="Rasterio reads and writes geospatial raster data."


# depends on PyQt5
DEPS_python_rasterio=(python gdal python_gdal python_pyproj python_packages)


# md5 of the package

# default build path
BUILD_python_rasterio=${DEPS_BUILD_PATH}/python_rasterio/$(get_directory $URL_python_rasterio)

# default recipe path
RECIPE_python_rasterio=$RECIPES_PATH/python_rasterio

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_rasterio() {
  cd $BUILD_python_rasterio
  try rsync -a $BUILD_python_rasterio/ ${DEPS_BUILD_PATH}/python_rasterio/build-${ARCH}


}

function shouldbuild_python_rasterio() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed rasterio; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_rasterio() {
   if ! python_package_installed_verbose rasterio; then
      error "Missing python package rasterio"
   fi
}

# function to append information to config file
function add_config_info_python_rasterio() {
  append_to_config_file "# python_rasterio-${VERSION_python_rasterio}: ${DESC_python_rasterio}"
  append_to_config_file "export VERSION_python_rasterio=${VERSION_python_rasterio}"
}