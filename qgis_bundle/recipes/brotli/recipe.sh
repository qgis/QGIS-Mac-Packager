#!/bin/bash

function check_brotli() {
  if [[ "$WITH_BROTLI" == "true" ]]; then
    env_var_exists VERSION_brotli
  fi
}

function bundle_brotli() {
  if [[ "$WITH_BROTLI" == "true" ]]; then
    try cp -av $DEPS_LIB_DIR/libbrotlicommon.*dylib $BUNDLE_LIB_DIR
    try cp -av $DEPS_LIB_DIR/libbrotlidec.*dylib $BUNDLE_LIB_DIR
  fi
}

function fix_binaries_brotli() {
  if [[ "$WITH_BROTLI" == "true" ]]; then
    install_name_id @rpath/$LINK_libbrotlicommon $BUNDLE_LIB_DIR/$LINK_libbrotlicommon


    for i in \
      $LINK_libbrotlicommon \
      $LINK_libbrotlidec
    do
      install_name_id @rpath/$i $BUNDLE_LIB_DIR/$i
      install_name_change $DEPS_LIB_DIR/$LINK_libbrotlicommon @rpath/$LINK_libbrotlicommon $BUNDLE_LIB_DIR/$i
      install_name_change $DEPS_LIB_DIR/$LINK_libbrotlidec @rpath/$LINK_libbrotlidec $BUNDLE_LIB_DIR/$i
    done
  fi
}

function fix_binaries_brotli_check() {
  if [[ "$WITH_BROTLI" == "true" ]]; then
    verify_binary $BUNDLE_LIB_DIR/$LINK_libbrotlicommon
    verify_binary $BUNDLE_LIB_DIR/$LINK_libbrotlidec
  fi
}

function fix_paths_brotli() {
  :
}

function fix_paths_brotli_check() {
  :
}
