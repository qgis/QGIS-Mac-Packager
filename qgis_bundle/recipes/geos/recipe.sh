#!/bin/bash

function check_geos() {
  env_var_exists VERSION_geos
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
  env_var_exists $LINK_libgeos_c
}

function bundle_geos() {
    try cp -av $DEPS_LIB_DIR/libgeos_c.* $BUNDLE_LIB_DIR
    try cp -av $DEPS_LIB_DIR/libgeos.* $BUNDLE_LIB_DIR
}

function postbundle_geos() {
 install_name_id @rpath/$LINK_libgeos_c $BUNDLE_LIB_DIR/$LINK_libgeos_c
 install_name_id @rpath/$LINK_libgeos $BUNDLE_LIB_DIR/$LINK_libgeos

 install_name_change $DEPS_LIB_DIR/$LINK_libgeos @rpath/$LINK_libgeos $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libgeos_c
}
