#!/bin/bash

function check_freexl() {
  env_var_exists VERSION_freexl
  env_var_exists LINK_freexl
}

function bundle_freexl() {
  try cp -av $DEPS_LIB_DIR/libfreexl.*dylib $BUNDLE_LIB_DIR
}

function postbundle_freexl() {
  install_name_id  @rpath/$LINK_freexl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_freexl

  install_name_change $DEPS_LIB_DIR/$LINK_freexl @rpath/$LINK_freexl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_spatialite
  install_name_change $DEPS_LIB_DIR/$LINK_freexl @rpath/$LINK_freexl $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
}
