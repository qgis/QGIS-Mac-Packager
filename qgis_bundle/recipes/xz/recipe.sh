#!/bin/bash

function check_xz() {
  env_var_exists VERSION_xz
  env_var_exists LINK_liblzma
}

function bundle_xz() {
  try cp -av $DEPS_LIB_DIR/liblzma.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_xz() {
  install_name_id @rpath/$LINK_liblzma $BUNDLE_LIB_DIR/$LINK_liblzma
}

function fix_binaries_xz_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_liblzma
}

function fix_paths_xz() {
  :
}

function fix_paths_xz_check() {
  :
}