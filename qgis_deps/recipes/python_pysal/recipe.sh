#!/bin/bash

DESC_python_pysal="A library of spatial analysis functions."

DEPS_python_pysal=(
  python
  python_packages
  python_libpysal
)

# default build path
BUILD_python_pysal=${DEPS_BUILD_PATH}/python_pysal/v${VERSION_python_pysal}

# default recipe path
RECIPE_python_pysal=$RECIPES_PATH/python_pysal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pysal() {
  cd $BUILD_python_pysal
  try rsync -a $BUILD_python_pysal/ ${DEPS_BUILD_PATH}/python_pysal/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_pysal() {
   if ! python_package_installed_verbose pysal; then
      error "Missing python package pysal"
   fi
}

# function to append information to config file
function add_config_info_python_pysal() {
  append_to_config_file "# python_pysal-${VERSION_python_pysal}: ${DESC_python_pysal}"
  append_to_config_file "export VERSION_python_pysal=${VERSION_python_pysal}"
}