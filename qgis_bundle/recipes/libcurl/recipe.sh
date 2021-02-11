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

  for i in \
    $LINK_libssh2 \
    $LINK_libssl \
    $LINK_libcrypto \
    $LINK_zlib \
    $LINK_zstd
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libcurl
  done
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