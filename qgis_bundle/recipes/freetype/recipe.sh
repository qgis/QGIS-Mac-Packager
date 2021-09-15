#!/bin/bash

function check_freetype() {
  env_var_exists VERSION_freetype
}

function bundle_freetype() {
  try cp -av $DEPS_LIB_DIR/libfreetype.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_freetype() {
  install_name_id @rpath/$LINK_freetype $BUNDLE_LIB_DIR/$LINK_freetype

  for i in \
    $LINK_bz2 \
    $LINK_zlib \
    $LINK_libpng \
    $LINK_libbrotlidec
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_freetype
  done
}

function fix_binaries_freetype_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_freetype
}

function fix_paths_freetype() {
  :
}

function fix_paths_freetype_check() {
  :
}