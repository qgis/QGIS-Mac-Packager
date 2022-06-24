#!/bin/bash

DESC_python_matplotlib="python matplotlib"


DEPS_python_matplotlib=(python python_packages python_numpy python_pillow fontconfig freetype)

# default build path
BUILD_python_matplotlib=${DEPS_BUILD_PATH}/python_matplotlib/$(get_directory $URL_python_matplotlib)

# default recipe path
RECIPE_python_matplotlib=$RECIPES_PATH/python_matplotlib

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_matplotlib() {
  cd $BUILD_python_matplotlib
  #try patch --verbose --forward -p1 < $RECIPE_python_matplotlib/setup.py.patch
  try rsync -a $BUILD_python_matplotlib/ ${DEPS_BUILD_PATH}/python_matplotlib/build-${ARCH}
}

# function called after all the compile have been done
function postbuild_python_matplotlib() {
   if ! python_package_installed_verbose matplotlib; then
      error "Missing python package matplotlib"
   fi
}

# function to append information to config file
function add_config_info_python_matplotlib() {
  append_to_config_file "# python_matplotlib-${VERSION_python_matplotlib}: ${DESC_python_matplotlib}"
  append_to_config_file "export VERSION_python_matplotlib=${VERSION_python_matplotlib}"
}