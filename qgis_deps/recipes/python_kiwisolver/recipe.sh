#!/bin/bash

DESC_python_kiwisolver="Efficient C++ implementation of the Cassowary constraint solving algorithm"

DEPS_python_kiwisolver=(python python_packages python_numpy python_scipy python_llvmlite )

# default build path
BUILD_python_kiwisolver=${DEPS_BUILD_PATH}/python_kiwisolver/$(get_directory $URL_python_kiwisolver)

# default recipe path
RECIPE_python_kiwisolver=$RECIPES_PATH/python_kiwisolver

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_kiwisolver() {
  cd $BUILD_python_kiwisolver
  try rsync -a $BUILD_python_kiwisolver/ ${DEPS_BUILD_PATH}/python_kiwisolver/build-$ARCH/
}

# function called after all the compile have been done
function postbuild_python_kiwisolver() {
   if ! python_package_installed_verbose kiwisolver; then
      error "Missing python package kiwisolver"
   fi
}

# function to append information to config file
function add_config_info_python_kiwisolver() {
  append_to_config_file "# python_kiwisolver-${VERSION_python_kiwisolver}: ${DESC_python_kiwisolver}"
  append_to_config_file "export VERSION_python_kiwisolver=${VERSION_python_kiwisolver}"
}