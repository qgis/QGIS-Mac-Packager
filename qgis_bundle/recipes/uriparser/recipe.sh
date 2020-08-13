#!/bin/bash

function check_uriparser() {
  env_var_exists VERSION_uriparser
  env_var_exists LINK_liburiparser
}

function bundle_uriparser() {
  try cp -av $DEPS_LIB_DIR/liburiparser.*dylib $BUNDLE_LIB_DIR
}

function postbundle_uriparser() {
  install_name_id @rpath/$LINK_liburiparser $BUNDLE_LIB_DIR/$LINK_liburiparser
}

