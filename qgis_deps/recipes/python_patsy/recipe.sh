#!/bin/bash

DESC_python_patsy="python patsy"

# version of your package
VERSION_python_patsy=0.5.1

# dependencies of this recipe
DEPS_python_patsy=(python python_packages python_numpy)

# url of the package
URL_python_patsy=https://github.com/pydata/patsy/archive/v${VERSION_python_patsy}.tar.gz

# md5 of the package
MD5_python_patsy=ff2bad29ac6d71ce265c4027b487fd63

# default build path
BUILD_python_patsy=$BUILD_PATH/python_patsy/$(get_directory $URL_python_patsy)

# default recipe path
RECIPE_python_patsy=$RECIPES_PATH/python_patsy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_patsy() {
  cd $BUILD_python_patsy
  try rsync -a $BUILD_python_patsy/ ${BUILD_PATH}/python_patsy/build-${ARCH}


}

function shouldbuild_python_patsy() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed patsy; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_patsy() {
   if ! python_package_installed_verbose patsy; then
      error "Missing python package patsy"
   fi
}

# function to append information to config file
function add_config_info_python_patsy() {
  append_to_config_file "# python_patsy-${VERSION_python_patsy}: ${DESC_python_patsy}"
  append_to_config_file "export VERSION_python_patsy=${VERSION_python_patsy}"
}