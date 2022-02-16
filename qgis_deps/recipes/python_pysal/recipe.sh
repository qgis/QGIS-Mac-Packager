#!/bin/bash

DESC_python_pysal="A library of spatial analysis functions."

# version of your package
VERSION_python_pysal=2.5.0
VERSION_python_libpysal=4.5.1


# dependencies of this recipe
DEPS_python_pysal=(
  python
  python_scipy
  python_packages
  python_numpy
  python_pandas
  python_scikit_learn
  python_matplotlib
  python_rtree
  python_geopandas
  python_numba
  python_rasterio
)

# url of the package
URL_python_pysal=

# md5 of the package
MD5_python_pysal=

# default build path
BUILD_python_pysal=$BUILD_PATH/python_pysal/v${VERSION_python_pysal}

# default recipe path
RECIPE_python_pysal=$RECIPES_PATH/python_pysal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_pysal() {
  try mkdir -p $BUILD_python_pysal
  cd $BUILD_python_pysal


}

function shouldbuild_python_pysal() {
  # not sure why but when pysal is imported first
  # it triggers Symbol not found: _GEOSArea on libspatialite
  if python_package_installed fiona,pysal; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_pysal() {
   if ! python_package_installed_verbose fiona,pysal; then
      error "Missing python package pysal"
   fi
}

# function to append information to config file
function add_config_info_python_pysal() {
  append_to_config_file "# python_pysal-${VERSION_python_pysal}: ${DESC_python_pysal}"
  append_to_config_file "export VERSION_python_libpysal=${VERSION_python_libpysal}"
  append_to_config_file "export VERSION_python_pysal=${VERSION_python_pysal}"
}