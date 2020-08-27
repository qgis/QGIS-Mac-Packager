#!/bin/bash

DESC_python_rasterio="Rasterio reads and writes geospatial raster data."

# version of your package
VERSION_python_rasterio=1.1.5

# dependencies of this recipe
# depends on PyQt5
DEPS_python_rasterio=(python gdal python_gdal python_packages)

# url of the package
URL_python_rasterio=https://github.com/mapbox/rasterio/archive/$VERSION_python_rasterio.tar.gz

# md5 of the package
MD5_python_rasterio=fbfb53a7bc521c607d9aad7a4c35c930

# default build path
BUILD_python_rasterio=$BUILD_PATH/python_rasterio/$(get_directory $URL_python_rasterio)

# default recipe path
RECIPE_python_rasterio=$RECIPES_PATH/python_rasterio

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_rasterio() {
  cd $BUILD_python_rasterio

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_rasterio() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed rasterio; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_rasterio() {
  try rsync -a $BUILD_python_rasterio/ $BUILD_PATH/python_rasterio/build-$ARCH/
  try cd $BUILD_PATH/python_rasterio/build-$ARCH
  push_env

  export PROJ_DIR=${STAGE_PATH}
  export PROJ_LIBDIR=${STAGE_PATH}
  export PROJ_INCDIR=${STAGE_PATH}

  try $PYTHON setup.py install

  pop_env
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