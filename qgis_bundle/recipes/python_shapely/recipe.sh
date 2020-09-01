#!/bin/bash

function check_python_shapely() {
  env_var_exists VERSION_python_shapely
}

function bundle_python_shapely() {
  :
}

function fix_binaries_python_shapely() {
  :
}

function fix_binaries_python_shapely_check() {
  :
}

function fix_paths_python_shapely() {
  # the link creation should be in fact in bundle_python_shapely,
  # but since all site-packages are copied in python_packages,
  # do it here so we are sure the files are already there
  # see https://github.com/qgis/QGIS-Mac-Packager/issues/81
  try mv $BUNDLE_PYTHON_SITE_PACKAGES_DIR/shapely/geos.py $BUNDLE_PYTHON_SITE_PACKAGES_DIR/shapely/_geos.py
  try cp -av $RECIPES_PATH/python_shapely/geos.py $BUNDLE_PYTHON_SITE_PACKAGES_DIR/shapely/geos.py

  # remove reference to /usr/local/lib/libgeos_c.dylib
  clean_path $BUNDLE_PYTHON_SITE_PACKAGES_DIR/shapely/geos.py
}

function fix_paths_python_shapely_check() {
  :
}