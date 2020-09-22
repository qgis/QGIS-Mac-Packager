#!/bin/bash

function check_fastcgi() {
  env_var_exists VERSION_fastcgi
  env_var_exists LINK_fastcgi
}

function bundle_fastcgi() {
  try cp -av $DEPS_LIB_DIR/libfcgi.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_fastcgi() {
  install_name_id  @rpath/$LINK_fastcgi $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_fastcgi
}

function fix_binaries_fastcgi_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_fastcgi
}

function fix_paths_fastcgi() {
  :
}

function fix_paths_fastcgi_check() {
  :
}