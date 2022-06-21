#!/bin/bash

DESC_python_cryptography="A library of spatial analysis functions."

VERSION_python_libcryptography=36.0.2


DEPS_python_cryptography=(
  python
  python_packages
)



# default build path
BUILD_python_cryptography=${DEPS_BUILD_PATH}/python_cryptography/v${VERSION_python_cryptography}

# default recipe path
RECIPE_python_cryptography=$RECIPES_PATH/python_cryptography

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_cryptography() {
  try mkdir -p $BUILD_python_cryptography
  cd $BUILD_python_cryptography
}

# function called after all the compile have been done
function postbuild_python_cryptography() {
   if ! python_package_installed_verbose fiona,cryptography; then
      error "Missing python package cryptography"
   fi
}

# function to append information to config file
function add_config_info_python_cryptography() {
  append_to_config_file "# python_cryptography-${VERSION_python_cryptography}: ${DESC_python_cryptography}"
  append_to_config_file "export VERSION_python_libcryptography=${VERSION_python_libcryptography}"
  append_to_config_file "export VERSION_python_cryptography=${VERSION_python_cryptography}"
}