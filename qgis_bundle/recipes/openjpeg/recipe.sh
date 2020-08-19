#!/bin/bash

function check_openjpeg() {
  env_var_exists VERSION_openjpeg
}

function bundle_openjpeg() {
  try cp -av $DEPS_LIB_DIR/libopenjp2.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_openjpeg() {
  install_name_id @rpath/$LINK_openjpeg $BUNDLE_LIB_DIR/$LINK_openjpeg
}

function fix_binaries_openjpeg_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_openjpeg
}

function fix_paths_openjpeg() {
  :
}

function fix_paths_openjpeg_check() {
  :
}