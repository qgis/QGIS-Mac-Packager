#!/bin/bash

function check_openssl() {
  env_var_exists VERSION_openssl
  env_var_exists LINK_libssl
  env_var_exists LINK_libcrypto
}

function bundle_openssl() {
  try cp -av $DEPS_LIB_DIR/libssl.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libcrypto.*dylib $BUNDLE_LIB_DIR

  # https://github.com/qgis/QGIS-Mac-Packager/issues/32
  try mkdir -p $BUNDLE_RESOURCES_DIR/certs
  try cp -av $DEPS_ROOT_DIR/certs/* $BUNDLE_RESOURCES_DIR/certs/
  mk_sym_link $BUNDLE_RESOURCES_DIR/certs rootcerts.pem certs.pem
}

function fix_binaries_openssl() {
  install_name_id  @rpath/$LINK_libssl $BUNDLE_LIB_DIR/$LINK_libssl
  install_name_id  @rpath/$LINK_libcrypto $BUNDLE_LIB_DIR/$LINK_libcrypto
}

function fix_binaries_openssl_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libssl
  verify_binary $BUNDLE_LIB_DIR/$LINK_libcrypto
}

function fix_paths_openssl() {
  :
}

function fix_paths_openssl_check() {
  :
}