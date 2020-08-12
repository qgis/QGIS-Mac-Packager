#!/bin/bash

function check_libtool() {
  env_var_exists VERSION_libtool
  env_var_exists LINK_libltdl
}

function bundle_libtool() {
  try cp -av $DEPS_LIB_DIR/libltdl.*dylib $BUNDLE_LIB_DIR
}

function postbundle_libtool() {
  install_name_id  @rpath/$LINK_libltdl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_libltdl
}
