#!/bin/bash

DESC_python_libpysal="A library of spatial analysis functions."

DEPS_python_libpysal=(
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


# md5 of the package

# default build path
BUILD_python_libpysal=${DEPS_BUILD_PATH}/python_libpysal/v${VERSION_python_libpysal}

# default recipe path
RECIPE_python_libpysal=$RECIPES_PATH/python_libpysal

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_libpysal() {
  try mkdir -p $BUILD_python_libpysal
  cd $BUILD_python_libpysal


}

function shouldbuild_python_libpysal() {
  # not sure why but when pysal is imported first
  # it triggers Symbol not found: _GEOSArea on libspatialite
  if python_package_installed fiona,pysal; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_libpysal() {
   if ! python_package_installed_verbose fiona,pysal; then
      error "Missing python package pysal"
   fi
}

# function to append information to config file
function add_config_info_python_libpysal() {
  append_to_config_file "# python_libpysal-${VERSION_python_libpysal}: ${DESC_python_libpysal}"
  append_to_config_file "export VERSION_python_pysal=${VERSION_python_pysal}"
  append_to_config_file "export VERSION_python_libpysal=${VERSION_python_libpysal}"
}