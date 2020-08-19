#!/bin/bash

function check_zstd() {
  env_var_exists VERSION_zstd
}

function bundle_zstd() {
  try cp -av $DEPS_LIB_DIR/libzstd.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_zstd() {
  install_name_id @rpath/$LINK_zstd $BUNDLE_LIB_DIR/$LINK_zstd
}

function fix_binaries_zstd_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_zstd
}

function fix_paths_zstd() {
  :
}

function fix_paths_zstd_check() {
  :
}