#!/bin/bash

DESC_python_owslib="Python Open Geospatial Consortium (OGC) web service"

# version of your package
VERSION_python_owslib=0.19.2

# dependencies of this recipe
DEPS_python_owslib=(python python_pyproj python_gdal python_packages)

# url of the package
URL_python_owslib=

# md5 of the package
MD5_python_owslib=

# default build path
BUILD_python_owslib=$BUILD_PATH/python_owslib/v${VERSION_python_owslib}

# default recipe path
RECIPE_python_owslib=$RECIPES_PATH/python_owslib

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_owslib() {
  try mkdir -p $BUILD_python_owslib
  cd $BUILD_python_owslib


}

function shouldbuild_python_owslib() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed owslib.wms; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_owslib() {
   if ! python_package_installed_verbose owslib.wms; then
      error "Missing python package owslib.wms"
   fi
}

# function to append information to config file
function add_config_info_python_owslib() {
  append_to_config_file "# python_owslib-${VERSION_python_owslib}: ${DESC_python_owslib}"
  append_to_config_file "export VERSION_python_owslib=${VERSION_python_owslib}"
}