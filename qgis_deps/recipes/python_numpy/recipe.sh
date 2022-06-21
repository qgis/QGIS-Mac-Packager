#!/bin/bash

DESC_python_numpy="python numpy"


DEPS_python_numpy=(python python_packages openblas)



# default build path
BUILD_python_numpy=${DEPS_BUILD_PATH}/python_numpy/$(get_directory $URL_python_numpy)

# default recipe path
RECIPE_python_numpy=$RECIPES_PATH/python_numpy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_numpy() {
  cd $BUILD_python_numpy
  try rsync -a $BUILD_python_numpy/ ${DEPS_BUILD_PATH}/python_numpy/build-${ARCH}
}


# function called after all the compile have been done
function postbuild_python_numpy() {
   if ! python_package_installed_verbose numpy; then
      error "Missing python package numpy"
   fi
}

# function to append information to config file
function add_config_info_python_numpy() {
  append_to_config_file "# python_numpy-${VERSION_python_numpy}: ${DESC_python_numpy}"
  append_to_config_file "export VERSION_python_numpy=${VERSION_python_numpy}"
}