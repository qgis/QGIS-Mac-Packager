#!/bin/bash

function check_postgres() {
  env_var_exists VERSION_postgres
  env_var_exists QGIS_VERSION
}

function bundle_postgres() {
  try cp -av $DEPS_LIB_DIR/libpq.*dylib $BUNDLE_LIB_DIR/
}

function fix_binaries_postgres() {
  install_name_id @rpath/$LINK_libpq $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libpq
}

function fix_binaries_postgres_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libpq
}

function fix_paths_postgres() {
  :
}

function fix_paths_postgres_check() {
  :
}