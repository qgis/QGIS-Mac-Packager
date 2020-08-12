#!/bin/bash

function check_libzip() {
  env_var_exists VERSION_libzip
  env_var_exists LINK_libzip
}

function bundle_libzip() {
  try cp -av $DEPS_LIB_DIR/libzip.*dylib $BUNDLE_LIB_DIR
}

function postbundle_libzip() {
  install_name_id @rpath/$LINK_libzip $BUNDLE_LIB_DIR/$LINK_libzip
  install_name_change $DEPS_LIB_DIR/$LINK_bz2 @rpath/$LINK_bz2 $BUNDLE_LIB_DIR/$LINK_libzip
}
