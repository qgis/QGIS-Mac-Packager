#!/bin/bash

function check_libxml2() {
  env_var_exists VERSION_libxml2
  env_var_exists LINK_libxml2
}

function bundle_libxml2() {
  try cp -av $DEPS_LIB_DIR/libxml2.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_libxml2() {
  install_name_id @rpath/$LINK_libxml2 $BUNDLE_LIB_DIR/$LINK_libxml2

  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_LIB_DIR/$LINK_libxml2
}

function fix_binaries_libxml2_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libxml2
}

function fix_paths_libxml2() {
  :
}

function fix_paths_libxml2_check() {
  :
}