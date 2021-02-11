#!/bin/bash

function check_xerces() {
  env_var_exists VERSION_xerces
}

function bundle_xerces() {
  try cp -av $DEPS_LIB_DIR/libxerces*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_xerces() {
  install_name_id @rpath/$LINK_libxerces_c $BUNDLE_LIB_DIR/$LINK_libxerces_c

  for i in \
    $LINK_libicuuc \
    $LINK_libicudata \
    $LINK_libcurl
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libxerces_c
  done
}

function fix_binaries_xerces_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libxerces_c
}

function fix_paths_xerces() {
  :
}

function fix_paths_xerces_check() {
  :
}