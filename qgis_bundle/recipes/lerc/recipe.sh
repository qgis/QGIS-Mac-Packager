#!/bin/bash

function check_lerc() {
  if [[ "$WITH_LERC" == "true" ]]; then
    env_var_exists VERSION_lerc
  fi
}

function bundle_lerc() {
  if [[ "$WITH_LERC" == "true" ]]; then
    try cp -av $DEPS_LIB_DIR/libLerc.*dylib $BUNDLE_LIB_DIR
  fi
}

function fix_binaries_lerc() {
  if [[ "$WITH_LERC" == "true" ]]; then
    install_name_id @rpath/$LINK_liblerc $BUNDLE_LIB_DIR/$LINK_liblerc
  fi
}

function fix_binaries_lerc_check() {
  if [[ "$WITH_LERC" == "true" ]]; then
    verify_binary $BUNDLE_LIB_DIR/$LINK_liblerc
  fi
}

function fix_paths_lerc() {
  :
}

function fix_paths_lerc_check() {
  :
}
