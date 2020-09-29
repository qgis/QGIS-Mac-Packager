#!/bin/bash

DESC_qgis_deps="QGIS dependencies package"

# version of your package
VERSION_qgis_deps=${RELEASE_VERSION}

# dependencies of this recipe
DEPS_qgis_deps=(
    bison
    boost
    exiv2
    flex
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
    python
    python_packages
    python_matplotlib
    python_llvmlite
    python_pymssql
    python_statsmodels
    python_gdal
    python_fiona
    python_opencv
    python_scikit_learn
    python_pyproj
    python_h5py
    python_netcdf4
    python_numpy
    python_owslib
    python_pyqt5
    python_qscintilla
    python_sip
    python_pillow
    python_scipy
    python_shapely
    python_psycopg2
    python_pysal
    python_patsy
    python_pandas
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

# url of the package
URL_qgis_deps=

# md5 of the package
MD5_qgis_deps=

# default build path
BUILD_qgis_deps=$BUILD_PATH/qgis_deps/qgis_deps

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

# function to append information to config file
function add_config_info_qgis_deps() {
  append_to_config_file "# qgis_deps-${VERSION_qgis_deps}: ${DESC_qgis_deps}"
  append_to_config_file "export VERSION_qgis_deps=${VERSION_qgis_deps}"
}