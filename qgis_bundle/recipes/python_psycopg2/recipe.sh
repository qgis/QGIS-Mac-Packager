#!/bin/bash

function check_python_psycopg2() {
  env_var_exists VERSION_python_psycopg2
}

function bundle_python_psycopg2() {
  :
}

function fix_binaries_python_psycopg2() {
  for i in \
    $LINK_libssl \
    $LINK_libcrypto \
    $LINK_libpq
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_PYTHON_SITE_PACKAGES_DIR/psycopg2/_psycopg.cpython-${VERSION_major_python//./}m-darwin.so
  done
}

function fix_binaries_python_psycopg2_check() {
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/psycopg2/_psycopg.cpython-${VERSION_major_python//./}m-darwin.so
}

function fix_paths_python_psycopg2() {
  :
}

function fix_paths_python_psycopg2_check() {
  :
}