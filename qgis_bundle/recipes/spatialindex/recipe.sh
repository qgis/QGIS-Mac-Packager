#!/bin/bash

function check_spatialindex() {
  env_var_exists VERSION_spatialindex
  env_var_exists LINK_spatialindex
}

function bundle_spatialindex() {
  try cp -av $DEPS_LIB_DIR/libspatialindex*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_spatialindex() {
  install_name_id @rpath/libspatialindex_c.6.dylib $BUNDLE_LIB_DIR/$LINK_spatialindex_c
  install_name_id @rpath/$LINK_spatialindex $BUNDLE_LIB_DIR/$LINK_spatialindex

  install_name_change $DEPS_LIB_DIR/$LINK_spatialindex @rpath/$LINK_spatialindex $BUNDLE_LIB_DIR/$LINK_spatialindex_c
}

function fix_binaries_spatialindex_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_spatialindex
  verify_binary $BUNDLE_LIB_DIR/$LINK_spatialindex_c
}

function fix_paths_spatialindex() {
  :
}

function fix_paths_spatialindex_check() {
  :
}