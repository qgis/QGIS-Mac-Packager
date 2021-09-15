#!/bin/bash

function check_rttopo() {
  if [[ "$WITH_RTTOPO" == "true" ]]; then
    env_var_exists VERSION_rttopo
  fi
}

function bundle_rttopo() {
  if [[ "$WITH_RTTOPO" == "true" ]]; then
    try cp -av $DEPS_LIB_DIR/librttopo.*dylib $BUNDLE_LIB_DIR
  fi
}

function fix_binaries_rttopo() {
  if [[ "$WITH_RTTOPO" == "true" ]]; then
    for i in \
      $LINK_libgeos_c \
      $LINK_rttopo
    do
      install_name_id @rpath/$i $BUNDLE_LIB_DIR/$i
      install_name_change $DEPS_LIB_DIR/$i @rpath/$i $BUNDLE_LIB_DIR/$LINK_rttopo
    done
  fi
}

function fix_binaries_rttopo_check() {
  if [[ "$WITH_RTTOPO" == "true" ]]; then
    verify_binary $BUNDLE_LIB_DIR/$LINK_rttopo
  fi
}

function fix_paths_rttopo() {
  :
}

function fix_paths_rttopo_check() {
  :
}
