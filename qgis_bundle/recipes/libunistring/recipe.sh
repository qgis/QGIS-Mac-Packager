#!/bin/bash

function check_libunistring() {
  env_var_exists VERSION_libunistring
  env_var_exists LINK_libunistring
}

function bundle_libunistring() {
  try cp -av $DEPS_LIB_DIR/libunistring.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_libunistring() {
  install_name_id  @rpath/$LINK_libunistring $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libunistring

  install_name_change $DEPS_LIB_DIR/$LINK_libunistring @rpath/$LINK_libunistring $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libunistring
}

function fix_binaries_libunistring_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libunistring
}

function fix_paths_libunistring() {
  :
}

function fix_paths_libunistring_check() {
  :
}