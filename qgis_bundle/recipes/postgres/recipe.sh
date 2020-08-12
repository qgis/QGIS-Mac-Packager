#!/bin/bash

function check_postgres() {
  env_var_exists VERSION_postgres
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
}

function bundle_postgres() {
  try cp -av $DEPS_LIB_DIR/libpq.*dylib $BUNDLE_LIB_DIR/
}

function postbundle_postgres() {
 install_name_id @rpath/$LINK_libpq $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libpq
}
