#!/bin/bash

function check_xerces() {
  env_var_exists VERSION_xerces
}

function bundle_xerces() {
  try cp -av $DEPS_LIB_DIR/libxerces*dylib $BUNDLE_LIB_DIR
}

function postbundle_xerces() {
  install_name_id @rpath/$LINK_libxerces_c $BUNDLE_LIB_DIR/$LINK_libxerces_c

  install_name_change $DEPS_LIB_DIR/$LINK_libxerces_c @rpath/$LINK_libxerces_c $BUNDLE_CONTENTS_DIR/MacOS/lib/$LINK_gdal
}

function add_config_info_xerces() {
    :
}
