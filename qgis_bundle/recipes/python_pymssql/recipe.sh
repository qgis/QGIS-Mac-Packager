#!/bin/bash

function check_python_pymssql() {
  env_var_exists VERSION_python_pymssql
}

function bundle_python_pymssql() {
  :
}

function fix_binaries_python_pymssql() {
  install_name_change $DEPS_LIB_DIR/$LINK_sybdb @rpath/$LINK_sybdb  $BUNDLE_PYTHON_SITE_PACKAGES_DIR/_mssql.cpython-${VERSION_major_python//./}-darwin.so
  install_name_change $DEPS_LIB_DIR/$LINK_sybdb @rpath/$LINK_sybdb  $BUNDLE_PYTHON_SITE_PACKAGES_DIR/pymssql.cpython-${VERSION_major_python//./}-darwin.so
}

function fix_binaries_python_pymssql_check() {
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/_mssql.cpython-${VERSION_major_python//./}-darwin.so
  verify_binary $BUNDLE_PYTHON_SITE_PACKAGES_DIR/pymssql.cpython-${VERSION_major_python//./}-darwin.so
}

function fix_paths_python_pymssql() {
  :
}

function fix_paths_python_pymssql_check() {
  :
}
