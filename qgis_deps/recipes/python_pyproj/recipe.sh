#!/bin/bash

DESC_python_pyproj="Proj binding for python"

# version of your package
# keep in SYNC with proj receipt
VERSION_python_pyproj=2.6.0

# dependencies of this recipe
# depends on PyQt5
DEPS_python_pyproj=(python openssl libtiff sqlite proj python_packages_pre)

# url of the package
URL_python_pyproj=https://github.com/pyproj4/pyproj/archive/v${VERSION_python_pyproj}rel.tar.gz

# md5 of the package
MD5_python_pyproj=c0b3357bec18b0a3c42e7e538229dd94

# default build path
BUILD_python_pyproj=$BUILD_PATH/python_pyproj/$(get_directory $URL_python_pyproj)

# default recipe path
RECIPE_python_pyproj=$RECIPES_PATH/python_pyproj

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pyproj() {
  cd $BUILD_python_pyproj

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_pyproj() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed pyproj; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_pyproj() {
  try rsync -a $BUILD_python_pyproj/ $BUILD_PATH/python_pyproj/build-$ARCH/
  try cd $BUILD_PATH/python_pyproj/build-$ARCH
  push_env

  export PROJ_DIR=${STAGE_PATH}
  export PROJ_LIBDIR=${STAGE_PATH}
  export PROJ_INCDIR=${STAGE_PATH}

  try $PYTHON setup.py install

  pop_env
}

# function called after all the compile have been done
function postbuild_python_pyproj() {
   if ! python_package_installed pyproj; then
      error "Missing python package pyproj"
   fi
}

# function to append information to config file
function add_config_info_python_pyproj() {
  append_to_config_file "# python_pyproj-${VERSION_python_pyproj}: ${DESC_python_pyproj}"
  append_to_config_file "export VERSION_python_pyproj=${VERSION_python_pyproj}"
}