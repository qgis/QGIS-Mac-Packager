#!/bin/bash

function check_png() {
  env_var_exists VERSION_png
}

function bundle_png() {
  try cp -av $DEPS_LIB_DIR/libpng*dylib $BUNDLE_LIB_DIR
}

function postbundle_png() {
  install_name_id @rpath/$LINK_libpng $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libpng
  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libpng
}
