#!/bin/bash

function check_fontconfig() {
  env_var_exists VERSION_fontconfig
}

function bundle_fontconfig() {
  try cp -av $DEPS_LIB_DIR/libfontconfig.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_fontconfig() {
  install_name_id @rpath/$LINK_fontconfig $BUNDLE_LIB_DIR/$LINK_fontconfig

  for i in \
    $LINK_bz2 \
    $LINK_expat \
    $LINK_freetype \
    $LINK_libintl \
    $LINK_zlib \
    $LINK_libpng \
    $LINK_libbrotlidec
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_fontconfig
  done
}

function fix_binaries_fontconfig_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_fontconfig
}

function fix_paths_fontconfig() {
  :
}

function fix_paths_fontconfig_check() {
  :
}
