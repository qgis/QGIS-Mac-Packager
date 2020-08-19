#!/bin/bash

function check_jpeg() {
  env_var_exists VERSION_jpeg
  env_var_exists LINK_jpeg
}

function bundle_jpeg() {
  try cp -av $DEPS_LIB_DIR/libjpeg.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_jpeg() {
 install_name_id  @rpath/$LINK_jpeg $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_jpeg
}

function fix_binaries_jpeg_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_jpeg
}

function fix_paths_jpeg() {
  :
}

function fix_paths_jpeg_check() {
  :
}