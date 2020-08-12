#!/bin/bash

function check_freetype() {
  env_var_exists VERSION_freetype
}

function bundle_freetype() {
  try cp -av $DEPS_LIB_DIR/libfreetype.* $BUNDLE_LIB_DIR
}

function postbundle_freetype() {
  install_name_id @rpath/$LINK_freetype $BUNDLE_LIB_DIR/$LINK_freetype

  install_name_change $DEPS_LIB_DIR/$LINK_bz2 @rpath/$LINK_bz2 $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_freetype
  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_freetype
}
