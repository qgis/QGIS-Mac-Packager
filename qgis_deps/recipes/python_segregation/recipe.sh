#!/bin/bash

DESC_python_segregation="A library of spatial analysis functions."

DEPS_python_segregation=(
  python
  python_packages
  python_sympy
)

# default build path
BUILD_python_segregation=${DEPS_BUILD_PATH}/python_segregation/$(get_directory $URL_python_segregation)

# default recipe path
RECIPE_python_segregation=$RECIPES_PATH/python_segregation

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_segregation() {
  cd $BUILD_python_segregation
  try rsync -a $BUILD_python_segregation/ ${DEPS_BUILD_PATH}/python_segregation/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_segregation() {
   if ! python_package_installed_verbose segregation; then
      error "Missing python package segregation"
   fi
}

# function to append information to config file
function add_config_info_python_segregation() {
  append_to_config_file "# python_segregation-${VERSION_python_segregation}: ${DESC_python_segregation}"
  append_to_config_file "export VERSION_python_segregation=${VERSION_python_segregation}"
}