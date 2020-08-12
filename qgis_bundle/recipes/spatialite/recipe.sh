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

 install_name_change $DEPS_LIB_DIR/$LINK_freexl @rpath/$LINK_freexl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialite
 install_name_change $DEPS_LIB_DIR/$LINK_libgeos_c @rpath/$LINK_libgeos_c $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialite
 install_name_change $DEPS_LIB_DIR/$LINK_libxml2 @rpath/$LINK_libxml2 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialite
 install_name_change $DEPS_LIB_DIR/$LINK_libproj @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialite
 install_name_change $DEPS_LIB_DIR/$LINK_sqlite @rpath/$LINK_sqlite $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialite
 install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialite
}

