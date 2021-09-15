#!/bin/bash

function check_python_rtree() {
  env_var_exists VERSION_python_rtree
}

function bundle_python_rtree() {
  :
}

function fix_binaries_python_rtree() {
  :
}

function fix_binaries_python_rtree_check() {
  :
}

function fix_paths_python_rtree() {
  # see https://github.com/qgis/QGIS-Mac-Packager/issues/80

  RTREE_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/Rtree-${VERSION_python_rtree}-py${VERSION_major_python}.egg
  if [ ! -d "$RTREE_EGG" ]
  then
      RTREE_EGG=$BUNDLE_PYTHON_SITE_PACKAGES_DIR/Rtree-${VERSION_python_rtree}-py${VERSION_major_python}-macosx-${MACOSX_DEPLOYMENT_TARGET}-x86_64.egg
  fi

  try rm $RTREE_EGG/rtree/core.py
  try cp -av $RECIPES_PATH/python_rtree/core.py $RTREE_EGG/rtree/core.py

  # remove reference to /usr/local/lib/libgeos_c.dylib
  clean_path $RTREE_EGG/rtree/_core.py
}

function fix_paths_python_rtree_check() {
  :
}