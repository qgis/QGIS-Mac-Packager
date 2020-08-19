#!/bin/bash

function check_libffi() {
  env_var_exists VERSION_libffi
  env_var_exists LINK_libffi
}

function bundle_libffi() {
  try cp -av $DEPS_LIB_DIR/libffi.*dylib $BUNDLE_LIB_DIR
}

function fix_binaries_libffi() {
  install_name_id @rpath/$LINK_libffi $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libffi
}

function fix_binaries_libffi_check() {
  verify_binary $BUNDLE_LIB_DIR/$LINK_libffi
}

function fix_paths_libffi() {
  :
}

function fix_paths_libffi_check() {
  :
}