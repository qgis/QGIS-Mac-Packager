#!/bin/bash

DESC_qgis="QGIS Dependancies"

# version of your package
VERSION_qgis_deps=${RELEASE_VERSION}

# dependencies of this recipe
DEPS_qgis_deps=(
  python
  sqlite
  exiv2
  gdal
  hdf5
  netcdf
  libzip
  qca
  libtasn1
  python_packages
  spatialindex
  gsl
  qscintilla
  spatialite
  qtkeychain
  qwt
  xz
  bison
  flex
)

# url of the package
URL_qgis_deps=

# md5 of the package
MD5_qgis_deps=

# default build path
BUILD_qgis_deps=$BUILD_PATH/qgis_deps/$(get_directory $URL_qgis_deps)

# default recipe path
RECIPE_qgis_deps=$RECIPES_PATH/qgis_deps

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qgis_deps() {
  : # noop
}

function shouldbuild_qgis_deps() {
   : # noop
}

# function called to build the source code
function build_qgis_deps() {
  : # noop
}

# function called after all the compile have been done
function postbuild_qgis_deps() {
  : # noop
}
