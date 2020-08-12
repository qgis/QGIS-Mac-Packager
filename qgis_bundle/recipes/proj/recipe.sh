#!/bin/bash

function check_proj() {
  env_var_exists VERSION_proj
  env_var_exists LINK_libproj
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
}

function bundle_proj() {
  try cp -av $DEPS_LIB_DIR/libproj*dylib $BUNDLE_LIB_DIR

  # see src/app/main.cpp for PROJ_LIB setup for bundle
  try rsync -av $DEPS_SHARE_DIR/proj $BUNDLE_RESOURCES_DIR/
}

function postbundle_proj() {
 install_name_id  @rpath/$LINK_libproj $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libproj

 install_name_change $DEPS_LIB_DIR/$LINK_sqlite @rpath/$LINK_sqlite $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libproj
}
