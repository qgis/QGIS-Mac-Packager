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

  install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libfreexl.1.dylib @rpath/libfreexl.1.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libspatialite.7.dylib
  install_name_change /opt/QGIS/qgis-deps-0.3.0/stage/lib/libfreexl.1.dylib @rpath/libfreexl.1.dylib $BUNDLE_CONTENTS_DIR/MacOS/lib/libgdal.26.dylib
}

function add_config_info_freexl() {
    :
}
