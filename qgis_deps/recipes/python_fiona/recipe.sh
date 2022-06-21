#!/bin/bash

DESC_python_fiona="python fiona"

# keep in SYNC with proj receipt

DEPS_python_fiona=(python python_packages gdal python_gdal)



# default build path
BUILD_python_fiona=${DEPS_BUILD_PATH}/python_fiona/$(get_directory $URL_python_fiona)

# default recipe path
RECIPE_python_fiona=$RECIPES_PATH/python_fiona

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_fiona() {
  cd $BUILD_python_fiona
  try rsync -a $BUILD_python_fiona/ ${DEPS_BUILD_PATH}/python_fiona/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_fiona() {
   if ! python_package_installed_verbose fiona; then
      error "Missing python package fiona"
   fi
}

# function to append information to config file
function add_config_info_python_fiona() {
  append_to_config_file "# python_fiona-${VERSION_python_fiona}: ${DESC_python_fiona}"
  append_to_config_file "export VERSION_python_fiona=${VERSION_python_fiona}"
}