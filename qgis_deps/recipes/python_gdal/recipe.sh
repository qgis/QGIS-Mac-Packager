#!/bin/bash

DESC_python_gdal="Proj binding for python"

# version of your package
# keep in SYNC with gdal receipt
source $RECIPES_PATH/gdal/recipe.sh
VERSION_python_gdal=${VERSION_gdal}

# dependencies of this recipe
DEPS_python_gdal=(python python_pyproj gdal)

# url of the package
URL_python_gdal=${URL_gdal}

# md5 of the package
MD5_python_gdal=${MD5_gdal}

# default build path
BUILD_python_gdal=$BUILD_PATH/python_gdal/$(get_directory $URL_python_gdal)

# default recipe path
RECIPE_python_gdal=$RECIPES_PATH/python_gdal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_gdal() {
  cd $BUILD_python_gdal

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_python_gdal() {
  # If lib is newer than the sourcecode skip build
  if python_package_installed gdal; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_python_gdal() {
  try rsync -a $BUILD_python_gdal/ $BUILD_PATH/python_gdal/build-$ARCH/
  try cd $BUILD_PATH/python_gdal/build-$ARCH
  push_env

  cd swig/python
  try ${SED} "s;gdal_config=../../apps/gdal-config;gdal_config=$STAGE_PATH/bin/gdal-config;g" setup.cfg
  try $PYTHON setup.py build
  try $PYTHON setup.py install

  pop_env
}

# function called after all the compile have been done
function postbuild_python_gdal() {
   if ! python_package_installed gdal; then
      error "Missing python package gdal"
   fi
}

# function to append information to config file
function add_config_info_python_gdal() {
  append_to_config_file "# python_gdal-${VERSION_python_gdal}: ${DESC_python_gdal}"
  append_to_config_file "export VERSION_python_gdal=${VERSION_python_gdal}"
}