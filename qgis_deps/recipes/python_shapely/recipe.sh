#!/bin/bash

DESC_python_shapely="Manipulation and analysis of geometric objects in the Cartesian plane."


DEPS_python_shapely=(python geos python_packages python_fiona)

# default build path
BUILD_python_shapely=${DEPS_BUILD_PATH}/python_shapely/v${VERSION_python_shapely}

# default recipe path
RECIPE_python_shapely=$RECIPES_PATH/python_shapely

# function called after all the compile have been done
function postbuild_python_shapely() {
   if ! python_package_installed_verbose shapely; then
      error "Missing python package shapely"
   fi
}

# function to append information to config file
function add_config_info_python_shapely() {
  append_to_config_file "# python_shapely-${VERSION_python_shapely}: ${DESC_python_shapely}"
  append_to_config_file "export VERSION_python_shapely=${VERSION_python_shapely}"
}