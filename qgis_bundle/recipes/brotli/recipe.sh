#!/bin/bash

function check_brotli() {
  env_var_exists VERSION_brotli
}

function bundle_brotli() {
  try cp -av $DEPS_LIB_DIR/libbrotlicommon.*dylib $BUNDLE_LIB_DIR
  try cp -av $DEPS_LIB_DIR/libbrotlidec.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_brotli() {
  install_name_id @rpath/$LINK_libbrotlicommon $BUNDLE_LIB_DIR/$LINK_libbrotlicommon


  for i in \
    $LINK_libbrotlicommon \
    $LINK_libbrotlidec
  do
    install_name_id @rpath/$i $BUNDLE_LIB_DIR/$i
    install_name_change $DEPS_LIB_DIR/$LINK_libbrotlicommon @rpath/$LINK_libbrotlicommon $BUNDLE_LIB_DIR/$i
    install_name_change $DEPS_LIB_DIR/$LINK_libbrotlidec @rpath/$LINK_libbrotlidec $BUNDLE_LIB_DIR/$i
  done
}

function fix_binaries_brotli_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libbrotlicommon
  verify_binary $BUNDLE_LIB_DIR/$LINK_libbrotlidec
}

function fix_paths_brotli() {
  :
}

function fix_paths_brotli_check() {
  :
}
