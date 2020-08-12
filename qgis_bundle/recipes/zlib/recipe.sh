#!/bin/bash

function check_zlib() {
  env_var_exists VERSION_zlib
  env_var_exists LINK_zlib
}

function bundle_zlib() {
  try cp -av $DEPS_LIB_DIR/libz.*dylib $BUNDLE_LIB_DIR
}

function postbundle_zlib() {
  install_name_id @rpath/$LINK_zlib $BUNDLE_LIB_DIR/$LINK_zlib

  install_name_change $DEPS_LIB_DIR/$LINK_zlib @rpath/$LINK_zlib $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_zlib
  install_name_change $DEPS_LIB_DIR/$LINK_liblzma @rpath/$LINK_liblzma $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_zlib
}

