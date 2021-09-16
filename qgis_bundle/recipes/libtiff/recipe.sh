#!/bin/bash

function check_libtiff() {
  env_var_exists VERSION_libtiff
}

function bundle_libtiff() {
  try cp -av $DEPS_LIB_DIR/libtiff.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_libtiff() {
  install_name_id @rpath/$LINK_libtiff $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libtiff

  for i in \
    $LINK_jpeg \
    $LINK_libwebp \
    $LINK_zlib \
    $LINK_zstd \
    $LINK_webp \
    $LINK_liblerc
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libtiff
  done
}

function fix_binaries_libtiff_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libtiff
}

function fix_paths_libtiff() {
  :
}

function fix_paths_libtiff_check() {
  :
}