#!/bin/bash

function check_freetype() {
  env_var_exists VERSION_freetype
}

function bundle_freetype() {
  try cp -av $DEPS_LIB_DIR/libfreetype.*dylib $BUNDLE_LIB_DIR
}

function postbundle_freetype() {
  install_name_id @rpath/$LINK_freetype $BUNDLE_LIB_DIR/$LINK_freetype

  for i in \
    $LINK_bz2 \
    $LINK_zlib
  do
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_freetype
  done
}
