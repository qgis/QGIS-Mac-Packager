#!/bin/bash

function check_openssl() {
  env_var_exists VERSION_openssl
  env_var_exists LINK_libssl
  env_var_exists LINK_libcrypto
}

function bundle_openssl() {
  try cp -av $DEPS_LIB_DIR/libssl.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libcrypto.*dylib $BUNDLE_LIB_DIR

  # TODO issue 32
}

function fix_binaries_openssl() {
  install_name_id  @rpath/$LINK_libssl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libssl
  install_name_id  @rpath/$LINK_libcrypto $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libcrypto
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