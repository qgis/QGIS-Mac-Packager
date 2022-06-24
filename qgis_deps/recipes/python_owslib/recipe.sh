#!/bin/bash

DESC_python_owslib="Python Open Geospatial Consortium (OGC) web service"


DEPS_python_owslib=(python python_pyproj python_gdal python_packages)

# default build path
BUILD_python_owslib=${DEPS_BUILD_PATH}/python_owslib/v${VERSION_python_owslib}

# default recipe path
RECIPE_python_owslib=$RECIPES_PATH/python_owslib

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