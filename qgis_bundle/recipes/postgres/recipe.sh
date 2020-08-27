#!/bin/bash

function check_postgres() {
  env_var_exists VERSION_postgres
  env_var_exists QGIS_VERSION
}

function bundle_postgres() {
  try cp -av $DEPS_LIB_DIR/libpq.*dylib $BUNDLE_LIB_DIR/
}

function fix_binaries_postgres() {
  install_name_id @rpath/$LINK_libpq $BUNDLE_LIB_DIR/$LINK_libpq

  for i in \
    $LINK_libssl \
    $LINK_libcrypto
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libpq
  done
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