#!/bin/bash

function check_spatialindex() {
  env_var_exists VERSION_spatialindex
  env_var_exists LINK_spatialindex
}

function bundle_spatialindex() {
  try cp -av $DEPS_LIB_DIR/libspatialindex*dylib $BUNDLE_LIB_DIR
}

function postbundle_spatialindex() {
  install_name_id @rpath/libspatialindex_c.6.dylib $DEPS_LIB_DIR/$LINK_spatialindex_c
  install_name_id @rpath/$LINK_spatialindex $BUNDLE_LIB_DIR/$LINK_spatialindex

  install_name_change $DEPS_LIB_DIR/$LINK_spatialindex @rpath/$LINK_spatialindex $DEPS_LIB_DIR/$LINK_spatialindex_c

}
