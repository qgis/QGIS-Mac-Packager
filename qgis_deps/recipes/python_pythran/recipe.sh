#!/bin/bash

DESC_python_pythran="Pythran is an ahead of time compiler for a subset of the Python language, with a focus on scientific computing."

DEPS_python_pythran=(
  python
  python_packages
  python_beniget
)

# default build path
BUILD_python_pythran=${DEPS_BUILD_PATH}/python_pythran/${VERSION_python_pythran}

# default recipe path
RECIPE_python_pythran=$RECIPES_PATH/python_pythran

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pythran() {
  cd $BUILD_python_pythran
  try rsync -a $BUILD_python_pythran/ ${DEPS_BUILD_PATH}/python_pythran/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_pythran() {
   if ! python_package_installed_verbose pythran; then
      error "Missing python package pythran"
   fi
}

# function to append information to config file
function add_config_info_python_pythran() {
  append_to_config_file "# python_pythran-${VERSION_python_pythran}: ${DESC_python_pythran}"
  append_to_config_file "export VERSION_python_pythran=${VERSION_python_pythran}"
}