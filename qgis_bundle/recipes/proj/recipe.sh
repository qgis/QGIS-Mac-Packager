#!/bin/bash

function check_proj() {
  env_var_exists VERSION_proj
  env_var_exists LINK_libproj
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
}

function bundle_proj() {
  try cp -av $DEPS_LIB_DIR/libproj*dylib $BUNDLE_LIB_DIR

  # see src/app/main.cpp for env setup for bundle
  # see src/app/qgsapplication/cpp in QgsApplication::init for PROJ setup paths
  try rsync -av $DEPS_SHARE_DIR/proj $BUNDLE_RESOURCES_DIR/

  if [[ "$OLD_PROJ" == "true" ]]; then
    # https://github.com/qgis/QGIS-Mac-Packager/issues/47
    GRID_DIR=$QGIS_BUNDLE_SCRIPT_DIR/../../proj-datumgrid/grids
    if [ ! -d "$GRID_DIR" ]; then
      error "Missing $GRID_DIR. Use scripts/fetch_proj-datumgrid.bash to download grids"
    fi
    try cp -av $GRID_DIR/* $BUNDLE_RESOURCES_DIR/proj/
  fi
}

function fix_binaries_proj() {
  install_name_id @rpath/$LINK_libproj $BUNDLE_LIB_DIR/$LINK_libproj

  for i in \
      $LINK_sqlite \
      $LINK_libcurl \
      $LINK_libtiff
  do
      install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libproj
  done
}

function fix_binaries_proj_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libproj
}

function fix_paths_proj() {
  :
}

function fix_paths_proj_check() {
  :
}