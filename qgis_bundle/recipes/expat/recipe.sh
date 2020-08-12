#!/bin/bash

function check_expat() {
  env_var_exists VERSION_expat
  env_var_exists LINK_expat
}

function bundle_expat() {
  try cp -av $DEPS_LIB_DIR/libexpat.*dylib $BUNDLE_LIB_DIR
}

function postbundle_expat() {
 install_name_id  @rpath/$LINK_expat $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_expat




 install_name_change $DEPS_LIB_DIR/$LINK_expat @rpath/$LINK_expat $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_expat





}

