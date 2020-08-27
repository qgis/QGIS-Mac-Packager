#!/bin/bash

DESC_python_fiona="python fiona"

# version of your package
# keep in SYNC with proj receipt
VERSION_python_fiona=1.8.13.post1

# dependencies of this recipe
DEPS_python_fiona=(python python_packages gdal python_gdal)

# url of the package
URL_python_fiona=https://github.com/Toblerity/Fiona/archive/${VERSION_python_fiona}.tar.gz

# md5 of the package
MD5_python_fiona=e82f8edfe95280339bea2cf9738a81f6

# default build path
BUILD_python_fiona=$BUILD_PATH/python_fiona/$(get_directory $URL_python_fiona)

# default recipe path
RECIPE_python_fiona=$RECIPES_PATH/python_fiona

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_fiona() {
  cd $BUILD_python_fiona

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_fiona() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed fiona; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_fiona() {
  try rsync -a $BUILD_python_fiona/ $BUILD_PATH/python_fiona/build-$ARCH/
  try cd $BUILD_PATH/python_fiona/build-$ARCH
  push_env

  export GDAL_CONFIG=$STAGE_PATH/bin/gdal-config
  DYLD_LIBRARY_PATH=$STAGE_PATH/lib try $PYTHON setup.py install
  unset GDAL_CONFIG

  pop_env
}

# function called after all the compile have been done
function postbuild_python_fiona() {
   if ! python_package_installed_verbose fiona; then
      error "Missing python package fiona"
   fi
}

# function to append information to config file
function add_config_info_python_fiona() {
  append_to_config_file "# python_fiona-${VERSION_python_fiona}: ${DESC_python_fiona}"
  append_to_config_file "export VERSION_python_fiona=${VERSION_python_fiona}"
}