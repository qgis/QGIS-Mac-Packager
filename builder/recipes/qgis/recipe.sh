#!/bin/bash

# version of your package
VERSION_qgis=3.12.0

# dependencies of this recipe
DEPS_qgis=(geos proj spatialindex)

# url of the package
URL_qgis=https://github.com/qgis/QGIS/archive/final-${VERSION_qgis//./_}.tar.gz

# md5 of the package
MD5_qgis=c0179f75e2f3614321f912fa2c7ed323

# default build path
BUILD_qgis=$BUILD_PATH/qgis/$(get_directory $URL_qgis)

# default recipe path
RECIPE_qgis=$RECIPES_PATH/qgis

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qgis() {
  cd $BUILD_qgis

  # check marker
  if [ -f .patched ]; then
    return
  fi

  touch .patched
}

function shouldbuild_qgis() {
    echo "pass"
}

# function called to build the source code
function build_qgis() {
  try mkdir -p $BUILD_PATH/qgis/build-$ARCH
  try cd $BUILD_PATH/qgis/build-$ARCH

  push_env

  # try $CMAKE $BUILD_qgis .
  # try $MAKESMP
  # try $MAKE install

  pop_env
}

# function called after all the compile have been done
function postbuild_qgis() {
  echo "pass"
}
