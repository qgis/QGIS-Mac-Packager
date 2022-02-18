#!/bin/bash

DESC_python_all="python and all its site-packages"

# version of your package
VERSION_python_all=${QGIS_DEPS_RELEASE_VERSION}

# dependencies of this recipe
DEPS_python_all=(
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
)

# url of the package
URL_python_all=

# md5 of the package
MD5_python_all=

# default build path
BUILD_python_all=${DEPS_BUILD_PATH}/python_all/python_all

# default recipe path
RECIPE_python_all=$RECIPES_PATH/python_all

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_all() {
  :
}

function shouldbuild_python_all() {
  :
}



# function called after all the compile have been done
function postbuild_python_all() {
   :
}

# function to append information to config file
function add_config_info_python_all() {
  :
}