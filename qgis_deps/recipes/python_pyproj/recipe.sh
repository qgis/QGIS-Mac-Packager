#!/bin/bash

DESC_python_pyproj="Proj binding for python"

# version of your package
# keep in SYNC with proj receipt
VERSION_python_pyproj=3.2.0

# dependencies of this recipe
# depends on PyQt5
DEPS_python_pyproj=(python openssl libtiff sqlite proj python_packages)

# url of the package
URL_python_pyproj=https://github.com/pyproj4/pyproj/archive/refs/tags/${VERSION_python_pyproj}.tar.gz

# md5 of the package
MD5_python_pyproj=dc548c8990e10bc52d012bae5a87030f

# default build path
BUILD_python_pyproj=$BUILD_PATH/python_pyproj/$(get_directory $URL_python_pyproj)

# default recipe path
RECIPE_python_pyproj=$RECIPES_PATH/python_pyproj

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pyproj() {
  cd $BUILD_python_pyproj
  try rsync -a $BUILD_python_pyproj/ $BUILD_PATH/python_pyproj/build-$ARCH/
}

function shouldbuild_python_pyproj() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed pyproj; then
    DO_BUILD=0
  fi
}


# function called after all the compile have been done
function postbuild_python_pyproj() {
   if ! python_package_installed_verbose pyproj; then
      error "Missing python package pyproj"
   fi
}

# function to append information to config file
function add_config_info_python_pyproj() {
  append_to_config_file "# python_pyproj-${VERSION_python_pyproj}: ${DESC_python_pyproj}"
  append_to_config_file "export VERSION_python_pyproj=${VERSION_python_pyproj}"
}