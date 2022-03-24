#!/bin/bash

DESC_python_spaghetti="SPAtial GrapHs: nETworks, Topology, & Inference"

DEPS_python_spaghetti=(
  spatialite
  python_numpy
  python_pysal
  python_rtree
  python_scipy
)


# md5 of the package

# default build path
BUILD_python_spaghetti=${DEPS_BUILD_PATH}/python_spaghetti/v${VERSION_python_spaghetti}

# default recipe path
RECIPE_python_spaghetti=$RECIPES_PATH/python_spaghetti

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_python_spaghetti() {
  try mkdir -p $BUILD_python_spaghetti
  cd $BUILD_python_spaghetti


}

function shouldbuild_python_spaghetti() {
  # not sure why but when spaghetti is imported first
  # it triggers Symbol not found: _GEOSArea on libspatialite
  if python_package_installed fiona,spaghetti; then
    DO_BUILD=0
  fi
}



# function called after all the compile have been done
function postbuild_python_spaghetti() {
   if ! python_package_installed_verbose fiona,spaghetti; then
      error "Missing python package spaghetti"
   fi
}

# function to append information to config file
function add_config_info_python_spaghetti() {
  append_to_config_file "# python_spaghetti-${VERSION_python_spaghetti}: ${DESC_python_spaghetti}"
  append_to_config_file "export VERSION_python_spaghetti=${VERSION_python_spaghetti}"
}