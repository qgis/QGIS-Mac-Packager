#!/bin/bash

function check_webp() {
  env_var_exists VERSION_webp
}

function bundle_webp() {
  try cp -av $DEPS_LIB_DIR/libwebp.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_webp() {
  install_name_id @rpath/$LINK_libwebp $BUNDLE_LIB_DIR/$LINK_libwebp

  install_name_change $DEPS_LIB_DIR/$LINK_libwebp @rpath/$LINK_libwebp $BUNDLE_LIB_DIR/$LINK_libwebp
}

function fix_binaries_webp_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libwebp
}

function fix_paths_webp() {
  :
}

function fix_paths_webp_check() {
  :
}