#!/bin/bash

DESC_qgis_deps="QGIS dependencies package"


DEPS_qgis_deps=(
    bison
    boost
    exiv2
    flex
    pdal
    gdal
    fastcgi
    grass
    poppler
    gsl
    hdf5
    libtasn1
    libzip
    mysql
    netcdf
    postgres
    protobuf
    proj_data
    python_all
    qca
    qscintilla
    qtextra
    qtkeychain
    qtwebkit
    qwt
    saga
    spatialindex
    spatialite
    sqlite
    xz
)

# default build path
BUILD_qgis_deps=${DEPS_BUILD_PATH}/qgis_deps/qgis_deps

# default recipe path
RECIPE_qgis_deps=$RECIPES_PATH/qgis_deps

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qgis_deps() {
  : # noop
}


# function called after all the compile have been done
function postbuild_qgis_deps() {
  : # noop
}

# function to append information to config file
function add_config_info_qgis_deps() {
  append_to_config_file "# qgis_deps-${VERSION_qgis_deps}: ${DESC_qgis_deps}"
  append_to_config_file "export VERSION_qgis_deps=${VERSION_qgis_deps}"
}