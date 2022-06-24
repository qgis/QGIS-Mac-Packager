#!/bin/bash

DESC_python_scikit_build="Manipulation and analysis of geometric objects in the Cartesian plane."


DEPS_python_scikit_build=(python geos python_packages python_fiona)

# default build path
BUILD_python_scikit_build=${DEPS_BUILD_PATH}/python_scikit_build/v${VERSION_python_scikit_build}

# default recipe path
RECIPE_python_scikit_build=$RECIPES_PATH/python_scikit_build

# function called after all the compile have been done
function postbuild_python_scikit_build() {
   if ! python_package_installed_verbose skbuild; then
      error "Missing python package scikit_build"
   fi
}

# function to append information to config file
function add_config_info_python_scikit_build() {
  append_to_config_file "# python_scikit_build-${VERSION_python_scikit_build}: ${DESC_python_scikit_build}"
  append_to_config_file "export VERSION_python_scikit_build=${VERSION_python_scikit_build}"
}