#!/bin/bash

DESC_python_beniget="Beniget is a collection of Compile-time analyse on Python Abstract Syntax Tree(AST)."

DEPS_python_beniget=(
  python
  python_packages
  python_gast
)

# default build path
BUILD_python_beniget=${DEPS_BUILD_PATH}/python_beniget/${VERSION_python_beniget}

# default recipe path
RECIPE_python_beniget=$RECIPES_PATH/python_beniget

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_beniget() {
  cd $BUILD_python_beniget
  try rsync -a $BUILD_python_beniget/ ${DEPS_BUILD_PATH}/python_beniget/build-${ARCH}
}

function shouldbuild_python_beniget() {
  if python_package_installed beniget; then
    DO_BUILD=0
  fi
}

# function called after all the compile have been done
function postbuild_python_beniget() {
   if ! python_package_installed_verbose beniget; then
      error "Missing python package beniget"
   fi
}

# function to append information to config file
function add_config_info_python_beniget() {
  append_to_config_file "# python_beniget-${VERSION_python_beniget}: ${DESC_python_beniget}"
  append_to_config_file "export VERSION_python_beniget=${VERSION_python_beniget}"
}