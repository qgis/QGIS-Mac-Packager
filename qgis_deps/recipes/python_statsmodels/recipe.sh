#!/bin/bash

DESC_python_statsmodels="python statsmodels"

# version of your package
VERSION_python_statsmodels=0.13.1

# dependencies of this recipe
DEPS_python_statsmodels=(python python_packages python_numpy python_scipy python_patsy python_pandas)

# url of the package
URL_python_statsmodels=https://github.com/statsmodels/statsmodels/archive/v${VERSION_python_statsmodels}.tar.gz

# md5 of the package
MD5_python_statsmodels=b808135f1955f741a24a1fa01cd90e16

# default build path
BUILD_python_statsmodels=$BUILD_PATH/python_statsmodels/$(get_directory $URL_python_statsmodels)

# default recipe path
RECIPE_python_statsmodels=$RECIPES_PATH/python_statsmodels

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_statsmodels() {
  cd $BUILD_python_statsmodels
  try rsync -a $BUILD_python_statsmodels/ ${BUILD_PATH}/python_statsmodels/build-${ARCH}


}

function shouldbuild_python_statsmodels() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed statsmodels; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_statsmodels() {
   if ! python_package_installed_verbose statsmodels; then
      error "Missing python package statsmodels"
   fi
}

# function to append information to config file
function add_config_info_python_statsmodels() {
  append_to_config_file "# python_statsmodels-${VERSION_python_statsmodels}: ${DESC_python_statsmodels}"
  append_to_config_file "export VERSION_python_statsmodels=${VERSION_python_statsmodels}"
}