#!/bin/bash

function check_xz() {
  env_var_exists VERSION_xz
  env_var_exists LINK_liblzma
}

function bundle_xz() {
  try cp -av $DEPS_LIB_DIR/liblzma.*dylib $BUNDLE_LIB_DIR
}

function postbundle_xz() {
  install_name_id @rpath/$LINK_liblzma $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_liblzma
}
