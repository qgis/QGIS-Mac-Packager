#!/bin/bash

DESC_python_scipy="python scipy"


DEPS_python_scipy=(python python_packages python_numpy python_pillow python_pybind11 python_pythran openblas)

# default build path
BUILD_python_scipy=${DEPS_BUILD_PATH}/python_scipy/$(get_directory $URL_python_scipy)

# default recipe path
RECIPE_python_scipy=$RECIPES_PATH/python_scipy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_scipy() {
  cd $BUILD_python_scipy
  try rsync -a $BUILD_python_scipy/ ${DEPS_BUILD_PATH}/python_scipy/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_scipy() {
  if ! python_package_installed_verbose scipy; then
    error "Missing python package scipy"
  fi
}

# function to append information to config file
function add_config_info_python_scipy() {
  append_to_config_file "# python_scipy-${VERSION_python_scipy}: ${DESC_python_scipy}"
  append_to_config_file "export VERSION_python_scipy=${VERSION_python_scipy}"
}
