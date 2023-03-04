#!/bin/bash

function check_rttopo() {
  env_var_exists VERSION_rttopo
}

function bundle_rttopo() {
  try cp -av $DEPS_LIB_DIR/librttopo.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_rttopo() {
  for i in \
    $LINK_libgeos_c \
    $LINK_rttopo
  do
    install_name_id @rpath/$i $BUNDLE_LIB_DIR/$i
    install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_rttopo
  done
}

function fix_binaries_rttopo_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_rttopo
}

function fix_paths_rttopo() {
  :
}

function fix_paths_rttopo_check() {
  :
}
