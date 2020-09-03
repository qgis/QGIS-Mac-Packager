#!/bin/bash

function check_spatialite() {
  env_var_exists VERSION_spatialite
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
  env_var_exists LINK_spatialite
}

function bundle_spatialite() {
  try cp -av $DEPS_LIB_DIR/libspatialite.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/mod_spatialite.*so $BUNDLE_LIB_DIR
}

function fix_binaries_spatialite() {
  install_name_id @rpath/$LINK_spatialite $BUNDLE_LIB_DIR/$LINK_spatialite

  for i in \
    $LINK_freexl \
    $LINK_libgeos_c \
    $LINK_libxml2 \
    $LINK_libproj \
    $LINK_sqlite \
    $LINK_zlib
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_spatialite
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/mod_spatialite.so
  done
}

function fix_binaries_spatialite_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_spatialite
  verify_binary $BUNDLE_LIB_DIR/mod_spatialite.so
}

function fix_paths_spatialite() {
  :
}

function fix_paths_spatialite_check() {
  :
}