#!/bin/bash

DESC_python_momepy="A library of spatial analysis functions."

DEPS_python_momepy=(
  python
  python_packages
)

# default build path
BUILD_python_momepy=${DEPS_BUILD_PATH}/python_momepy/$(get_directory $URL_python_momepy)

# default recipe path
RECIPE_python_momepy=$RECIPES_PATH/python_momepy

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_momepy() {
  cd $BUILD_python_momepy
  try rsync -a $BUILD_python_momepy/ ${DEPS_BUILD_PATH}/python_momepy/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_momepy() {
   if ! python_package_installed_verbose momepy; then
      error "Missing python package momepy"
   fi
}

# function to append information to config file
function add_config_info_python_momepy() {
  append_to_config_file "# python_momepy-${VERSION_python_momepy}: ${DESC_python_momepy}"
  append_to_config_file "export VERSION_python_momepy=${VERSION_python_momepy}"
}