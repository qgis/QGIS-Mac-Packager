#!/bin/bash

DESC_python_gdal="GDAL binding for python"

# keep in SYNC with gdal receipt
source ${RECIPES_PATH}/gdal/recipe.sh

DEPS_python_gdal=(python python_pyproj gdal python_packages )


# md5 of the package

# default build path
BUILD_python_gdal=${DEPS_BUILD_PATH}/python_gdal/$(get_directory ${URL_python_gdal})

# default recipe path
RECIPE_python_gdal=$RECIPES_PATH/python_gdal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_gdal() {
  cd $BUILD_python_gdal
  try rsync -a $BUILD_python_gdal/ ${DEPS_BUILD_PATH}/python_gdal/build-${ARCH}


}

function shouldbuild_python_gdal() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed osgeo; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_gdal() {
   if ! python_package_installed_verbose osgeo; then
      error "Missing python package osgeo"
   fi
}

# function to append information to config file
function add_config_info_python_gdal() {
  append_to_config_file "# python_gdal-${VERSION_python_gdal}: ${DESC_python_gdal}"
  append_to_config_file "export VERSION_python_gdal=${VERSION_python_gdal}"
}