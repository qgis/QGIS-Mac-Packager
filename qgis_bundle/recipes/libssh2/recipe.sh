#!/bin/bash

function check_libssh2() {
  env_var_exists VERSION_libssh2
  env_var_exists LINK_libssh2
}

function bundle_libssh2() {
  try cp -av $DEPS_LIB_DIR/libssh2.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_libssh2() {
  install_name_id  @rpath/$LINK_libssh2 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libssh2

  install_name_change $DEPS_LIB_DIR/$LINK_libssh2 @rpath/$LINK_libssh2 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libssh2
}

function fix_binaries_libssh2_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libssh2
}

function fix_paths_libssh2() {
  :
}

function fix_paths_libssh2_check() {
  :
}