#!/bin/bash

DESC_python_geopandas="python geopandas"

# version of your package
# keep in SYNC with proj receipt
VERSION_python_geopandas=0.8.1

# dependencies of this recipe
DEPS_python_geopandas=(
  python
  python_packages
  python_rtree
  python_pyproj
  python_shapely
  python_fiona
  python_pandas
  python_psycopg2
  python_matplotlib
)

# url of the package
URL_python_geopandas=https://github.com/geopandas/geopandas/archive/v$VERSION_python_geopandas.tar.gz

# md5 of the package
MD5_python_geopandas=dc241fdd62012c3b5ae0e990ba20df26

# default build path
BUILD_python_geopandas=${DEPS_BUILD_PATH}/python_geopandas/$(get_directory $URL_python_geopandas)

# default recipe path
RECIPE_python_geopandas=$RECIPES_PATH/python_geopandas

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_geopandas() {
  cd $BUILD_python_geopandas
  try rsync -a $BUILD_python_geopandas/ ${DEPS_BUILD_PATH}/python_geopandas/build-${ARCH}


}

function shouldbuild_python_geopandas() {
  # not sure why but when geopandas is imported first
  # it triggers Symbol not found: _GEOSArea on libspatialite
  if python_package_installed "fiona,geopandas"; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_geopandas() {
  if ! python_package_installed_verbose "fiona,geopandas"; then
    error "Missing python package geopandas"
  fi
}

# function to append information to config file
function add_config_info_python_geopandas() {
  append_to_config_file "# python_geopandas-${VERSION_python_geopandas}: ${DESC_python_geopandas}"
  append_to_config_file "export VERSION_python_geopandas=${VERSION_python_geopandas}"
}