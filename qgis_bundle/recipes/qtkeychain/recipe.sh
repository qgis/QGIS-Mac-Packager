#!/bin/bash

function check_qtkeychain() {
  env_var_exists VERSION_qtkeychain
  env_var_exists LINK_qtkeychain
  env_var_exists VERSION_grass_major
  env_var_exists QGIS_VERSION
}

function bundle_qtkeychain() {
  try cp -av $DEPS_LIB_DIR/libqt5keychain.* $BUNDLE_LIB_DIR
}

function fix_binaries_qtkeychain() {
  install_name_delete_rpath $QT_BASE/lib $BUNDLE_LIB_DIR/$LINK_qtkeychain

  install_name_id @rpath/$LINK_qtkeychain $BUNDLE_LIB_DIR/$LINK_qtkeychain
}

function fix_binaries_qtkeychain_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_qtkeychain
}

function fix_paths_qtkeychain() {
  :
}

function fix_paths_qtkeychain_check() {
  :
}