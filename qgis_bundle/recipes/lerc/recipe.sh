#!/bin/bash

function check_lerc() {
  env_var_exists VERSION_lerc
}

function bundle_lerc() {
  try cp -av $DEPS_LIB_DIR/libLerc.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_lerc() {
  install_name_id @rpath/$LINK_liblerc $BUNDLE_LIB_DIR/$LINK_liblerc
}

function fix_binaries_lerc_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_liblerc
}

function fix_paths_lerc() {
  :
}

function fix_paths_lerc_check() {
  :
}
