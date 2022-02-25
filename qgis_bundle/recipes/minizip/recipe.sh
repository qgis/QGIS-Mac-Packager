#!/bin/bash

function check_minizip() {
  env_var_exists VERSION_minizip
  env_var_exists LINK_libminizip
}

function bundle_minizip() {
  try cp -av $DEPS_LIB_DIR/libminizip.*dylib $BUNDLE_LIB_DIR/
}

function fix_binaries_minizip() {
  install_name_id  @rpath/$LINK_minizip $BUNDLE_LIB_DIR/$LINK_libminizip

  for i in \
    $LINK_bz2 \
    $LINK_zstd \
    $LINK_zlib
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_libminizip
  done
}

function fix_binaries_minizip_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libminizip
}

function fix_paths_minizip() {
  :
}

function fix_paths_minizip_check() {
  :
}