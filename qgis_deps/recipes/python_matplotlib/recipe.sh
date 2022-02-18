#!/bin/bash

DESC_python_matplotlib="python matplotlib"

# version of your package
VERSION_python_matplotlib=3.3.0

# dependencies of this recipe
DEPS_python_matplotlib=(python python_packages python_numpy python_pillow fontconfig freetype)

# url of the package
URL_python_matplotlib=https://github.com/matplotlib/matplotlib/archive/v$VERSION_python_matplotlib.tar.gz

# md5 of the package
MD5_python_matplotlib=8a55bbf600206a512629e8c582e5eb4a

# default build path
BUILD_python_matplotlib=${DEPS_BUILD_PATH}/python_matplotlib/$(get_directory $URL_python_matplotlib)

# default recipe path
RECIPE_python_matplotlib=$RECIPES_PATH/python_matplotlib

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_matplotlib() {
  cd $BUILD_python_matplotlib
  try rsync -a $BUILD_python_matplotlib/ ${DEPS_BUILD_PATH}/python_matplotlib/build-${ARCH}


}

function shouldbuild_python_matplotlib() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed matplotlib; then
    DO_BUILD=0
  fi
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