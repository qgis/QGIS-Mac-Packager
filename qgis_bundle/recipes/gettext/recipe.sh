#!/bin/bash

function check_gettext() {
  env_var_exists VERSION_gettext
  env_var_exists LINK_libintl
}

function bundle_gettext() {
  try cp -av $DEPS_LIB_DIR/libintl.*dylib $BUNDLE_LIB_DIR
}

function postbundle_gettext() {
  install_name_id @rpath/$LINK_libintl $BUNDLE_LIB_DIR/$LINK_libintl
}
