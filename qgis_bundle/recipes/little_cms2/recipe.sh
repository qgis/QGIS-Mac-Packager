#!/bin/bash

function check_little_cms2() {
  env_var_exists VERSION_little_cms2
}

function bundle_little_cms2() {
  try cp -av $DEPS_LIB_DIR/liblcms2.*dylib $BUNDLE_LIB_DIR
}

function postbundle_little_cms2() {
 install_name_id @rpath/$LINK_little_cms2 $BUNDLE_LIB_DIR/$LINK_little_cms2
}
