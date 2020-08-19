#!/bin/bash

function check_sqlite() {
  env_var_exists VERSION_sqlite
  env_var_exists LINK_sqlite
}

function bundle_sqlite() {
  try cp -av $DEPS_LIB_DIR/$LINK_sqlite $BUNDLE_LIB_DIR/$LINK_sqlite
  mk_sym_link $BUNDLE_LIB_DIR $LINK_sqlite libsqlite3.dylib
}

function fix_binaries_sqlite() {
  install_name_id @rpath/$LINK_sqlite $BUNDLE_LIB_DIR/$LINK_sqlite

  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_LIB_DIR/$LINK_sqlite
}

function fix_binaries_sqlite_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_sqlite
}

function fix_paths_sqlite() {
  :
}

function fix_paths_sqlite_check() {
  :
}