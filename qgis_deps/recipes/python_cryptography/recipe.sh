#!/bin/bash

DESC_python_cryptography="A library of spatial analysis functions."

VERSION_python_libcryptography=36.0.2


DEPS_python_cryptography=(
  python
  python_packages
)

# default recipe path
RECIPE_python_cryptography=$RECIPES_PATH/python_cryptography


# function called after all the compile have been done
function postbuild_python_cryptography() {
   if ! python_package_installed_verbose cryptography; then
      error "Missing python package cryptography"
   fi
}

# function to append information to config file
function add_config_info_python_cryptography() {
  append_to_config_file "# python_cryptography-${VERSION_python_cryptography}: ${DESC_python_cryptography}"
  append_to_config_file "export VERSION_python_libcryptography=${VERSION_python_libcryptography}"
  append_to_config_file "export VERSION_python_cryptography=${VERSION_python_cryptography}"
}