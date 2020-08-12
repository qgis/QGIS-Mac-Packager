#!/bin/bash

function check_sqlite() {
  env_var_exists VERSION_sqlite
  env_var_exists QGIS_VERSION
  env_var_exists VERSION_grass_major
  env_var_exists LINK_sqlite
}

function bundle_sqlite() {
    try cp -av $DEPS_LIB_DIR/$LINK_sqlite $BUNDLE_LIB_DIR/$LINK_sqlite
    mk_sym_link $BUNDLE_LIB_DIR $LINK_sqlite libsqlite3.dylib
}

function postbundle_sqlite() {
 install_name_id @rpath/$LINK_sqlite $BUNDLE_LIB_DIR/$LINK_sqlite
}
