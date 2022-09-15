#!/bin/bash

DESC_python_pygeos="A library of spatial analysis functions."

DEPS_python_pygeos=(
  python
  python_packages
)

# default build path
BUILD_python_pygeos=${DEPS_BUILD_PATH}/python_pygeos/$(get_directory $URL_python_pygeos)

# default recipe path
RECIPE_python_pygeos=$RECIPES_PATH/python_pygeos

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pygeos() {
  try mkdir -p $BUILD_python_pygeos
  try rsync -a $BUILD_python_pygeos/ ${DEPS_BUILD_PATH}/python_pygeos/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_pygeos() {
   if ! python_package_installed_verbose pygeos; then
      error "Missing python package pygeos"
   fi
}

# function to append information to config file
function add_config_info_python_pygeos() {
  append_to_config_file "# python_pygeos-${VERSION_python_pygeos}: ${DESC_python_pygeos}"
  append_to_config_file "export VERSION_python_pygeos=${VERSION_python_pygeos}"
}