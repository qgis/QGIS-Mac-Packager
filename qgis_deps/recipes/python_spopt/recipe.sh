#!/bin/bash

DESC_python_spopt="A library of spatial analysis functions."

DEPS_python_spopt=(
  python_spaghetti
)

# default build path
BUILD_python_spopt=${DEPS_BUILD_PATH}/python_spopt/$(get_directory ${URL_python_spopt})

# default recipe path
RECIPE_python_spopt=$RECIPES_PATH/python_spopt

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_spopt() {
  cd $BUILD_python_spopt
  try rsync -a $BUILD_python_spopt/ ${DEPS_BUILD_PATH}/python_spopt/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_spopt() {
   if ! python_package_installed_verbose spopt; then
      error "Missing python package spopt"
   fi
}

# function to append information to config file
function add_config_info_python_spopt() {
  append_to_config_file "# python_spopt-${VERSION_python_spopt}: ${DESC_python_spopt}"
  append_to_config_file "export VERSION_python_spopt=${VERSION_python_spopt}"
}