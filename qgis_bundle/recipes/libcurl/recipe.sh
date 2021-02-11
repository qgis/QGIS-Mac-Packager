#!/bin/bash

function check_libcurl() {
  env_var_exists VERSION_libcurl
  env_var_exists LINK_libcurl
}

function bundle_libcurl() {
  try cp -av $DEPS_LIB_DIR/libcurl.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_libcurl() {
  install_name_id  @rpath/$LINK_libcurl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libcurl

  install_name_change $DEPS_LIB_DIR/$LINK_libcurl @rpath/$LINK_libcurl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libcurl
}

function fix_binaries_libcurl_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libcurl
}

function fix_paths_libcurl() {
  :
}

function fix_paths_libcurl_check() {
  :
}