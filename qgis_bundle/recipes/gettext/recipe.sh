#!/bin/bash

function check_gettext() {
  env_var_exists VERSION_gettext
  env_var_exists LINK_libintl
}

function bundle_gettext() {
  try cp -av $DEPS_LIB_DIR/libintl.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_gettext() {
  install_name_id @rpath/$LINK_libintl $BUNDLE_LIB_DIR/$LINK_libintl
}

function fix_binaries_gettext_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libintl
}

function fix_paths_gettext() {
  :
}

function fix_paths_gettext_check() {
  :
}