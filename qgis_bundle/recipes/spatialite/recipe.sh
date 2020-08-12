#!/bin/bash

function check_spatialite() {
  env_var_exists VERSION_spatialite
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
  env_var_exists LINK_spatialite
}

function bundle_spatialite() {
  try cp -av $DEPS_LIB_DIR/libspatialite.*dylib $BUNDLE_LIB_DIR
}

function postbundle_spatialite() {
  install_name_id @rpath/$LINK_spatialite $BUNDLE_LIB_DIR/$LINK_spatialite

  for i in \
    $LINK_freexl \
    $LINK_libgeos_c \
    $LINK_libxml2 \
    $LINK_libproj \
    $LINK_sqlite \
    $LINK_zlib
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialite
  done
}

