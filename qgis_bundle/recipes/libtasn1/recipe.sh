#!/bin/bash

function check_libtasn1() {
  env_var_exists VERSION_libtasn1
  env_var_exists LINK_libtasn1
}

function bundle_libtasn1() {
  try cp -av $DEPS_LIB_DIR/libtasn1*dylib $BUNDLE_LIB_DIR
}

function postbundle_libtasn1() {
 install_name_id @rpath/$LINK_libtasn1 $BUNDLE_LIB_DIR/$LINK_libtasn1
}
